//
//  MoviePosterRouter.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/11.
//

import UIKit

protocol MoviePosterRouterProtocol {
    static func createModule(movieId: Int) -> UIView
}

class MoviePosterRouter: MoviePosterRouterProtocol {
    static func createModule(movieId: Int) -> UIView {
        return MoviePosterView(id: movieId)
    }
} 
