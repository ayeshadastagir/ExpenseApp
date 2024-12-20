
import CoreData
extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: Expense.entityName)
    }

    @NSManaged public var date: Date?
    @NSManaged public var amount: String?
    @NSManaged public var category: String?
    @NSManaged public var explaination: String?
    @NSManaged public var img: Data?
    @NSManaged public var id: UUID?

}

extension Expense : Identifiable {

}
