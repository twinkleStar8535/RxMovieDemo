//
//  MovieDetailWorker.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/13.
//

import Foundation
import RxSwift

protocol MovieDetailWorkerProtocol {
    func fetchMovieDetail(id: Int) -> Observable<MovieDetailData>
}

class MovieDetailWorker: MovieDetailWorkerProtocol {
    private let requestService: RequestDelegate
    private let favoritesInteractor: FavoritesInteractorProtocol
    private let disposeBag = DisposeBag()
    
    init(requestService: RequestDelegate = RequestServices(),
         favoritesInteractor: FavoritesInteractorProtocol = FavoritesInteractor(presenter: FavoritesPresenter())) {
        self.requestService = requestService
        self.favoritesInteractor = favoritesInteractor
    }
    
    func fetchMovieDetail(id: Int) -> Observable<MovieDetailData> {
        guard let url = URL(string: MovieUseCase.configureUrlString(id: id)) else {
            return Observable.error(ServerError.invalidURL)
        }
        
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(ServerError.unknownError)
                return Disposables.create()
            }
            
            self.favoritesInteractor.checkIfIsFavsMovie(id: id) { result in
                switch result {
                case .success(let (isFavorite, _)):
                    self.requestService.request(
                        url: url,
                        method: .get,
                        data: nil,
                        header: nil,
                        type: MovieDetailData.self
                    )
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { movieDetail in
                        var updatedMovieDetail = movieDetail
                        updatedMovieDetail.resetFavoriteStatus(isFav: isFavorite)
                        observer.onNext(updatedMovieDetail)
                        observer.onCompleted()
                    }, onError: { error in
                        observer.onError(error)
                    })
                    .disposed(by: self.disposeBag)
                    
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
} 
