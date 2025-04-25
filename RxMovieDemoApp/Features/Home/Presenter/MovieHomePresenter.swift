//
//  MovieHomePresenter.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/7.
//

import Foundation

protocol MovieHomePresentationLogic {
    func presentMovies(response: MovieHome.FetchMovies.Response)
    func presentError(message: String)
    func presentLoading(isLoading: Bool)
}

class MovieHomePresenter: MovieHomePresentationLogic {
    weak var viewController: MovieHomeDisplayLogic?
    
    func presentMovies(response: MovieHome.FetchMovies.Response) {
        let viewModel = MovieHome.FetchMovies.ViewModel(
            nowPlayingMovies: response.nowPlayingMovies,
            popularMovies: response.popularMovies,
            upcomingMovies: response.upcomingMovies,
            topRatedMovies: response.topRatedMovies,
            errorMessage: response.error?.localizedDescription
        )
        viewController?.displayMovies(viewModel: viewModel)
    }
    
    func presentError(message: String) {
        viewController?.displayError(message: message)
    }
    
    func presentLoading(isLoading: Bool) {
        viewController?.displayLoading(isLoading: isLoading)
    }
} 
