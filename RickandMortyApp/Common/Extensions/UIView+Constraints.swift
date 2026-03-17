//
//  UIView+Constraints.swift
//  CharactersRickandMorty2
//
//  Created by Jimena Hernández García on 13/03/26.
//

import UIKit

// MARK: - UIView + Constraints

/// Extensión de UIView con helpers para constraints programáticos
extension UIView {
    
    /// Agrega la vista como subview y activa constraints en una sola llamada
    func addSubviewWithConstraints(_ view: UIView, padding: UIEdgeInsets = .zero) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom)
        ])
    }
    
    /// Centra la vista dentro de su superview
    func centerInSuperview() {
        guard let superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
    
    /// Ancla la vista a los bordes de su superview
    func pinToSuperview(padding: UIEdgeInsets = .zero) {
        guard let superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: padding.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding.bottom)
        ])
    }
    
    /// Ancla la vista al safe area de su superview
    func pinToSafeArea(of viewController: UIViewController, padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        let safeArea = viewController.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: safeArea.topAnchor, constant: padding.top),
            leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: padding.left),
            trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -padding.right),
            bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -padding.bottom)
        ])
    }
    
    /// Define el tamaño de la vista con width y height
    func setSize(width: CGFloat? = nil, height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
