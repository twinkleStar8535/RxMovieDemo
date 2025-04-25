//
//  FavoritesPresenter.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/12.
//


import Foundation
import RxSwift
import RxRelay

protocol FavoritesPresenterProtocol: AnyObject {
    func presentFavorites(response: FavoritesMovie.FavoritesModels.Response)
    func presentError(error: Error)
}



class FavoritesPresenter: FavoritesPresenterProtocol {
    var viewController: MovieFavsDisplayLogic?
    private let disposeBag = DisposeBag()
    
    func presentFavorites(response: FavoritesMovie.FavoritesModels.Response) {
        print("Presenter: Received response with items count: \(response.favoriteItems.count ?? 0)")
        if let error = response.error {
            print("Presenter: Presenting error: \(error.localizedDescription)")
            viewController?.presentError(message: error.localizedDescription)
        } else {
            print("Presenter: Creating view model")
            let viewModel = FavoritesMovie.FavoritesModels.ViewModel(
                favoriteItems: response.favoriteItems,
                error: nil
            )
            print("Presenter: Calling displayMovieFavorites")
            viewController?.displayMovieFavorites(viewModel: viewModel)
        }
    }
    
    func presentError(error: any Error) {
        viewController?.presentError(message: "Favs Show Error")
    }

} 
