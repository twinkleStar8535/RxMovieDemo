//
//  MoviePosterInteractor.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/12.
//


import Foundation
import RxSwift

protocol MoviePosterInteractorProtocol {
    func fetchMoviePosters(request: MoviePosterModels.Request)
}

class MoviePosterInteractor: MoviePosterInteractorProtocol {
    private let worker: MoviePosterWorker
    private let presenter: MoviePosterPresenterProtocol
    private let disposeBag = DisposeBag()
    
    init(worker: MoviePosterWorker = MoviePosterWorker(),
         presenter: MoviePosterPresenterProtocol) {
        self.worker = worker
        self.presenter = presenter
    }
    
    func fetchMoviePosters(request: MoviePosterModels.Request) {
        worker.fetchMoviePosters(movieId: request.movieId)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] poster in
                let response = MoviePosterModels.Response(posters: poster.backdrops)
                self?.presenter.presentMoviePosters(response: response)
            }, onError: { [weak self] error in
                self?.presenter.presentError(error: error)
            })
            .disposed(by: disposeBag)
    }
} 
