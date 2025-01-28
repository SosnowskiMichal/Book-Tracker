//
//  CollectionRepository.swift
//  BookManagementApp
//
//  Created by stud on 17/12/2024.
//

import Foundation
import CoreData

class CollectionRepository {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    func fetchCollections() -> [BookCollection] {
        let request = BookCollection.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do { return try context.fetch(request) }
        catch {
            print("Failed to fetch collections: \(error)")
            return []
        }
    }
    
    func fetchNumberOfCollections() -> Int? {
        let request = BookCollection.fetchRequest()
        
        do { return try context.count(for: request) }
        catch {
            print("Error fetching number of collections: \(error)")
            return nil
        }
    }
    
    func addCollection(name: String, description: String) {
        let newCollection = BookCollection(context: context)
        newCollection.name = name
        newCollection.collectionDescription = description
        newCollection.dateCreated = Date()
        saveContext()
    }
    
    func deleteCollection(_ collection: BookCollection) {
        context.delete(collection)
        saveContext()
    }
    
    func deleteCollectionItem(_ collectionItem: BookCollectionItem) {
        context.delete(collectionItem)
        saveContext()
    }

    private func saveContext() {
        if context.hasChanges {
            do { try context.save() }
            catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
