//
//  AppCoordinator.swift
//  CharactersRickandMorty2
//
//  Created by Jimena Hernández García on 12/03/26.
//
import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        // TODO: setup TabBar
    }
}
