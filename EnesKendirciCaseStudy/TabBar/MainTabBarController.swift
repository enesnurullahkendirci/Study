//
//  MainTabBarController.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 17.05.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let productListViewController = UINavigationController(rootViewController: ProductListViewController())
        productListViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: .iconHome), tag: 0)
        
        let cartViewController = UINavigationController(rootViewController: CartViewController())
        cartViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: .iconBasket), tag: 1)
        cartViewController.tabBarItem.badgeValue = "3" // TODO: Dinamik olarak değişecek
        
        let favoritesViewController = UINavigationController(rootViewController: FavoritesViewController())
        favoritesViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: .iconStar), tag: 2)
        
        let profileViewController = UINavigationController(rootViewController: ProfileViewController())
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: .iconPerson), tag: 3)
        
        viewControllers = [
            productListViewController,
            cartViewController,
            favoritesViewController,
            profileViewController
        ]
    }
}
