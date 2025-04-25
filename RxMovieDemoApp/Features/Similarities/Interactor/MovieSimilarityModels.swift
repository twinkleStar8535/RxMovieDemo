//
//  MovieSimilarityModels.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/11.
//

import Foundation

// MARK: - Models
enum MovieSimilar {
    enum FetchSimilar {
        struct Request {
            let movieId: Int
        }
        
        struct Response {
            let similarMovies: [MovieSimilaritiesDetail]?
            let error: Error?
        }
        
        struct ViewModel {
            let similarMovies: [MovieSimilaritiesDetail]?
            let error: Error?
        }
    }
}

// MARK: - Protocols
protocol MovieSimilarDisplayLogic: AnyObject {
    func displaySimilarMovies(viewModel: MovieSimilar.FetchSimilar.ViewModel)
    func displayError(message: String)
}

protocol MovieSimilarBusinessLogic: AnyObject {
    func fetchSimilarMovies(request: MovieSimilar.FetchSimilar.Request)
}

protocol MovieSimilarPresentationLogic: AnyObject {
    func presentSimilarMovies(response: MovieSimilar.FetchSimilar.Response)
    func presentError(error: Error)
}

// MARK: - Data Models
struct MovieSimilarities: Codable {
    let results: [MovieSimilaritiesDetail]
}

struct MovieSimilaritiesDetail: Codable, Hashable {
    let id: Int
    let poster_path: String?
    let vote_average: Double
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: MovieSimilaritiesDetail, rhs: MovieSimilaritiesDetail) -> Bool {
        return lhs.id == rhs.id
    }
}

