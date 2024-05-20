//
//  BaseViewController.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 17.05.2024.
//

import UIKit

class BaseViewController: UIViewController {
    
    var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBar()
        setupLoadingIndicator()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didStartLoading), name: .didStartLoading, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishLoading), name: .didFinishLoading, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hex: "#2A59FE")
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 18) // TODO: Change Font
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        if navigationController?.viewControllers.count ?? 0 <= 1 {
            let titleLabel = UILabel()
            titleLabel.text = self.title?.isEmpty == false ? self.title : "E-Market"
            titleLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            titleLabel.font = UIFont.boldSystemFont(ofSize: 24) // TODO: Change Font
            titleLabel.sizeToFit()
            
            let leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
            navigationItem.leftBarButtonItem = leftBarButtonItem
        } else {
            self.title = self.title?.isEmpty == false ? self.title : "E-Market"
        }
    }
    
    func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = view.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = UIColor(hex: "#2A59FE")
        loadingIndicator.layer.zPosition = 1
        view.addSubview(loadingIndicator)
    }
    
    @objc func didStartLoading() {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
        }
    }
    
    @objc func didFinishLoading() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }
    }
}
