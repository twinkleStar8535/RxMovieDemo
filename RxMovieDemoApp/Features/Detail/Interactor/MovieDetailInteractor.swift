//
//  MovieDetailInteractor.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/13.
//


import Foundation
import RxSwift


protocol MovieDetailBusinessLogic {
    func fetchMovieDetail(request: MovieDetail.FetchMovie.Request)
}

protocol MovieDetailDataStore {
    var movieId: Int? { get set }
}


class MovieDetailInteractor: MovieDetailBusinessLogic, MovieDetailDataStore {
    var presenter: MovieDetailPresentationLogic?
    var movieId: Int?
    
    private let disposeBag = DisposeBag()
    private let worker: MovieDetailWorker
    
    init(worker: MovieDetailWorker = MovieDetailWorker()) {
        self.worker = worker
    }
    
    func fetchMovieDetail(request: MovieDetail.FetchMovie.Request) {
        worker.fetchMovieDetail(id: request.movieId)
            .subscribe(onNext: { [weak self] movieDetail in
                let response = MovieDetail.FetchMovie.Response(movieDetail: movieDetail, error: nil)
                self?.presenter?.presentMovieDetail(response: response)
            }, onError: { [weak self] error in
                let response = MovieDetail.FetchMovie.Response(movieDetail: nil, error: error)
                self?.presenter?.presentMovieDetail(response: response)
                self?.presenter?.presentError(message: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
} 
