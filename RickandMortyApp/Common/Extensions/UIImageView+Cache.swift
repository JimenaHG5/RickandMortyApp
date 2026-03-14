//
//  UIImageView+Cache.swift
//  CharactersRickandMorty2
//
//  Created by Jimena Hernández García on 13/03/26.
//

import UIKit

// MARK: - ImageCache

/// Clase singleton que maneja el caché de imágenes en memoria
/// Evita descargar la misma imagen múltiples veces
final class ImageCache {
    
    static let shared = ImageCache()
    
    /// Caché en memoria de NSCache
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100  // máximo 100 imágenes en caché
    }
    
    /// Carga una imagen desde caché o la descarga si no existe
    /// - Parameters:
    ///   - urlString: URL de la imagen
    ///   - completion: closure con la imagen descargada
    func load(urlString: String, completion: @escaping (UIImage?) -> Void) {
        // verificar si ya está en caché
        if let cached = cache.object(forKey: urlString as NSString) {
            completion(cached)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        // descargar imagen en hilo secundario
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    self.cache.setObject(image, forKey: urlString as NSString)
                    await MainActor.run {
                        completion(image)
                    }
                }
            } catch {
                await MainActor.run {
                    completion(nil)
                }
            }
        }
    }
}
