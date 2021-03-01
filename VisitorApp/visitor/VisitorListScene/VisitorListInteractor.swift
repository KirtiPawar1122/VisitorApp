
import UIKit
import CoreData

struct VisitorListInteractorConstants{
    static let visitEntity = "Visit"
    static let dateString = "date"
    
}

protocol VisitorListBusinessLogic{
    func fetchVisitorData(request: VisitorList.fetchVisitorList.Request)
    func fetchVisitorDataWithLimit(fetchOffset: Int,request: VisitorList.fetchVisitorList.Request)
    func fetchVisitorsListByName(request: VisitorList.fetchVisitorRecordByName.Request)
    func fetchVisitorsListByNameNNN()
}

class VisitorListInteractor: VisitorListBusinessLogic {
    
    var listPresenterProtocol : VisitorListPresentationLogic?
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var visitorCoreData : VisitorCoreDataStore = VisitorCoreDataStore()
    var offset: Int = 0
    var visit : [Visit] = []
    
    func fetchVisitorData(request: VisitorList.fetchVisitorList.Request) {
        let visitorFetchRequest = NSFetchRequest<Visit>(entityName: VisitorListInteractorConstants.visitEntity)
        let sortDescriptors = NSSortDescriptor(key: VisitorListInteractorConstants.dateString , ascending: false)
        visitorFetchRequest.sortDescriptors = [sortDescriptors]
        do{
            let record = try context.fetch(visitorFetchRequest)
            let response = VisitorList.fetchVisitorRecordByName.Response(visit: record)
            listPresenterProtocol?.presentAllVisitorsRecord(response: response)
        } catch let error as NSError{
            print(error.description)
        }
    }
    
    
    func fetchVisitorDataWithLimit(fetchOffset: Int,request: VisitorList.fetchVisitorList.Request) {
        let visitorFetchRequest = NSFetchRequest<Visit>(entityName: VisitorListInteractorConstants.visitEntity)
        let sortDescriptors = NSSortDescriptor(key: VisitorListInteractorConstants.dateString , ascending: false)
        visitorFetchRequest.sortDescriptors = [sortDescriptors]
        visitorFetchRequest.fetchLimit = 10 //fetch only first 10 records
        //visitorFetchRequest.fetchBatchSize = 10
        visitorFetchRequest.fetchOffset = fetchOffset
        
        do{
            let record = try context.fetch(visitorFetchRequest)
            //print(record)
            let response = VisitorList.fetchVisitorList.Response(visit: record)
            listPresenterProtocol?.presentVisitorListResult(response: response)
            
        } catch let error as NSError{
            print(error.description)
        }
    }
    
    func fetchVisitorsListByName(request: VisitorList.fetchVisitorRecordByName.Request){
        let visitorfetchRequest = NSFetchRequest<Visit>(entityName: VisitorInteractorConstants.entityVisit)
        let predicate = NSPredicate(format: "visitors.name contains[c] %@", request.name ?? "")
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: false)
        visitorfetchRequest.sortDescriptors = [sortDescriptors]
        visitorfetchRequest.predicate = predicate
        do {
            let record = try context.fetch(visitorfetchRequest)
            //print(record.first?.visitors as Any)
            for item in record {
                print(item)
                visit = [item]
                print(visit)
            }
            let response = VisitorList.fetchVisitorRecordByName.Response(visit: record)
            listPresenterProtocol?.presentAllVisitorsRecord(response: response)
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func fetchVisitorsListByNameNNN(){
        let visitorFetchRequest = NSFetchRequest<Visit>(entityName: VisitorListInteractorConstants.visitEntity)
        
       // let predicate = NSPredicate(format: "visitors.name == Kirti")
        let sortDescriptors = NSSortDescriptor(key: VisitorListInteractorConstants.dateString , ascending: false)
        visitorFetchRequest.sortDescriptors = [sortDescriptors]
        //visitorFetchRequest.predicate = predicate
        //visitorFetchRequest.fetchLimit = 10 //fetch only first 10 records
        
        do{
            let record = try context.fetch(visitorFetchRequest)
            print(record)
           
            for item in record{
                if item.visitors?.name == "Kirti Pawar" {
                    print(item)
                }
            }
            //let response = VisitorList.fetchVisitorList.Response(visit: record)
           // listPresenterProtocol?.presentVisitorListResult(response: response)
        } catch let error as NSError{
            print(error.description)
        }
        
    }
}
