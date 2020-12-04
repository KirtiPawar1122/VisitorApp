


import UIKit
import CoreData

struct VisitorInteractorConstants {
    static let visitorName = "name"
    static let visitorAddress = "address"
    static let visitorPhoneNo = "phoneNo"
    static let visitorEmail = "email"
    static let visitorProfileImage = "profileImage"
    static let visitorCompanyName = "companyName"
    static let visitorPurpose = "purpose"
    static let currentDate = "date"
    static let visitingPersonName = "visitorName"
    static let visitors = "visitors"
    static let entityVisitor = "Visitor"
    static let entityVisit = "Visit"
    static let predicateString = "visitors.email == %@"
}

protocol VisitorFormBusinessLogic{
    func fetchRequest(request: VisitorForm.fetchVisitorRecord.Request)
    func saveVisitorRecord(request: VisitorForm.saveVisitorRecord.Request)
}

protocol  VisitorFormDataStore {
    var records : Visit? { get }
}

class VisitorInteractor: VisitorFormBusinessLogic, VisitorFormDataStore {
    
    var records: Visit?
    var presenter : VisitorFormPrsentationLogic?
    var visitorCoreData : VisitorCoreDataStore = VisitorCoreDataStore()
    var visitor : [Visitor] = []
    var visit : [Visit] = []
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      
    func saveVisitorRecord(request: VisitorForm.saveVisitorRecord.Request) {
        visitorCoreData.saveVisitorRecord(request: request)
    }
    
    func fetchRequest(request: VisitorForm.fetchVisitorRecord.Request) {
        
        visitorCoreData.fetchRecord(request: request) { (records) in
            print(records)
            let visitorResponse = VisitorForm.fetchVisitorRecord.Response(visit: records)
            self.presenter?.presentFetchResults(response: visitorResponse)
        }
    }
}

