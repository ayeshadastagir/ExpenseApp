import CoreData
extension Income {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Income> {
        return NSFetchRequest<Income>(entityName: "Income")
    }

    @NSManaged public var date: Date?
    @NSManaged public var amount: String?
    @NSManaged public var category: String?
    @NSManaged public var explaination: String?
    @NSManaged public var img: Data?

}

extension Income : Identifiable {

}
