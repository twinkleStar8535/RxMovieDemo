//
//  MoviePosterView.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/3/26.
//

import UIKit
import RxSwift
import RxCocoa

protocol MoviePosterViewProtocol: AnyObject {
    func displayMoviePosters(viewModel: MoviePosterModels.ViewModel)
    func displayError(error: Error)
}

class MoviePosterView: UIView, MoviePosterViewProtocol {
    private let interactor: MoviePosterInteractorProtocol
    private let disposeBag = DisposeBag()
    private var aspectRatio = 0.7
    
    private lazy var posterView: UITableView = {
        let tableView = UITableView()
        tableView.register(PosterTableViewCell.self, forCellReuseIdentifier: "PosterTableViewCell")
        return tableView
    }()
    
    init(id: Int) {
        let presenter = MoviePosterPresenter(view: nil)
        self.interactor = MoviePosterInteractor(presenter: presenter)
        super.init(frame: .zero)
        
        presenter.view = self
        setLayout()
        fetchMoviePosters(id: id)
        setupTheme()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubview(posterView)
        posterView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func fetchMoviePosters(id: Int) {
        let request = MoviePosterModels.Request(movieId: "\(id)")
        interactor.fetchMoviePosters(request: request)
    }
    
    func displayMoviePosters(viewModel: MoviePosterModels.ViewModel) {
        Observable.just(viewModel.posters)
            .observe(on: MainScheduler.instance)
            .bind(to: posterView.rx.items) { [weak self] (tableView, indexPath, item) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "PosterTableViewCell") as! PosterTableViewCell
                cell.selectionStyle = .none
                cell.configureCell(posterPath: item.file_path,
                                 ratio: item.aspect_ratio,
                                 fixedWidth: self?.posterView.bounds.width ?? 0 - 20)
                self?.aspectRatio = item.aspect_ratio
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    func displayError(error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

extension MoviePosterView: ThemeChangeDelegate {
    func setupTheme() {
        self.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
    }
}
