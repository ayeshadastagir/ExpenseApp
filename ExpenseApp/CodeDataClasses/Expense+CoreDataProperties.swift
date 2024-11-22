
import CoreData
extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var date: Date?
    @NSManaged public var amount: String?
    @NSManaged public var category: String?
    @NSManaged public var explaination: String?
    @NSManaged public var img: Data?

}

extension Expense : Identifiable {

}
