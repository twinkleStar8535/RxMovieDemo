//
//  MovieHomeWorker.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2024/4/12.
//

import Foundation
import RxSwift

protocol MovieHomeWorkerProtocol {
    func fetchNowPlaying() -> Observable<[MovieHomeListData]>
    func fetchPopular() -> Observable<[MovieHomeListData]>
    func fetchUpcoming() -> Observable<[MovieHomeListData]>
    func fetchTopRated() -> Observable<[MovieHomeListData]>
}

class MovieHomeWorker: MovieHomeWorkerProtocol {
    private let requestService: RequestDelegate
    
    init(requestService: RequestDelegate = RequestServices()) {
        self.requestService = requestService
    }
    
    func fetchNowPlaying() -> Observable<[MovieHomeListData]> {
        guard let url = URL(string: MovieUseCase.configureUrlString(genre: .nowPlaying)) else {
            return Observable.error(ServerError.invalidURL)
        }
        
        return requestService.request(
            url: url,
            method: .get,
            data: nil,
            header: nil,
            type: MovieHomeList.self
        )
        .map { movieList in
            return self.parseMovieHomeListData(model: movieList)
        }
    }
    
    func fetchPopular() -> Observable<[MovieHomeListData]> {
        guard let url = URL(string: MovieUseCase.configureUrlString(genre: .popular)) else {
            return Observable.error(ServerError.invalidURL)
        }
        
        return requestService.request(
            url: url,
            method: .get,
            data: nil,
            header: nil,
            type: MovieHomeList.self
        )
        .map { movieList in
            return self.parseMovieHomeListData(model: movieList)
        }
    }
    
    func fetchUpcoming() -> Observable<[MovieHomeListData]> {
        guard let url = URL(string: MovieUseCase.configureUrlString(genre: .upcoming)) else {
            return Observable.error(ServerError.invalidURL)
        }
        
        return requestService.request(
            url: url,
            method: .get,
            data: nil,
            header: nil,
            type: MovieHomeList.self
        )
        .map { movieList in
            return self.parseMovieHomeListData(model: movieList)
        }
    }
    
    func fetchTopRated() -> Observable<[MovieHomeListData]> {
        guard let url = URL(string: MovieUseCase.configureUrlString(genre: .topRated)) else {
            return Observable.error(ServerError.invalidURL)
        }
        
        return requestService.request(
            url: url,
            method: .get,
            data: nil,
            header: nil,
            type: MovieHomeList.self
        )
        .map { movieList in
            return self.parseMovieHomeListData(model: movieList)
        }
    }
    
    private func parseMovieHomeListData(model: MovieHomeList) -> [MovieHomeListData] {
        return model.results.map { listData in
            return MovieHomeListData(
                id: listData.id,
                title: listData.title,
                backdrop_path: listData.backdrop_path,
                poster_path: listData.poster_path,
                vote_average: listData.vote_average
            )
        }
    }
} 
