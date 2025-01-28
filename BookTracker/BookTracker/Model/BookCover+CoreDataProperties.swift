//
//  BookCover+CoreDataProperties.swift
//  BookManagementApp
//
//  Created by stud on 14/01/2025.
//
//

import Foundation
import CoreData


extension BookCover {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookCover> {
        return NSFetchRequest<BookCover>(entityName: "BookCover")
    }

    @NSManaged public var bookKey: String?
    @NSManaged public var coverImage: Data?
    @NSManaged public var book: Book?
    @NSManaged public var goalItems: NSSet?
    
    var goalItemsArray: [GoalItem] {
        let set = goalItems as? Set<GoalItem> ?? []
        return Array(set)
    }

}

// MARK: Generated accessors for goalItems
extension BookCover {

    @objc(addGoalItemsObject:)
    @NSManaged public func addToGoalItems(_ value: GoalItem)

    @objc(removeGoalItemsObject:)
    @NSManaged public func removeFromGoalItems(_ value: GoalItem)

    @objc(addGoalItems:)
    @NSManaged public func addToGoalItems(_ values: NSSet)

    @objc(removeGoalItems:)
    @NSManaged public func removeFromGoalItems(_ values: NSSet)

}

extension BookCover : Identifiable {

}
