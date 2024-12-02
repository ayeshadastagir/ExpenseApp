
import CoreData

public class ManagedObject: NSManagedObject {
    static var entityName: String {
        return String(describing: self)
    }
}

@objc(Income)
public class Income: ManagedObject {

}
