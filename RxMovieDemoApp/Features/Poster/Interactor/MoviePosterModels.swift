//
//  MoviePosterModels.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/12.
//

import Foundation

struct MoviePoster:Codable {
    let backdrops:[MoviePosterDetail]
}

struct MoviePosterDetail:Codable {
    let aspect_ratio: Double
    let file_path:String
}



enum MoviePosterModels {
    struct Request {
        let movieId: String
    }
    
    struct Response {
        let posters: [MoviePosterDetail]
    }
    
    struct ViewModel {
        let posters: [MoviePosterDetail]
    }
} 
