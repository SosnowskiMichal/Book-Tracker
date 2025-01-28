//
//  GoalItem+CoreDataProperties.swift
//  BookManagementApp
//
//  Created by stud on 07/01/2025.
//
//

import Foundation
import CoreData


extension GoalItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoalItem> {
        return NSFetchRequest<GoalItem>(entityName: "GoalItem")
    }

    @NSManaged public var dateAdded: Date?
    @NSManaged public var bookCover: BookCover?
    @NSManaged public var goal: Goal?

}

extension GoalItem : Identifiable {

}
