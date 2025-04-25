//
//  SettingRouter.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/13.
//


import Foundation
import UIKit


protocol SettingRouterProtocol {
    func navigateToFavorites()
}


class SettingRouter: SettingRouterProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func navigateToFavorites() {
        let vc = FavoritesViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        viewController?.present(vc, animated: true)
    }
} 
