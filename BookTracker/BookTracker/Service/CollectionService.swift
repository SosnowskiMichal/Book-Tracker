//
//  CollectionService.swift
//  BookManagementApp
//
//  Created by stud on 17/12/2024.
//

import Foundation

class CollectionService: ObservableObject {
    
    @Published var collections: [BookCollection] = []
    private let repository: CollectionRepository
    
    init(repository: CollectionRepository = CollectionRepository()) {
        self.repository = repository
        fetchCollections()
    }
    
    func fetchCollections() {
        collections = repository.fetchCollections()
    }

    func validateCollection(name: String, description: String) -> Bool {
        for collection in collections {
            if collection.name == name {
                return false
            }
        }
        addCollection(name: name, description: description)
        return true
    }
    
    func addCollection(name: String, description: String) {
        guard !name.isEmpty, name.count <= 100, description.count <= 500 else { return }
        repository.addCollection(name: name, description: description)
        fetchCollections()
    }
    
    func deleteCollection(_ collection: BookCollection) {
        repository.deleteCollection(collection)
        fetchCollections()
    }
    
    func deleteCollectionItem(_ collectionItem: BookCollectionItem) {
        repository.deleteCollectionItem(collectionItem)
    }
    
}
