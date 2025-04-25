//
//  FavoritesInteractor.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/12.
//

import Foundation
import RxSwift

protocol FavoritesInteractorProtocol {
    func fetchFavorites()
    func checkIfIsFavsMovie(id: Int, completion: @escaping (Result<(Bool, String), Error>) -> Void)
    func deleteFavorite(id: String)
    func addFavorite(item: PostFavoriteRecordModel)
}

class FavoritesInteractor: FavoritesInteractorProtocol {
    private let worker: FavoritesWorkerProtocol
    private let presenter: FavoritesPresenterProtocol
    private let disposeBag = DisposeBag()
    
    init(worker: FavoritesWorkerProtocol = FavoritesWorker(),
         presenter: FavoritesPresenterProtocol) {
        self.worker = worker
        self.presenter = presenter
    }
    
    func fetchFavorites() {
        worker.getFavoriteMovieRecords { [weak self] result in
            switch result {
            case .success(let records):
                
                self?.presenter.presentFavorites(response: FavoritesMovie.FavoritesModels.Response(
                    favoriteItems: records.records.map { $0.fields },
                    error: nil
                ))
            case .failure(let error):
                self?.presenter.presentFavorites(response: FavoritesMovie.FavoritesModels.Response(
                    favoriteItems: [],
                    error: error
                ))
            }
        }
    }
    
    func checkIfIsFavsMovie(id: Int, completion: @escaping (Result<(Bool, String), Error>) -> Void) {
        worker.checkIfIsFavsMovie(id: id) { [weak self] result in
            switch result {
            case .success(let (isFavorite, favsID)):
                completion(.success((isFavorite, favsID)))
            case .failure(let error):
                self?.presenter.presentError(error: error)
                completion(.failure(error))
            }
        }
    }
    
    func deleteFavorite(id: String) {
        DispatchQueue.main.async {
            let item = FavoriteDeleted(id: id, deleted: true)
            self.worker.deleteMovieFromFavorite(item: item)
            self.fetchFavorites()
        }
    }
    
    func addFavorite(item: PostFavoriteRecordModel) {
        
        DispatchQueue.main.async {
            self.worker.addFavoriteMovie(movie: item)
            self.fetchFavorites()
        }
    }
} 
