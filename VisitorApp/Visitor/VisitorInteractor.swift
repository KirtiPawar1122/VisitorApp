


import UIKit
import CoreData

class VisitorInteractor {
    
    var presenterProtocol : PresenterProtocol?
    var visitor : [Visitor] = []
    var visit : [Visit] = []
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    func save(name: String,address: String, phoneNo : Int64, email: String,companyName: String, visitPurpose: String, visitingName: String, profileImage : Data, currentDate: String ){
        
        let visitorEntity = NSEntityDescription.entity(forEntityName: "Visitor", in: context)
        let visitorData = NSManagedObject(entity: visitorEntity!, insertInto: context)
        print(visitorData)
        
        let visitEntity = NSEntityDescription.entity(forEntityName: "Visit", in: context)
        let visitData = NSManagedObject(entity: visitEntity!, insertInto: context)
        print(visitData)
        
        visitorData.setValue(name, forKey: "name")
        visitorData.setValue(address, forKey: "address")
        visitorData.setValue(phoneNo, forKey: "phoneNo")
        visitorData.setValue(email, forKey: "email")
        visitorData.setValue(profileImage, forKey: "profileImage")
        
        visitData.setValue(companyName, forKey: "companyName")
        visitData.setValue(visitPurpose, forKey: "purpose")
        visitData.setValue(currentDate, forKey: "date")
        visitData.setValue(visitingName, forKey: "visitorName")
        visitData.setValue(visitorData, forKey: "visitors") // core data relationship
        
        do{
            try context.save()
           // visitor.append(visitorData as! Visitor)
          //  print(visitor.first?.visits as Any)
            visit.append(visitData as! Visit)
            print(visit.first?.visitors as Any)
           // self.presenterProtocol?.getDatafromInteractor(visitorData: visitor)
            self.presenterProtocol?.getDatafromInteractor(visitorData: visit)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

    }
    
    func fetchRecord(){
        var arrVisits = [Visit]()
        let visitorsfetchRequest = NSFetchRequest<Visit>(entityName: "Visit")
        do {
            arrVisits = try context.fetch(visitorsfetchRequest)
            for item in arrVisits{
               // print(item.name!, item.address!, item.email!, item.phoneNo,item.profileImage)
                print(item.companyName!, item.date!, item.visitorName!, item.purpose!,item.visitors?.allObjects as Any)
            }
        } catch let error as NSError{
            print(error.description)
        }
    }

    
    func compareData(email : String){
//        var data : [Any] = []
//        let fetchRequest = NSFetchRequest<Visitor>(entityName: "Visitor")
//        do {
//            let fetchedRequests =  try context.fetch(fetchRequest)
//            for item in fetchedRequests{
//                let visitorObj: Visitor = Visitor()
//                if email == item.email{
//                    print(item.name! , item.address!,item.companyName!, item.phoneNo,item.email!, item.visitingName!, item.visitPurpose!)
//                    if let name = item.name{
//                        visitorObj.name = name
//                    }
//                }else {
//                    print("error in fetching data")
//                }
//                data.append(visitorObj)
//                print(data)
//            }
//        } catch let error as NSError{
//            print(error.description)
//        }
//    }
}
}
