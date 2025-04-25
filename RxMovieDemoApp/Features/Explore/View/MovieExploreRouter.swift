//
//  MovieExploreRouter.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/11.
//


import UIKit

protocol MovieExploreRoutingLogic {
    func routeToMovieDetails()
}

protocol MovieExploreDataPassing {
    var dataStore: MovieExploreDataStore? { get }
}

class MovieExploreRouter: MovieExploreRoutingLogic, MovieExploreDataPassing {
    weak var viewController: MovieExploreViewController?
    var dataStore: MovieExploreDataStore?
    
    func routeToMovieDetails() {
        guard let movieId = dataStore?.selectedMovieId else { return }
        let movieDetailsVC = MovieDetailsViewController(id: movieId, popType: .withNavPresent)
        viewController?.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
} 
