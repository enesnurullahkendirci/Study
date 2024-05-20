//
//  MainTabBarController.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 17.05.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    let viewModel = MainTabBarViewModel()
    
    var productListViewController = UINavigationController(rootViewController: ProductListViewController())
    var cartViewController = UINavigationController(rootViewController: CartViewController())
    var favoritesViewController = UINavigationController(rootViewController: FavoritesViewController())
    var profileViewController = UINavigationController(rootViewController: ProfileViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.onCartItemsCountChange = { [weak self] count in
            self?.cartViewController.tabBarItem.badgeValue = count
        }
        
        productListViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: .iconHome), tag: 0)
        cartViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: .iconBasket), tag: 1)
        cartViewController.tabBarItem.badgeValue = viewModel.getCartItemsCount()
        favoritesViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: .iconStar), tag: 2)
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: .iconPerson), tag: 3)
        
        viewControllers = [
            productListViewController,
            cartViewController,
            favoritesViewController,
            profileViewController
        ]
    }
}
