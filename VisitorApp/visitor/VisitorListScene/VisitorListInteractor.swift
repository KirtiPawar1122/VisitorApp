
import UIKit
import CoreData

struct VisitorListInteractorConstants{
    static let visitEntity = "Visit"
}

protocol VisitorListBusinessLogic{
    func fetchVisitorData(request: VisitorList.fetchVisitorList.Request)
}

class VisitorListInteractor: VisitorListBusinessLogic {
  
    var listPresenterProtocol : VisitorListPresentationLogic?
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
 
    func fetchVisitorData(request: VisitorList.fetchVisitorList.Request) {
        let visitorFetchRequest = NSFetchRequest<Visit>(entityName: VisitorListInteractorConstants.visitEntity)
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: false)
        visitorFetchRequest.sortDescriptors = [sortDescriptors]
        do{
            let record = try context.fetch(visitorFetchRequest)
            print(record)
            let response = VisitorList.fetchVisitorList.Response(visit: record)
            listPresenterProtocol?.presentVisitorListResult(response: response)
        } catch let error as NSError{
            
            print(error.description)
        }
    }
      
}
