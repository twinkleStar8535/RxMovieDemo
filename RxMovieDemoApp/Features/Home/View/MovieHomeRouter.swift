//
//  MovieHomeRouter.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/11.
//

import UIKit

protocol MovieHomeRoutingLogic {
    func routeToMovieDetails()
}

protocol MovieHomeDataPassing {
    var dataStore: MovieHomeDataStore? { get }
}

class MovieHomeRouter:NSObject,MovieHomeRoutingLogic, MovieHomeDataPassing {
    weak var viewController: HomeMainViewController?
    var dataStore: MovieHomeDataStore?
    
    func routeToMovieDetails() {
        guard let movieId = dataStore?.selectedMovieId else { return }
        let movieDetailsVC = MovieDetailsViewController(id: movieId, popType: .withNavPresent)
        viewController?.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
} 
