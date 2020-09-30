

import Foundation
import CoreData


extension Visit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Visit> {
        return NSFetchRequest<Visit>(entityName: "Visit")
    }

    @NSManaged public var date: String?
    @NSManaged public var visitorName: String?
    @NSManaged public var purpose: String?
    @NSManaged public var companyName: String?
    @NSManaged public var visitors: NSSet?
}

// MARK: Generated accessors for visitors
extension Visit {

    @objc(addVisitorsObject:)
    @NSManaged public func addToVisitors(_ value: Visitor)

    @objc(removeVisitorsObject:)
    @NSManaged public func removeFromVisitors(_ value: Visitor)

    @objc(addVisitors:)
    @NSManaged public func addToVisitors(_ values: NSSet)

    @objc(removeVisitors:)
    @NSManaged public func removeFromVisitors(_ values: NSSet)

}
