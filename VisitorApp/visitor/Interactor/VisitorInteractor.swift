


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
    static let predicateString = "email == %@"
}

protocol VisitorFormBusinessLogic{
   // func fetchRecord(email : String)
    func fetchRequest(request: VisitorForm.fetchVisitorRecord.Request)
    func fetchAllData(request: VisitorForm.fetchVisitorRecord.Request)
    func saveVisitorRecord(request: VisitorForm.fetchVisitorRecord.Request )
}

class VisitorInteractor: VisitorFormBusinessLogic {

    var presenter : VisitorFormPrsentationLogic?
    var visitor : [Visitor] = []
    var visit : [Visit] = []
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      
    func saveVisitorRecord(request: VisitorForm.fetchVisitorRecord.Request) {
        
        let visitorEntity = NSEntityDescription.entity(forEntityName: VisitorInteractorConstants.entityVisitor, in: context)
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
        //visitorData.setValue(visitData, forKey: "visits")
        //core data relationship
        do {
             try context.save()
             visit.append(visitData as! Visit)
             let response = VisitorForm.fetchVisitorRecord.Response.VisitResponse(visit: visit)
             print(response)
             self.presenter?.presentFetchResults(response: response)
        } catch let error as NSError {
             print(error.description)
        }
    }
    
    func fetchRequest(request: VisitorForm.fetchVisitorRecord.Request) {
        let visitorsfetchRequest = NSFetchRequest<Visitor>(entityName: VisitorInteractorConstants.entityVisitor)
        let predicate = NSPredicate(format: VisitorInteractorConstants.predicateString , request.email ?? "")
        visitorsfetchRequest.predicate = predicate
        visitorsfetchRequest.fetchLimit = 1
        do {
            let record = try context.fetch(visitorsfetchRequest)
            print(record)
            let visitorResponse =  VisitorForm.fetchVisitorRecord.Response.VisitorResponse(visitor: record)
            print(visitorResponse)
            presenter?.presentEmailData(response: visitorResponse)
            
        } catch let error as NSError{
            print(error.description)
        }
    }
    
    
    func fetchAllData(request: VisitorForm.fetchVisitorRecord.Request){
         let visitorsfetchRequest = NSFetchRequest<Visit>(entityName: VisitorInteractorConstants.entityVisit)
        do{
            let record = try context.fetch(visitorsfetchRequest)
            print(record)
            let visitorResponse = VisitorForm.fetchVisitorRecord.Response.VisitResponse(visit: record)
            print(visitorResponse)
            presenter?.presentFetchResults(response: visitorResponse)
            
        }catch let error as NSError{
            print(error.description)
        }
    }
}

