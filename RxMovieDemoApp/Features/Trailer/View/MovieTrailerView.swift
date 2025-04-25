//
//  MovieTrailerView.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/3/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources
import RxTheme

protocol ClickTrailerDelegate: AnyObject {
    func clickTrailer(key: String)
}

protocol MovieTrailerDisplayLogic: AnyObject {
    func displayTrailers(viewModel: MovieTrailerScene.FetchTrailer.ViewModel)
    func displayError(message: String)
}

class MovieTrailerView: UIView, MovieTrailerDisplayLogic {
    private let disposeBag = DisposeBag()
    private var interactor: MovieTrailerBusinessLogic?
    private var movieId: Int
    
    weak var delegate: ClickTrailerDelegate?
    
    private lazy var trailerView: UITableView = {
        let tableView = UITableView()
        tableView.register(TrailerTableViewCell.self, forCellReuseIdentifier: "TrailerTableViewCell")
        return tableView
    }()
    
    init(id: Int) {
        self.movieId = id
        super.init(frame: .zero)
        setupVIP()
        trailerView.rx.setDelegate(self).disposed(by: self.disposeBag)
        setLayout()
        setupTheme()
        fetchTrailers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVIP() {
        let presenter = MovieTrailerPresenter()
        let interactor = MovieTrailerInteractor(presenter: presenter)
        
        self.interactor = interactor
        presenter.viewController = self
    }
    
    private func setLayout() {
        self.addSubview(trailerView)
        
        trailerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func fetchTrailers() {
        let request = MovieTrailerScene.FetchTrailer.Request(movieId: movieId)
        interactor?.fetchTrailers(request: request)
    }
    
    // MARK: - MovieTrailerDisplayLogic
    func displayTrailers(viewModel: MovieTrailerScene.FetchTrailer.ViewModel) {
        guard let trailers = viewModel.trailers else { return }
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, MovieTrailerDetail>>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "TrailerTableViewCell", for: indexPath) as! TrailerTableViewCell
                cell.selectionStyle = .none
                cell.confireCell(thumbnailStr: item.key, titleStr: item.name, timeStr: item.published_at)
                return cell
            }
        )
        
        Observable.just([SectionModel(model: "", items: trailers)])
            .observe(on: MainScheduler.instance)
            .bind(to: trailerView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        trailerView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let videoKey = trailers[indexPath.row].key
                self.delegate?.clickTrailer(key: videoKey)
            })
            .disposed(by: disposeBag)
    }
    
    func displayError(message: String) {
        print("Trailer View Error: \(message)")
    }
}

extension MovieTrailerView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension MovieTrailerView: ThemeChangeDelegate {
    func setupTheme() {
        self.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
    }
}
