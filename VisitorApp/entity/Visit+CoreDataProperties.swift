//
//  Visit+CoreDataProperties.swift
//  
//
//  Created by Mayur Kamthe on 04/02/21.
//
//

import Foundation
import CoreData


extension Visit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Visit> {
        return NSFetchRequest<Visit>(entityName: "Visit")
    }

    @NSManaged public var companyName: String?
    @NSManaged public var date: Date?
    @NSManaged public var purpose: String?
    @NSManaged public var visitImage: Data?
    @NSManaged public var visitorName: String?
    @NSManaged public var visitors: Visitor?

}
