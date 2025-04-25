//
//  MovieDetailRouter.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/11.
//


import UIKit

protocol MovieDetailRoutingLogic {
    func routeToBack()
}

protocol MovieDetailDataPassing {
    var dataStore: MovieDetailDataStore? { get }
}

class MovieDetailRouter: NSObject, MovieDetailRoutingLogic, MovieDetailDataPassing {
    weak var viewController: MovieDetailsViewController?
    var dataStore: MovieDetailDataStore?
    
    func routeToBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
} 
