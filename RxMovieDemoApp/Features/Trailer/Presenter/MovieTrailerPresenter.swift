//
//  MovieTrailerPresenter.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/11.
//


import Foundation


protocol MovieTrailerPresentationLogic: AnyObject {
    func presentTrailers(response: MovieTrailerScene.FetchTrailer.Response)
    func presentError(error: Error)
}


class MovieTrailerPresenter: MovieTrailerPresentationLogic {
    weak var viewController: MovieTrailerDisplayLogic?
    
    func presentTrailers(response: MovieTrailerScene.FetchTrailer.Response) {
        if let error = response.error {
            presentError(error: error)
            return
        }
        
        let viewModel = MovieTrailerScene.FetchTrailer.ViewModel(
            trailers: response.trailers,
            error: nil
        )
        viewController?.displayTrailers(viewModel: viewModel)
    }
    
    func presentError(error: Error) {
        viewController?.displayError(message: error.localizedDescription)
    }
} 
