//
//  Book+CoreDataProperties.swift
//  BookManagementApp
//
//  Created by stud on 07/01/2025.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var key: String?
    @NSManaged public var author: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var status: String?
    @NSManaged public var statusChangeDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var publishYear: Int64
    @NSManaged public var bookDescription: String?
    @NSManaged public var bookCover: BookCover?
    @NSManaged public var collectionItems: NSSet?
    @NSManaged public var bookNotes: NSSet?
    
    var bookNotesArray: [BookNote] {
        let set = bookNotes as? Set<BookNote> ?? []
        return set.sorted { $0.dateAdded ?? Date() < $1.dateAdded ?? Date() }
    }
    
    var collectionItemsArray: [BookCollectionItem] {
        let set = collectionItems as? Set<BookCollectionItem> ?? []
        return Array(set)
    }

}

// MARK: Generated accessors for collectionItems
extension Book {

    @objc(addCollectionItemsObject:)
    @NSManaged public func addToCollectionItems(_ value: BookCollectionItem)

    @objc(removeCollectionItemsObject:)
    @NSManaged public func removeFromCollectionItems(_ value: BookCollectionItem)

    @objc(addCollectionItems:)
    @NSManaged public func addToCollectionItems(_ values: NSSet)

    @objc(removeCollectionItems:)
    @NSManaged public func removeFromCollectionItems(_ values: NSSet)

}

// MARK: Generated accessors for bookNotes
extension Book {

    @objc(addBookNotesObject:)
    @NSManaged public func addToBookNotes(_ value: BookNote)

    @objc(removeBookNotesObject:)
    @NSManaged public func removeFromBookNotes(_ value: BookNote)

    @objc(addBookNotes:)
    @NSManaged public func addToBookNotes(_ values: NSSet)

    @objc(removeBookNotes:)
    @NSManaged public func removeFromBookNotes(_ values: NSSet)

}

extension Book : Identifiable {

}
