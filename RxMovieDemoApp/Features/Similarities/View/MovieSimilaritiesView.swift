//
//  MovieSimilaritiesView.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/3/20.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources
import RxTheme

class MovieSimilarView: UIView, MovieSimilarDisplayLogic {
    private let disposeBag = DisposeBag()
    private var interactor: MovieSimilarBusinessLogic?
    private var movieId: Int
    
    private lazy var similarView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 170, height: 240)
        layout.estimatedItemSize = .zero
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieSimilaritiesCell.self, forCellWithReuseIdentifier: "MovieSimilaritiesCell")
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return collectionView
    }()
    
    init(id: Int) {
        self.movieId = id
        super.init(frame: .zero)
        setupVIP()
        setLayout()
        setupTheme()
        fetchSimilarMovies()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVIP() {
        let presenter = MovieSimilarPresenter()
        let interactor = MovieSimilarInteractor(presenter: presenter)
        
        self.interactor = interactor
        presenter.viewController = self
    }
    
    private func setLayout() {
        self.addSubview(similarView)
        similarView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func fetchSimilarMovies() {
        let request = MovieSimilar.FetchSimilar.Request(movieId: movieId)
        interactor?.fetchSimilarMovies(request: request)
    }
    
    // MARK: - MovieSimilarDisplayLogic
    func displaySimilarMovies(viewModel: MovieSimilar.FetchSimilar.ViewModel) {
        guard let movies = viewModel.similarMovies else { return }
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, MovieSimilaritiesDetail>>(
            configureCell: { _, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieSimilaritiesCell", for: indexPath) as! MovieSimilaritiesCell
                cell.configCell(imgURL: item.poster_path ?? "", voteRate: item.vote_average)
                return cell
            })
        
        Observable.just([SectionModel(model: "", items: movies)])
            .observe(on: MainScheduler.instance)
            .bind(to: self.similarView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        DispatchQueue.main.async {
            self.similarView.reloadData()
        }
    }
    
    func displayError(message: String) {
        print("Similar View Error: \(message)")
    }
}

extension MovieSimilarView: ThemeChangeDelegate {
    func setupTheme() {
        self.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
        self.similarView.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
    }
}
