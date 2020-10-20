


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
        
      /*  let visitorEntity = NSEntityDescription.entity(forEntityName: VisitorInteractorConstants.entityVisitor, in: context)
        let visitorData = NSManagedObject(entity: visitorEntity!, insertInto: context)
        
        visitorData.setValue(request.name, forKey: VisitorInteractorConstants.visitorName)
        visitorData.setValue(request.address, forKey: VisitorInteractorConstants.visitorAddress)
        visitorData.setValue(request.phoneNo, forKey: VisitorInteractorConstants.visitorPhoneNo)
        visitorData.setValue(request.email, forKey: VisitorInteractorConstants.visitorEmail)
        visitorData.setValue(request.profileImage, forKey: VisitorInteractorConstants.visitorProfileImage)
        
        let visitEntity = NSEntityDescription.entity(forEntityName: VisitorInteractorConstants.entityVisit, in: context)
        let visitData = NSManagedObject(entity: visitEntity!, insertInto: context)
        
        visitData.setValue(request.companyName, forKey: VisitorInteractorConstants.visitorCompanyName)
        visitData.setValue(request.visitPurpose, forKey: VisitorInteractorConstants.visitorPurpose)
        visitData.setValue(request.currentDate, forKey: VisitorInteractorConstants.currentDate)
        visitData.setValue(request.visitingName, forKey: VisitorInteractorConstants.visitingPersonName)
        visitData.setValue(visitorData, forKey: VisitorInteractorConstants.visitors)
        //core data relationship
        do {
             try context.save()
             visit.append(visitData as! Visit)
             print(visitData)
        } catch let error as NSError {
             print(error.description)
        }*/
    }
    
    func fetchRequest(request: VisitorForm.fetchVisitorRecord.Request) {
        
        visitorCoreData.fetchRecord(request: request) { (records) in
            print(records)
            let visitorResponse = VisitorForm.fetchVisitorRecord.Response(visit: records)
            self.presenter?.presentFetchResults(response: visitorResponse)
        }

      /*  let visitorfetchRequest = NSFetchRequest<Visit>(entityName: VisitorInteractorConstants.entityVisit)
        let predicate = NSPredicate(format: VisitorInteractorConstants.predicateString, request.email ?? "")
        visitorfetchRequest.predicate = predicate
        visitorfetchRequest.fetchLimit = 1
       
        do {
            let record = try context.fetch(visitorfetchRequest)
            print(record)
            for item in record{
                print(item)
                let visitorResponse = VisitorForm.fetchVisitorRecord.Response(visit: item)
                presenter?.presentFetchResults(response: visitorResponse)
            }
        }catch let error as NSError{
            print(error.description)
        }*/
        
    }
}

