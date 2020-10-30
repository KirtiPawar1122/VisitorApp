
import UIKit
import CoreData

class VisitorCoreDataStore {
     var appdelegate = UIApplication.shared.delegate as! AppDelegate
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     var visit : [Visit] = []

    func saveVisitorRecord(request: VisitorForm.saveVisitorRecord.Request){
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
        //core data relationship
        do {
             try context.save()
             visit.append(visitData as! Visit)
             print(visitData)
        } catch let error as NSError {
             print(error.description)
        }
        
    }
    
    func fetchRecord(request : VisitorForm.fetchVisitorRecord.Request,completionhanlder: @escaping(Visit) -> Void ) {
        //var visit = Visit()
        let visitorfetchRequest = NSFetchRequest<Visit>(entityName: VisitorInteractorConstants.entityVisit)
        let predicate = NSPredicate(format: VisitorInteractorConstants.predicateString, request.email ?? "")
        visitorfetchRequest.predicate = predicate
        visitorfetchRequest.fetchLimit = 1
        
        do {
        let record = try context.fetch(visitorfetchRequest)
        print(record.first?.visitors as Any)
        for item in record {
            completionhanlder(item)
            print(item)
            visit = [item]
        }
        } catch let error as NSError {
            print(error.description)
        }

    }

    func deleteVisitorRecord(){
        //ToDo : delete code
    }
}
