//
//  MovieExploreWorker.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/12.
//



import Foundation
import RxSwift

protocol MovieExploreWorkerProtocol {
    func fetchMovies(query: String?, page: Int) -> Observable<MovieExploreList>
}

class MovieExploreWorker: MovieExploreWorkerProtocol {
    private let requestService: RequestDelegate
    
    init(requestService: RequestDelegate = RequestServices()) {
        self.requestService = requestService
    }
    
    func fetchMovies(query: String?, page: Int) -> Observable<MovieExploreList> {
        var urlString: String = ""
        
        if let query = query  {
            urlString = MovieUseCase.configureUrlString(keyword: query, page: page)
        }
        
        guard let url = URL(string: urlString) else {
            return Observable.error(ServerError.invalidURL)
        }
        
        return requestService.request(
            url: url,
            method: .get,
            data: nil,
            header: nil,
            type: MovieExploreList.self
        )
    }
} 
