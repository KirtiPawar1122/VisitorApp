
import UIKit
import CoreData

class VisitorListInteractor {

    var listPresenterProtocol : VisitorListPresenterProtocol?

    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fecthAllData(){
        let visitorsFetchRequest = NSFetchRequest<Visit>(entityName: "Visit")
        do {
            let record = try context.fetch(visitorsFetchRequest)
            print(record)
            self.listPresenterProtocol!.visitorAllData(data: record)
        } catch let error as NSError{
            print(error.description)
        }
      }
}
