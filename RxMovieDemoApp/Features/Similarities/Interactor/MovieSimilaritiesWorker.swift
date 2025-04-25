//
//  MovieSimilaritiesWorker.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/10.
//


import Foundation
import RxSwift
import Alamofire

class MovieSimilaritiesWorker {
    private let requestService: RequestDelegate
    
    init(requestService: RequestDelegate = RequestServices()) {
        self.requestService = requestService
    }
    
    func fetchSimilarMovies(movieId: Int) -> Observable<MovieSimilarities> {
        let path = MovieUseCase.configureUrlString(similarID: movieId)
        
        guard let url = URL(string: path) else {
            return Observable.error(ServerError.invalidURL)
        }
        
        return requestService.request(
            url: url,
            method: .get,
            data: nil,
            header: nil,
            type: MovieSimilarities.self
        )
    }
} 
