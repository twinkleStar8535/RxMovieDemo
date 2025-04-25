//
//  MovieHomeInteractor.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/7.
//

import Foundation
import RxSwift
import RxRelay

protocol MovieHomeBusinessLogic {
    func fetchMovies(request: MovieHome.FetchMovies.Request)
    func selectMovie(request: MovieHome.SelectMovie.Request) // Handle Select Action By Router
}

protocol MovieHomeDataStore {
    var selectedMovieId: Int? { get set }
}

class MovieHomeInteractor:NSObject,MovieHomeBusinessLogic, MovieHomeDataStore {
    var presenter: MovieHomePresentationLogic?
    var selectedMovieId: Int?
    private let disposeBag = DisposeBag()
    private let movieHomeWorker: MovieHomeWorkerProtocol
    
    init(movieHomeWorker: MovieHomeWorkerProtocol = MovieHomeWorker()) {
        self.movieHomeWorker = movieHomeWorker
    }
    
    func fetchMovies(request: MovieHome.FetchMovies.Request) {
        presenter?.presentLoading(isLoading: true)
        
        Observable.zip(
            movieHomeWorker.fetchNowPlaying(),
            movieHomeWorker.fetchPopular(),
            movieHomeWorker.fetchUpcoming(),
            movieHomeWorker.fetchTopRated()
        )
        .subscribe(onNext: { [weak self] (nowPlaying, popular, upcoming, topRated) in
            guard let self = self else { return }
            
            let response = MovieHome.FetchMovies.Response(
                nowPlayingMovies: nowPlaying,
                popularMovies: popular,
                upcomingMovies: upcoming,
                topRatedMovies: topRated,
                error: nil
            )
            
            self.presenter?.presentMovies(response: response)
            self.presenter?.presentLoading(isLoading: false)
        }, onError: { [weak self] error in
            self?.presenter?.presentError(message: "Fetch Error")
            self?.presenter?.presentLoading(isLoading: false)
        })
        .disposed(by: disposeBag)
    }
    
    func selectMovie(request: MovieHome.SelectMovie.Request) {
        selectedMovieId = request.movieId
        let response = MovieHome.SelectMovie.Response(movieId: request.movieId)
    }
} 
