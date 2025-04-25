//
//  MovieExploreModels.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/10.
//


import Foundation

// MARK: - Data Models
struct MovieExploreList: Codable {
    let results: [MovieExploreListData]
    let page: Int
    let total_pages: Int
}

struct MovieExploreListData: Codable {
    let id: Int?
    let title: String?
    let backdrop_path: String?
    let poster_path: String?
    let vote_average: Double?
}

// MARK: - Use Case Models
enum MovieExplore {
    // MARK: - Use cases
    
    enum FetchMovies {
        struct Request {
            let query: String?
            let page: Int
            let isLoadMore: Bool
        }
        
        struct Response {
            let movies: MovieExploreList
            let error: Error?
        }
        
        struct ViewModel {
            let movies: [MovieExploreListData]
            let page: Int
            let totalPages: Int
            let isLoadMore: Bool
            let errorMessage: String?
        }
    }
    
    enum SelectMovie {
        struct Request {
            let movieId: Int
        }
        
        struct Response {
            let movieId: Int
        }
        
        struct ViewModel {
            let movieId: Int
        }
    }
} 
