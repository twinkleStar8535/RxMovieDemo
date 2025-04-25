//
//  MovieDetailPresenter.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/13.
//


import Foundation


protocol MovieDetailPresentationLogic {
    func presentMovieDetail(response: MovieDetail.FetchMovie.Response)
    func presentError(message: String)
}


class MovieDetailPresenter: MovieDetailPresentationLogic {
    weak var viewController: MovieDetailDisplayLogic?
    
    func presentMovieDetail(response: MovieDetail.FetchMovie.Response) {
        let viewModel = MovieDetail.FetchMovie.ViewModel(
            movieDetail: response.movieDetail,
            errorMessage: response.error?.localizedDescription
        )
        viewController?.displayMovieDetail(viewModel: viewModel)
    }
    
    func presentError(message: String) {
        viewController?.displayError(message: message)
    }
} 
