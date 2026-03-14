//
//  Coordinator.swift
//  CharactersRickandMorty2
//
//  Created by Jimena Hernández García on 12/03/26.
//
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}
