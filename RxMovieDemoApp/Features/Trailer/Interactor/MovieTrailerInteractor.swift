//
//  MovieTrailerInteractor.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/11.
//

import Foundation
import RxSwift


protocol MovieTrailerBusinessLogic: AnyObject {
    func fetchTrailers(request: MovieTrailerScene.FetchTrailer.Request)
}


class MovieTrailerInteractor: MovieTrailerBusinessLogic {
    var presenter: MovieTrailerPresentationLogic?
    private let worker: MovieTrailerWorker
    private let disposeBag = DisposeBag()
    
    init(presenter: MovieTrailerPresentationLogic? = nil,
         worker: MovieTrailerWorker = MovieTrailerWorker()) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func fetchTrailers(request: MovieTrailerScene.FetchTrailer.Request) {
        worker.fetchTrailers(movieId: request.movieId)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] trailer in
                let response = MovieTrailerScene.FetchTrailer.Response(
                    trailers: trailer.results,
                    error: nil
                )
                self?.presenter?.presentTrailers(response: response)
            }, onError: { [weak self] error in
                self?.presenter?.presentError(error: error)
            })
            .disposed(by: disposeBag)
    }
} 
