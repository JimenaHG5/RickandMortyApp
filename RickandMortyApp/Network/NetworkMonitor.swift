//
//  NetworkMonitor.swift
//  CharactersRickandMorty2
//
//  Created by Jimena Hernández García on 12/03/26.
//
import Foundation
import Network

// MARK: - NetworkMonitor

/// Clase responsable de monitorear el estado de la conexión a internet
/// Utiliza NWPathMonitor nativo de Apple para detectar cambios de conectividad
/// Implementa el patrón Singleton para tener una sola instancia en la app
final class NetworkMonitor {
    
    /// Instancia compartida del NetworkMonitor
    static let shared = NetworkMonitor()
    
    /// Monitor nativo de Apple para detectar cambios de red
    private let monitor: NWPathMonitor
    
    /// Cola dedicada para el monitoreo de red (no bloquea el hilo principal)
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    /// Indica si hay conexión a internet disponible
    private(set) var isConnected: Bool = false
    
    /// Closure que se ejecuta cuando cambia el estado de la conexión
    /// - Parameter Bool: true si hay conexión, false si no hay
    var onConnectionChange: ((Bool) -> Void)?
    
    /// Inicializador privado para garantizar el patrón Singleton
    private init() {
        monitor = NWPathMonitor()
    }
    
    // MARK: - Start Monitoring
    
    /// Inicia el monitoreo de la conexión a internet
    /// Debe llamarse al iniciar la app desde el SceneDelegate
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            
            // actualizar estado de conexión en el hilo principal
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                self.onConnectionChange?(self.isConnected)
            }
        }
        monitor.start(queue: queue)
    }
    
    // MARK: - Stop Monitoring
    
    /// Detiene el monitoreo de la conexión a internet
    /// Debe llamarse cuando la app pase a background
    func stopMonitoring() {
        monitor.cancel()
    }
}
