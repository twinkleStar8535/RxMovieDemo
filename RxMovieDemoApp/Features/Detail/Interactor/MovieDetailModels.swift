//
//  MovieDetailModels.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/10.
//

import Foundation

struct MovieDetailData:Codable {
    let poster_path:String?
    let backdrop_path:String?
    let title: String?
    let tagline: String?
    let runtime:Int?
    let vote_average:Double?
    let overview:String?
    let release_date: String?
    let genres: [Genre]?
    var isFavorite: Bool?
}

extension MovieDetailData {
    
    mutating func resetFavoriteStatus (isFav: Bool) {
        self.isFavorite = isFav
    }
}



struct Genre: Codable {
    let name: String?
}


enum MovieDetail {
    enum FetchMovie {
        struct Request {
            let movieId: Int
        }
        
        struct Response {
            let movieDetail: MovieDetailData?
            let error: Error?
        }
        
        struct ViewModel {
            let movieDetail: MovieDetailData?
            let errorMessage: String?
        }
    }
}
