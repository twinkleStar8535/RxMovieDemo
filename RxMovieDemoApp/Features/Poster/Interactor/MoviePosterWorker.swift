//
//  MoviePosterWorker.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/12.
//


import Foundation
import RxSwift
import Alamofire

class MoviePosterWorker {
    private let requestService: RequestDelegate
    
    init(requestService: RequestDelegate = RequestServices()) {
        self.requestService = requestService
    }
    
    func fetchMoviePosters(movieId: String) -> Observable<MoviePoster> {
        let path = MovieUseCase.configureUrlString(posterKey: movieId)
        
        guard let url = URL(string: path) else {
            return Observable.error(ServerError.invalidURL)
        }
        
        return requestService.request(
            url: url,
            method: .get,
            data: nil,
            header: nil,
            type: MoviePoster.self
        )
        .map { poster in
            return poster
        }
    }
} 
