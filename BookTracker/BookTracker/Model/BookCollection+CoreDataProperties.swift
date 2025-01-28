//
//  BookCollection+CoreDataProperties.swift
//  BookManagementApp
//
//  Created by stud on 07/01/2025.
//
//

import Foundation
import CoreData


extension BookCollection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookCollection> {
        return NSFetchRequest<BookCollection>(entityName: "BookCollection")
    }

    @NSManaged public var collectionDescription: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var name: String?
    @NSManaged public var collectionItems: NSSet?
    
    var collectionItemsArray: [BookCollectionItem] {
        let set = collectionItems as? Set<BookCollectionItem> ?? []
        return set.sorted {
            ($0.book?.title ?? "").localizedCaseInsensitiveCompare($1.book?.title ?? "") == .orderedAscending
        }
    }

}

// MARK: Generated accessors for collectionItems
extension BookCollection {

    @objc(addCollectionItemsObject:)
    @NSManaged public func addToCollectionItems(_ value: BookCollectionItem)

    @objc(removeCollectionItemsObject:)
    @NSManaged public func removeFromCollectionItems(_ value: BookCollectionItem)

    @objc(addCollectionItems:)
    @NSManaged public func addToCollectionItems(_ values: NSSet)

    @objc(removeCollectionItems:)
    @NSManaged public func removeFromCollectionItems(_ values: NSSet)

}

extension BookCollection : Identifiable {

}
