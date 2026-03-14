//
//  FavoritesCoordinator.swift
//  CharactersRickandMorty2
//
//  Created by Jimena Hernández García on 12/03/26.
//

import UIKit
import SwiftUI

// MARK: - FavoritesCoordinator

final class FavoritesCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Start
    
    func start() {
        let viewModel = FavoritesViewModel(coordinator: self)
        let vc = FavoritesViewController(viewModel: viewModel)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    // MARK: - Navigation
    
    func showDetail(character: Character) {
        let viewModel = CharacterDetailViewModel(character: character)
        let detailView = CharacterDetailView(viewModel: viewModel)
        let hostingVC = UIHostingController(rootView: detailView)
        hostingVC.title = character.name
        hostingVC.view.backgroundColor = UIColor(named: "RMBackground") ?? .black
        hostingVC.navigationItem.largeTitleDisplayMode = .never
        
        navigationController.pushViewController(hostingVC, animated: true)
    }
}

