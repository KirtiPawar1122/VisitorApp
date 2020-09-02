

import Foundation
import CoreData


extension Visitor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Visitor> {
        return NSFetchRequest<Visitor>(entityName: "Visitor")
    }

    @NSManaged public var address: String?
    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var phoneNo: Int64
    @NSManaged public var profileImage: Data
    @NSManaged public var visits: NSSet?

}

// MARK: Generated accessors for visits
extension Visitor {

    @objc(addVisitsObject:)
    @NSManaged public func addToVisits(_ value: Visit)

    @objc(removeVisitsObject:)
    @NSManaged public func removeFromVisits(_ value: Visit)

    @objc(addVisits:)
    @NSManaged public func addToVisits(_ values: NSSet)

    @objc(removeVisits:)
    @NSManaged public func removeFromVisits(_ values: NSSet)

}
