//
//  Goal+CoreDataProperties.swift
//  BookManagementApp
//
//  Created by stud on 07/01/2025.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var booksRead: Int64
    @NSManaged public var booksToRead: Int64
    @NSManaged public var dateAdded: Date?
    @NSManaged public var finishDate: Date?
    @NSManaged public var isActive: Bool
    @NSManaged public var isCompleted: Bool
    @NSManaged public var name: String?
    @NSManaged public var completionPercent: Double
    @NSManaged public var goalItems: NSSet?
    
    var goalItemsArray: [GoalItem] {
        let set = goalItems as? Set<GoalItem> ?? []
        return set.sorted { $0.dateAdded ?? Date() < $1.dateAdded ?? Date() }
    }

}

// MARK: Generated accessors for goalItems
extension Goal {

    @objc(addGoalItemsObject:)
    @NSManaged public func addToGoalItems(_ value: GoalItem)

    @objc(removeGoalItemsObject:)
    @NSManaged public func removeFromGoalItems(_ value: GoalItem)

    @objc(addGoalItems:)
    @NSManaged public func addToGoalItems(_ values: NSSet)

    @objc(removeGoalItems:)
    @NSManaged public func removeFromGoalItems(_ values: NSSet)

}

extension Goal : Identifiable {

}
