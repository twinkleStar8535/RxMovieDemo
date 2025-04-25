//
//  MovieExploreInteractor.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/12.
//



import Foundation
import RxSwift
import RxRelay

protocol MovieExploreBusinessLogic {
    func fetchMovies(request: MovieExplore.FetchMovies.Request)
    func selectMovie(request: MovieExplore.SelectMovie.Request)
    func startExplore(keyword: String, page: Int)
    func clearExplore()
    var exploreResult: BehaviorRelay<[MovieExploreListData]> { get }
}

protocol MovieExploreDataStore {
    var selectedMovieId: Int? { get set }
}

class MovieExploreInteractor: MovieExploreBusinessLogic, MovieExploreDataStore {
    var presenter: MovieExplorePresentationLogic?
    var selectedMovieId: Int?
    
    private let disposeBag = DisposeBag()
    private let movieWorker: MovieExploreWorkerProtocol
    let exploreResult = BehaviorRelay<[MovieExploreListData]>(value: [])
    
    init(movieWorker: MovieExploreWorkerProtocol = MovieExploreWorker()) {
        self.movieWorker = movieWorker
    }
    
    func fetchMovies(request: MovieExplore.FetchMovies.Request) {
        presenter?.presentLoading(isLoading: true)
        
        movieWorker.fetchMovies(query: request.query, page: request.page)
            .subscribe(onNext: { [weak self] movieList in
                guard let self = self else { return }
                
                let response = MovieExplore.FetchMovies.Response(
                    movies: movieList,
                    error: nil
                )
                
                self.presenter?.presentMovies(response: response)
                self.presenter?.presentLoading(isLoading: false)
            }, onError: { [weak self] error in
                self?.presenter?.presentError(message: error.localizedDescription)
                self?.presenter?.presentLoading(isLoading: false)
            })
            .disposed(by: disposeBag)
    }
    
    func selectMovie(request: MovieExplore.SelectMovie.Request) {
        selectedMovieId = request.movieId
        let response = MovieExplore.SelectMovie.Response(movieId: request.movieId)
        presenter?.presentSelectedMovie(response: response)
    }
    
    func startExplore(keyword: String, page: Int) {
        movieWorker.fetchMovies(query: keyword, page: page)
            .subscribe(onNext: { [weak self] movieList in
                guard let self = self else { return }
                if page == 1 {
                    self.exploreResult.accept(movieList.results)
                } else {
                    self.exploreResult.accept(self.exploreResult.value + movieList.results)
                }
            }, onError: { error in
                print("Error fetching movies: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func clearExplore() {
        exploreResult.accept([])
    }
} 
