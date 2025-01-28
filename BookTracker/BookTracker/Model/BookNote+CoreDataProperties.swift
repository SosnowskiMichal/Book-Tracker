//
//  BookNote+CoreDataProperties.swift
//  BookManagementApp
//
//  Created by stud on 07/01/2025.
//
//

import Foundation
import CoreData


extension BookNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookNote> {
        return NSFetchRequest<BookNote>(entityName: "BookNote")
    }

    @NSManaged public var content: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var book: Book?

}

extension BookNote : Identifiable {

}
