//
//  MovieSimilarPresenter.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/11.
//


import Foundation

class MovieSimilarPresenter: MovieSimilarPresentationLogic {
    weak var viewController: MovieSimilarDisplayLogic?
    
    func presentSimilarMovies(response: MovieSimilar.FetchSimilar.Response) {
        if let error = response.error {
            presentError(error: error)
            return
        }
        
        let viewModel = MovieSimilar.FetchSimilar.ViewModel(
            similarMovies: response.similarMovies,
            error: nil
        )
        viewController?.displaySimilarMovies(viewModel: viewModel)
    }
    
    func presentError(error: Error) {
        viewController?.displayError(message: error.localizedDescription)
    }
} 
