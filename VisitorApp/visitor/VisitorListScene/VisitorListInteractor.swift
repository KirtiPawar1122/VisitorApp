
import UIKit
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseDatabase

struct VisitorListInteractorConstants{
    static let visitEntity = "Visit"
    static let dateString = "date"
    
}

protocol VisitorListBusinessLogic{
    func fetchVisitorData(request: VisitorList.fetchVisitorList.Request)
    func fetchVisitorDataWithLimit(fetchOffset: Int,request: VisitorList.fetchVisitorList.Request)
    func fetchVisitorsListByName(request: VisitorList.fetchVisitorRecordByName.Request)
    func fetchVisitorsListByNameNNN()
    func fetchVisitorList(request: VisitorList.fetchAllVisitorsList.Request)
}

class VisitorListInteractor: VisitorListBusinessLogic {
    
    var listPresenterProtocol : VisitorListPresentationLogic?
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var visitorCoreData : VisitorCoreDataStore = VisitorCoreDataStore()
    var offset: Int = 0
    var visit : [Visit] = []
    var ref = DatabaseReference.init()
    let db = Firestore.firestore()
    var visitorData = [DisplayData]()
    var sortedData = [DisplayData]()
    
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
    
    func fetchVisitorList(request: VisitorList.fetchAllVisitorsList.Request) {
        let ref = db.collection("Visitor")
        ref.getDocuments { (snapshots, error) in
            guard let snap = snapshots?.documents else {return}
            for document in snap{
                let data = document.data()
                let visitdata = data["visits"] as! [[String:Any]]
                for item in visitdata{
                    let name = data["name"] as? String
                    let email = data["email"] as? String
                    let phoneNo = data["phoneNo"] as? String
                    let hardwareDetail = data["hardwareDetail"] as? String
                    let profileImage = item["profileVisitImage"] as? String
                    let currentdate = item["date"] as! Timestamp
                    let date = currentdate.dateValue()
                    let purpose = item["purpose"] as? String
                    let company = item["company"] as? String
                    let contactPerson = item["contactPersonName"] as? String
                    let officeLocation = item["officeLocation"] as? String
                    let dataArray = DisplayData(name: name!, email: email!, phoneNo: phoneNo!, purspose: purpose!, date: date , companyName: company!, profileImage: profileImage!, contactPerson: contactPerson!, officeLocation: officeLocation ?? "", hardwareDetails: hardwareDetail ?? "")
                    self.visitorData.append(dataArray)
                }
            }
            self.sortedData = self.visitorData.sorted(by: { $0.date > $1.date })
            print(self.sortedData)
            let visitorResponse = VisitorList.fetchAllVisitorsList.Response(visitorList: self.sortedData)
            self.listPresenterProtocol?.presentVisitorsList(response: visitorResponse)
        }
    }
    
}
