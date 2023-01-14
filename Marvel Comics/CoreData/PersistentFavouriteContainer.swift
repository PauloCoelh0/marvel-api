//
//  PersistentFavouriteContainer.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import CoreData
import UIKit

final class PersistentFavouriteContainer: NSPersistentContainer {
    private static let entityName: String = "FavouriteCharacter"
    
    static func saveFavourite<T: FavouriteItem>(_ item: T, context: NSManagedObjectContext) {
        guard let exist = try? isFavourite(item.id, context: context), !exist,
              let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return }
        let character = NSManagedObject(entity: entity, insertInto: context)
        character.setValue(item.id, forKey: "id")
        character.setValue(item.image, forKey: "image")
        character.setValue(item.name, forKey: "name")
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func removeFavourite<T: FavouriteItem>(_ item: T, backgroundContext: NSManagedObjectContext?) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %d", item.id)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try backgroundContext?.execute(batchDeleteRequest)
    }
    
    static func clearFavouriteList(backgroundContext: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try backgroundContext.execute(batchDeleteRequest)
        } catch {
            print("Could not delete Movie entity records. \(error)")
        }
    }
    
    static func fetchFavourites(context: NSManagedObjectContext) -> [FavouriteCharacterRepresentableViewModel] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        guard let response = try? context.fetch(fetchRequest) else { return [] }
        return response.map { object in
            FavouriteCharacterRepresentableViewModel(
                id: object.value(forKey: "id") as? Int32 ?? Int32(),
                image: object.value(forKey: "image") as? Data ?? Data(),
                name: object.value(forKey: "name") as? String ?? ""
            )
        }
    }
    
    static func isFavourite(_ id: Int32, context: NSManagedObjectContext) throws -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1
        
        let count = try context.count(for: fetchRequest)
        return count > 0
    }
}
