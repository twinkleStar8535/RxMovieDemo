//
//  MainTabBarController.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/1/21.
//

import UIKit
import RxTheme


class MainTabBarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    override func viewDidLayoutSubviews() {
        tabBar.itemPositioning = .centered
        setupTheme()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let homeVC = HomeMainViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        let homeNavigationItem = UINavigationController(rootViewController: homeVC)


        let exploreVC = MovieExploreViewController()
        exploreVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        let exploreNavigationItem = UINavigationController(rootViewController: exploreVC)

        let settingVC = SettingsViewController()
        settingVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "fill"))
        let settingNavigationItem = UINavigationController(rootViewController: settingVC)

        self.viewControllers = [homeNavigationItem, exploreVC, settingNavigationItem]
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

}

extension MainTabBarController:ThemeChangeDelegate{
    func setupTheme() {
        tabBar.theme.backgroundColor = themeService.attribute{$0.backgroundColor}
        tabBar.theme.barTintColor = themeService.attribute{$0.backgroundColor}
        tabBar.theme.tintColor = themeService.attribute{$0.tabBarSelectColor}
        tabBar.unselectedItemTintColor = .gray
    }
    


}
