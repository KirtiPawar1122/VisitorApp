
import UIKit
import CoreData

class VisitorCoreDataStore {
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var visit : [Visit] = []
    
    
    func saveVisitorRecord(request: VisitorForm.saveVisitorRecord.Request){
        
        var visitorData: Visitor
        if let existingVisitor = getVisitorForRequest(request: request) {
            visitorData = existingVisitor
        } else {
            let visitorEntity = NSEntityDescription.entity(forEntityName: VisitorInteractorConstants.entityVisitor, in: context)
            visitorData = NSManagedObject(entity: visitorEntity!, insertInto: context) as! Visitor
        }
        
        /* let visitorEntity = NSEntityDescription.entity(forEntityName: VisitorInteractorConstants.entityVisitor, in: context)
         let visitorData = NSManagedObject(entity: visitorEntity!, insertInto: context)*/
        
        // check if visitor exists & fetch visitor else create new
        visitorData.setValue(request.name, forKey: VisitorInteractorConstants.visitorName)
        visitorData.setValue(request.phoneNo, forKey: VisitorInteractorConstants.visitorPhoneNo)
        visitorData.setValue(request.email, forKey: VisitorInteractorConstants.visitorEmail)
        visitorData.setValue(request.profileImage, forKey: VisitorInteractorConstants.visitorProfileImage)
        
        let visitEntity = NSEntityDescription.entity(forEntityName: VisitorInteractorConstants.entityVisit, in: context)
        let visitData = NSManagedObject(entity: visitEntity!, insertInto: context)
        
        visitData.setValue(request.companyName, forKey: VisitorInteractorConstants.visitorCompanyName)
        visitData.setValue(request.visitPurpose, forKey: VisitorInteractorConstants.visitorPurpose)
        visitData.setValue(request.currentDate, forKey: VisitorInteractorConstants.currentDate)
        visitData.setValue(request.visitingName, forKey: VisitorInteractorConstants.visitingPersonName)
        visitData.setValue(request.profileImage, forKey: "visitImage")
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
        let predicate = NSPredicate(format: VisitorInteractorConstants.predicateString, request.phoneNo ?? "")
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: false)
        visitorfetchRequest.sortDescriptors = [sortDescriptors]
        visitorfetchRequest.predicate = predicate
        visitorfetchRequest.fetchLimit = 1
        do {
            let record = try context.fetch(visitorfetchRequest)
            //print(record.first?.visitors as Any)
            for item in record {
                completionhanlder(item)
                //print(item)
                visit = [item]
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func deleteVisitorRecord(){
        //ToDo : delete code
    }
    
    
    func getVisitorForRequest(request: VisitorForm.saveVisitorRecord.Request) -> Visitor?
    {
        let visitorfetchRequest = NSFetchRequest<Visitor>(entityName: VisitorInteractorConstants.entityVisitor)
        let predicate = NSPredicate(format: VisitorInteractorConstants.predicateVisitor, request.phoneNo ?? "")
        //let sortDescriptors = NSSortDescriptor(key: "date", ascending: false)
        //visitorfetchRequest.sortDescriptors = [sortDescriptors]
        visitorfetchRequest.predicate = predicate
        visitorfetchRequest.fetchLimit = 1
        do {
            let record = try context.fetch(visitorfetchRequest)
            return record.first
        } catch let error as NSError {
            print(error.description)
            return nil
        }
        
    }

    func getVisitTypes() -> [VisitData]{
        var visitDataObjects = [VisitData]()
        let visitorFetchRequest = NSFetchRequest<Visit>(entityName: VisitorInteractorConstants.entityVisit)
        for visitPurpose in VisitPurpose.allCases {
            let predicate = getPredicate(purpose: visitPurpose)
            visitorFetchRequest.predicate = predicate
            do {
                let record = try context.fetch(visitorFetchRequest)
                let visitData: VisitData = VisitData(visitPurpose: visitPurpose, purposeCount: record.count)
                //visitData.purposeCount = record.count
                //visitData.visitPurpose = visitPurpose
                visitDataObjects.append(visitData)
            } catch let error as NSError {
                print(error.description)
                return visitDataObjects
            }
        }
        return visitDataObjects
    }
    
    func getPredicate(purpose: VisitPurpose) -> NSPredicate{
        return NSPredicate(format: VisitorInteractorConstants.predicatePurpose, getPurposeText(purpose: purpose))
    }
    
    func getPurposeText(purpose: VisitPurpose) -> String {
        switch purpose {
        case .guestVisit:
            return "Guest Visit"
        case .meeting:
            return "Meeting"
        case .other:
            return "Other"
        case .interview:
            return "Interview"
        }
    }
}
