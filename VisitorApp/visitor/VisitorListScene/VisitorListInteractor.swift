
import UIKit
import CoreData

protocol VisitorListBusinessLogic{
    func fetchAllData(request: VisitorList.fetchVisitorList.Request)
}

class VisitorListInteractor: VisitorListBusinessLogic {
  
    var listPresenterProtocol : VisitorListPresentationLogic?
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
 
    func fetchAllData(request: VisitorList.fetchVisitorList.Request) {
        let visitorFetchRequest = NSFetchRequest<Visit>(entityName: "Visit")
        do{
            let record = try context.fetch(visitorFetchRequest)
            print(record)
            let response = VisitorList.fetchVisitorList.Response(visit: record)
            listPresenterProtocol?.presentListFetchResult(response: response)
        } catch let error as NSError{
            print(error.description)
        }
    }
      
}
