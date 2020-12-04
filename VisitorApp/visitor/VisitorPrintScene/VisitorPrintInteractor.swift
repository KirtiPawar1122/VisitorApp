

import Foundation
import UIKit
import CoreData

protocol VisitorPrintBusinessLogic {
    func fetchVisitorPrintData(request: VisitorPrint.VisitorPrintData.Request)
}

class VisitorPrintInteractor: VisitorPrintBusinessLogic {
    
    var printPresenter: VisitorPrintPresentationLogic?
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var data: Visit?
    
    func fetchVisitorPrintData(request: VisitorPrint.VisitorPrintData.Request) {
       let visitorfetchRequest = NSFetchRequest<Visit>(entityName: "Visit")
       let predicate = NSPredicate(format: VisitorInteractorConstants.predicateString, request.email ?? "")
       visitorfetchRequest.predicate = predicate
       let sortDescriptors = NSSortDescriptor(key: "date", ascending: false)
       visitorfetchRequest.sortDescriptors = [sortDescriptors]
        
       visitorfetchRequest.fetchLimit = 1
       do {
             let record = try context.fetch(visitorfetchRequest)
             print(record)
             for item in record {
                 data = item
             }
             let response = VisitorPrint.VisitorPrintData.Response(visitData: data)
             print(response)
             printPresenter?.presentPrintfetchResult(response: response)
        } catch let error as NSError {
            print(error.description)
        }
   }
}
