//
//  FavoritesModels.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/12.
//


import Foundation

enum FetchFavoriteError:String,Error {
    case invalidFetch
    case decodeError
    case encodeError
}

struct FavoriteRecords:Codable {
    var records: [GetFavoriteRecordModel]
}


struct GetFavoriteRecordModel:Codable {
    var id: String
    var fields:FavoriteItems
}

struct PostFavoriteRecordModel:Codable {
    var fields:FavoriteItems
}


struct FavoriteItems:Codable ,Hashable{
    var movieID :Int
    var movieName:String
    var posterURL:String?
}


struct FavoriteDeleted:Codable {
    var id:String
    var deleted:Bool
}



enum FavoritesMovie {
    enum FavoritesModels {
        struct Request {
            let movieID: String
        }
        
        struct Response {
            let favoriteItems: [FavoriteItems]
            let error: Error?
        }
        
        struct ViewModel {
            let favoriteItems: [FavoriteItems]
            let error: Error?
        }
    }
}
