//
//  BookCollectionItem+CoreDataProperties.swift
//  BookManagementApp
//
//  Created by stud on 07/01/2025.
//
//

import Foundation
import CoreData


extension BookCollectionItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookCollectionItem> {
        return NSFetchRequest<BookCollectionItem>(entityName: "BookCollectionItem")
    }

    @NSManaged public var dateAdded: Date?
    @NSManaged public var book: Book?
    @NSManaged public var collection: BookCollection?

}

extension BookCollectionItem : Identifiable {

}
