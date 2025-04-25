//
//  MovieSimilarInteractor.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/10.
//

import Foundation
import RxSwift
import RxRelay

class MovieSimilarInteractor: MovieSimilarBusinessLogic {
    var presenter: MovieSimilarPresentationLogic?
    private let worker: MovieSimilaritiesWorker
    private let disposeBag = DisposeBag()
    
    init(presenter: MovieSimilarPresentationLogic? = nil,
         worker: MovieSimilaritiesWorker = MovieSimilaritiesWorker()) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func fetchSimilarMovies(request: MovieSimilar.FetchSimilar.Request) {
        worker.fetchSimilarMovies(movieId: request.movieId)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] similarities in
                guard let self = self else { return }
                let response = MovieSimilar.FetchSimilar.Response(
                    similarMovies: similarities.results,
                    error: nil
                )
                self.presenter?.presentSimilarMovies(response: response)
            }, onError: { [weak self] error in
                self?.presenter?.presentError(error: error)
            })
            .disposed(by: disposeBag)
    }
} 
