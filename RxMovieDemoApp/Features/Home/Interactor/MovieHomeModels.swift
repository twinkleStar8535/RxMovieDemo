//
//  MovieHomeModels.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/7.
//


import Foundation

// MARK: - Data Models
struct MovieHomeList: Codable {
    let results: [MovieHomeListData]
}

struct MovieHomeListData: Codable ,Hashable{
    let id: Int?
    let title: String?
    let backdrop_path: String?
    let poster_path: String?
    let vote_average: Double?
}

// MARK: - Use Case Models
enum MovieHome {
    // MARK: - Use cases
    
    enum FetchMovies {
        struct Request {
        }
        
        struct Response {
            let nowPlayingMovies: [MovieHomeListData]
            let popularMovies: [MovieHomeListData]
            let upcomingMovies: [MovieHomeListData]
            let topRatedMovies: [MovieHomeListData]
            let error: Error?
        }
        
        struct ViewModel {
            let nowPlayingMovies: [MovieHomeListData]
            let popularMovies: [MovieHomeListData]
            let upcomingMovies: [MovieHomeListData]
            let topRatedMovies: [MovieHomeListData]
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
