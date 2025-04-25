//
//  MovieTrailer.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/3/20.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

// MARK: - Data Models
struct MovieTrailer: Codable {
    let results: [MovieTrailerDetail]
}

struct MovieTrailerDetail: Codable, IdentifiableType {
    let name: String
    let key: String
    let published_at: String
    
    typealias Identity = String
    
    var identity: String {
        return key
    }
}


// MARK: - Models
enum MovieTrailerScene {
    enum FetchTrailer {
        struct Request {
            let movieId: Int
        }
        
        struct Response {
            let trailers: [MovieTrailerDetail]?
            let error: Error?
        }
        
        struct ViewModel {
            let trailers: [MovieTrailerDetail]?
            let error: Error?
        }
    }
}

