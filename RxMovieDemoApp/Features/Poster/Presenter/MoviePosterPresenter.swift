//
//  MoviePosterPresenter.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/12.
//

import Foundation
import RxSwift
import RxCocoa

protocol MoviePosterPresenterProtocol {
    func presentMoviePosters(response: MoviePosterModels.Response)
    func presentError(error: Error)
}

class MoviePosterPresenter: MoviePosterPresenterProtocol {
    weak var view: MoviePosterViewProtocol?
    private let disposeBag = DisposeBag()
    
    init(view: MoviePosterViewProtocol? = nil) {
        self.view = view
    }
    
    func presentMoviePosters(response: MoviePosterModels.Response) {
        Observable.just(response)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                let viewModel = MoviePosterModels.ViewModel(posters: response.posters)
                self?.view?.displayMoviePosters(viewModel: viewModel)
            })
            .disposed(by: disposeBag)
    }
    
    func presentError(error: Error) {
        Observable.just(error)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.view?.displayError(error: error)
            })
            .disposed(by: disposeBag)
    }
} 
