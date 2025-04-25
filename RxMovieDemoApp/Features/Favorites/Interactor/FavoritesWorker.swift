//
//  FavoritesWorker.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/12.
//


import Foundation
import RxSwift
import Alamofire

protocol FavoritesWorkerProtocol {
    func getFavoriteMovieRecords(completion: @escaping (Result<FavoriteRecords, Error>) -> Void)
    func addFavoriteMovie(movie: PostFavoriteRecordModel)
    func deleteMovieFromFavorite(item: FavoriteDeleted)
    func checkIfIsFavsMovie(id: Int, completion: @escaping (Result<(Bool, String), Error>) -> Void)
}

class FavoritesWorker: FavoritesWorkerProtocol {
    private let requestService: RequestDelegate
    private let disposeBag = DisposeBag()
    
    init(requestService: RequestDelegate = RequestServices()) {
        self.requestService = requestService
    }
    
    func getFavoriteMovieRecords(completion: @escaping (Result<FavoriteRecords, Error>) -> Void) {
        let url = URL(string: AppConstant.AIRTABLE_API_BASEURL)
        let headers = ["Authorization": "Bearer \(AppConstant.AIRTABLE_TOKEN)"]
        
        requestService.request(
            url: url,
            method: .get,
            data: nil,
            header: headers,
            type: FavoriteRecords.self
        )
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { records in
            completion(.success(records))
        }, onError: { error in
            completion(.failure(error))
        })
        .disposed(by: disposeBag)
    }
    
    func addFavoriteMovie(movie: PostFavoriteRecordModel) {
        let url = URL(string: AppConstant.AIRTABLE_API_BASEURL)
        let headers = [
            "Authorization": "Bearer \(AppConstant.AIRTABLE_TOKEN)",
            "Content-Type": AppConstant.CONTENTTYPE_JSON
        ]
        
        let encoder = JSONEncoder()
        do {
            let movieData = try encoder.encode(movie)
            requestService.request(
                url: url,
                method: .post,
                data: movieData,
                header: headers,
                type: GetFavoriteRecordModel.self
            )
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                print(result)
            }, onError: { error in
                print(FetchFavoriteError.encodeError)
            })
            .disposed(by: disposeBag)
        } catch {
            print(FetchFavoriteError.encodeError)
        }
    }
    
    func deleteMovieFromFavorite(item: FavoriteDeleted) {
        let url = URL(string: "\(AppConstant.AIRTABLE_API_BASEURL)/\(item.id)")
        let headers = ["Authorization": "Bearer \(AppConstant.AIRTABLE_TOKEN)"]
        
        requestService.request(
            url: url,
            method: .delete,
            data: nil,
            header: headers,
            type: FavoriteDeleted.self
        )
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { _ in
            print("Delete Success")
        }, onError: { error in
            print("Error deleting movie from favorites: \(error)")
        })
        .disposed(by: disposeBag)
    }
    
    func checkIfIsFavsMovie(id: Int, completion: @escaping (Result<(Bool, String), Error>) -> Void) {
        let url = URL(string: AppConstant.AIRTABLE_API_BASEURL)
        let headers = ["Authorization": "Bearer \(AppConstant.AIRTABLE_TOKEN)"]
        
        print("Checking favorite status for movie ID: \(id)")
        
        requestService.request(
            url: url,
            method: .get,
            data: nil,
            header: headers,
            type: FavoriteRecords.self
        )
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { records in
            print("Received \(records.records.count) favorite records")
            if let uniqFavsID = records.records.first(where: { $0.fields.movieID == id }) {
                print("Movie \(id) is favorited with ID: \(uniqFavsID.id)")
                completion(.success((true, uniqFavsID.id)))
            } else {
                print("Movie \(id) is not favorited")
                completion(.success((false, "")))
            }
        }, onError: { error in
            print("Error checking favorite status: \(error.localizedDescription)")
            completion(.failure(error))
        })
        .disposed(by: disposeBag)
    }
} 
