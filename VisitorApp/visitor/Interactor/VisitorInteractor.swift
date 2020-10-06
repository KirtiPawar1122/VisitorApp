


import UIKit
import CoreData

class VisitorInteractor {
    
    var presenterProtocol : PresenterProtocol?
    var visitor : [Visitor] = []
    var visit : [Visit] = []
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveRecord(name: String,address: String, phoneNo : Int64, email: String,companyName: String, visitPurpose: String, visitingName: String, profileImage : Data, currentDate: String ){
        
        let visitorEntity = NSEntityDescription.entity(forEntityName: "Visitor", in: context)
        let visitorData = NSManagedObject(entity: visitorEntity!, insertInto: context)
        
        let visitEntity = NSEntityDescription.entity(forEntityName: "Visit", in: context)
        let visitData = NSManagedObject(entity: visitEntity!, insertInto: context)
        
        visitorData.setValue(name, forKey: "name")
        visitorData.setValue(address, forKey: "address")
        visitorData.setValue(phoneNo, forKey: "phoneNo")
        visitorData.setValue(email, forKey: "email")
        visitorData.setValue(profileImage, forKey: "profileImage")
        
        visitData.setValue(companyName, forKey: "companyName")
        visitData.setValue(visitPurpose, forKey: "purpose")
        visitData.setValue(currentDate, forKey: "date")
        visitData.setValue(visitingName, forKey: "visitorName")
        visitData.setValue(visitorData, forKey: "visitors") //core data relationship
       
        do{
            try context.save()
            visit.append(visitData as! Visit)
            self.presenterProtocol?.dataFromInteractor(visitorData: visit)
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func fetchRecord(email : String){
        let visitorsfetchRequest = NSFetchRequest<Visitor>(entityName: "Visitor")
        let predicate = NSPredicate(format: "email == %@", email)
        visitorsfetchRequest.predicate = predicate
        visitorsfetchRequest.fetchLimit = 1
        do {
            let record = try context.fetch(visitorsfetchRequest)
            print(record)
            self.presenterProtocol?.compareData(compareData: record)
        } catch let error as NSError{
            print(error.description)
        }
    }
}

