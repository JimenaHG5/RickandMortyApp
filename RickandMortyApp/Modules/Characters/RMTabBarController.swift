//
//  RMTabBarController.swift
//  RickandMortyApp
//
//  Created by Jimena Hernández García on 14/03/26.
//

import UIKit

// MARK: - RMTabBarController

final class RMTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private var charactersCoordinator: CharactersCoordinator?
    private var favoritesCoordinator: FavoritesCoordinator?
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Programmatic viewcontroller")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupViewControllers()
        setupNetworkMonitor()
    }
    
    // MARK: - Setup
    
    private func setupViewControllers() {
        let charactersNav = UINavigationController()
        let favoritesNav = UINavigationController()
        
        configureNavigationController(charactersNav)
        configureNavigationController(favoritesNav)
        
        let charactersCoordinator = CharactersCoordinator(navigationController: charactersNav)
        let favoritesCoordinator = FavoritesCoordinator(navigationController: favoritesNav)
        
        self.charactersCoordinator = charactersCoordinator
        self.favoritesCoordinator = favoritesCoordinator
        
        charactersCoordinator.start()
        favoritesCoordinator.start()
        
        charactersNav.tabBarItem = UITabBarItem(
            title: "Personajes",
            image: UIImage(systemName: "person.3"),
            selectedImage: UIImage(systemName: "person.3.fill")
        )
        
        favoritesNav.tabBarItem = UITabBarItem(
            title: "Favoritos",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        viewControllers = [charactersNav, favoritesNav]
    }
    
    private func configureNavigationController(_ nav: UINavigationController) {
        nav.navigationBar.prefersLargeTitles = false
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.tintColor = UIColor(named: "RMGreen") ?? .systemGreen
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "RMBackground") ?? .black
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        
        if #available(iOS 15.0, *) {
            nav.navigationBar.compactScrollEdgeAppearance = appearance
        }
    }
    
    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "RMBackground") ?? .black
        
        let accent = UIColor(named: "RMGreen") ?? .systemGreen
        
        appearance.stackedLayoutAppearance.selected.iconColor = accent
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: accent]
        appearance.stackedLayoutAppearance.normal.iconColor = .lightGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.isTranslucent = false
        tabBar.tintColor = accent
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.backgroundColor = UIColor(named: "RMBackground") ?? .black
    }
    
    // MARK: - Network Monitor
    
    private func setupNetworkMonitor() {
        NetworkMonitor.shared.onConnectionChange = { [weak self] isConnected in
            guard let self else { return }
            if !isConnected {
                DispatchQueue.main.async {
                    self.showNoConnectionAlert()
                }
            }
        }
    }
    
    // MARK: - Alerts
    
    private func showNoConnectionAlert() {
        let hasFavorites = !CoreDataManager.shared.fetchFavorites().isEmpty
        
        let message = hasFavorites
            ? "No tienes conexión. Puedes ver tus favoritos guardados."
            : "No tienes conexión. Agrega favoritos para verlos sin conexión."
        
        let alert = UIAlertController(
            title: "Sin conexión",
            message: message,
            preferredStyle: .alert
        )
        
        if hasFavorites {
            alert.addAction(UIAlertAction(title: "Ver favoritos", style: .default) { [weak self] _ in
                self?.selectedIndex = 1
            })
        }
        
        alert.addAction(UIAlertAction(title: "Reintentar", style: .default))
        present(alert, animated: true)
    }
}

