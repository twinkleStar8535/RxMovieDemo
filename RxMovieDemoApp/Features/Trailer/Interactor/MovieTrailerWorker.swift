//
//  MovieTrailerWorker.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/11.
//

import Foundation
import RxSwift
import Alamofire

class MovieTrailerWorker {
    private let requestService: RequestDelegate
    
    init(requestService: RequestDelegate = RequestServices()) {
        self.requestService = requestService
    }
    
    func fetchTrailers(movieId: Int) -> Observable<MovieTrailer> {
        let path = MovieUseCase.configureUrlString(trailerID: "\(movieId)")
                
        guard let url = URL(string: path) else {
            return Observable.error(ServerError.invalidURL)
        }
        
        return requestService.request(
            url: url,
            method: .get,
            data: nil,
            header: nil,
            type: MovieTrailer.self
        )
    }
} 
