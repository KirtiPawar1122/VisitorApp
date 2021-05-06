//
//  Visitor.swift
//  VisitorApp
//
//  Created by Kirti Pawar on 06/04/21.
//  Copyright © 2021 Mayur Kamthe. All rights reserved.
//

import Foundation
import UIKit

struct VisitorModel {
    var email: String
    var name: String
    var phoneNo: String
    var profileImage: String
    var visitData: [[String: Any]]
    var visits: [VisitModel]

    var dictionary: [String: Any] {
        return [
            "email": email,
            "name": name,
            "phoneNo": phoneNo,
            "profileImage": profileImage,
            "visits": visits
        ]
    }
}

struct VisitModel {
    var date: Date
    var company: String
    var purpose: String
    var contactPersonName: String
    var profileVisitImage: String
    var officeLocation: String
    
    var dictionary: [String: Any] {
        return [
            "date": date,
            "company": company,
            "purpose": purpose,
            "contactPersonName": contactPersonName,
            "profileVisitImage": profileVisitImage,
            "officeLocation": officeLocation
        ]
    }
}
