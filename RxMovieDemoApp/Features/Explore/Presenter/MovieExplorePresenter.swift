//
//  MovieExplorePresenter.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/11.
//


import Foundation

protocol MovieExplorePresentationLogic {
    func presentMovies(response: MovieExplore.FetchMovies.Response)
    func presentSelectedMovie(response: MovieExplore.SelectMovie.Response)
    func presentError(message: String)
    func presentLoading(isLoading: Bool)
}

class MovieExplorePresenter: MovieExplorePresentationLogic {
    weak var viewController: MovieExploreDisplayLogic?
    
    func presentMovies(response: MovieExplore.FetchMovies.Response) {
        if let error = response.error {
            presentError(message: error.localizedDescription)
            return
        }
        
        let viewModel = MovieExplore.FetchMovies.ViewModel(
            movies: response.movies.results,
            page: response.movies.page,
            totalPages: response.movies.total_pages,
            isLoadMore: response.movies.page > 1,
            errorMessage: nil
        )
        
        viewController?.displayMovies(viewModel: viewModel)
    }
    
    func presentSelectedMovie(response: MovieExplore.SelectMovie.Response) {
        let viewModel = MovieExplore.SelectMovie.ViewModel(movieId: response.movieId)
        viewController?.displaySelectedMovie(viewModel: viewModel)
    }
    
    func presentError(message: String) {
        viewController?.displayError(message: message)
    }
    
    func presentLoading(isLoading: Bool) {
        viewController?.displayLoading(isLoading: isLoading)
    }
} 
