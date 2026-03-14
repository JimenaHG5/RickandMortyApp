//
//  FavoriteCharacter+CoreData.swift
//  CharactersRickandMorty2
//
//  Created by Jimena Hernández García on 12/03/26.
//

import Foundation
import CoreData

// MARK: - FavoriteCharacter

/// Clase NSManagedObject que representa un personaje favorito en Core Data
@objc(FavoriteCharacter)
public class FavoriteCharacter: NSManagedObject {
    
}

// MARK: - Propiedades

extension FavoriteCharacter {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCharacter> {
        return NSFetchRequest<FavoriteCharacter>(entityName: "FavoriteCharacter")
    }
    
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var status: String?
    @NSManaged public var species: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var gender: String?
    @NSManaged public var originName: String?
    @NSManaged public var locationName: String?
}

// MARK: - Identifiable

extension FavoriteCharacter: Identifiable { }
