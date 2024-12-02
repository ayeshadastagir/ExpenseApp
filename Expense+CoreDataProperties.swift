//
//  Expense+CoreDataProperties.swift
//  ExpenseApp
//
//  Created by Ayesha Dastagir on 29/11/2024.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: String?
    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var explaination: String?
    @NSManaged public var img: Data?
    @NSManaged public var primaryKey: UUID?

}

extension Expense : Identifiable {

}
