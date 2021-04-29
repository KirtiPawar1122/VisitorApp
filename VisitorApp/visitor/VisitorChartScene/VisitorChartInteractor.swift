

import UIKit
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseDatabase

protocol VisitorChartBusinessLogic{
    func getVisitPurposeType(request: VisitorChart.FetchVisitorPurposeType.Request)
    func getVisitorsAllData(request: VisitorChart.DisplayVisitorData.Request)
}

protocol VisitorChartDataStore{
    var data : [Visit] { get set }
}

class VisitorChartInteractor : VisitorChartBusinessLogic, VisitorChartDataStore {
    var data: [Visit] = []
    var presenter : VisitorChartPresentationLogic?
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var visitcount = 0
    var ref = DatabaseReference.init()
    let db = Firestore.firestore()
    var visitorData = [DisplayData]()

    func getVisitPurposeType(request: VisitorChart.FetchVisitorPurposeType.Request){
        var visitDataObjects = [VisitData]()
        let visitorFetchRequest = NSFetchRequest<Visit>(entityName: VisitorInteractorConstants.entityVisit)
        for visitPurpose in VisitPurpose.allCases {
            let predicate = getPredicate(purpose: visitPurpose)
            visitorFetchRequest.predicate = predicate
            do {
                let record = try context.fetch(visitorFetchRequest)
                let visitData: VisitData = VisitData(visitPurpose: visitPurpose, purposeCount: record.count)
                visitcount = visitcount + visitData.purposeCount
                visitDataObjects.append(visitData)
            } catch let error as NSError {
                print(error.description)
            }
        }
        let response = VisitorChart.FetchVisitorPurposeType.Response(visitTypes: visitDataObjects, totalVisitCount: visitcount)
        presenter?.presentChartPurposeData(response: response)
        
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
    
    func getVisitorsAllData(request: VisitorChart.DisplayVisitorData.Request) {
        let ref = db.collection("Visitor")
        ref.getDocuments { [self] (snapshots, error) in
               guard let snap = snapshots?.documents else {return}
               for document in snap{
                   let data = document.data()
                   let visitdata = data["visits"] as! [[String:Any]]
                   for item in visitdata{
                       let name = data["name"] as? String
                       let email = data["email"] as? String
                       let phoneNo = data["phoneNo"] as? String
                       let profileImage = item["profileVisitImage"] as? String
                       let currentdate = item["date"] as! Timestamp
                       let date = currentdate.dateValue()
                       let purpose = item["purpose"] as? String
                       let company = item["company"] as? String
                       let contactPerson = item["contactPersonName"] as? String
                    
                    let dataArray = DisplayData(name: name!, email: email!, phoneNo: phoneNo!, purspose: purpose!, date: date , companyName: company!, profileImage: profileImage!, contactPerson: contactPerson!)
                    print(dataArray)
                    self.visitorData.append(dataArray)
                   }
               }
            let visitorResponse = VisitorChart.DisplayVisitorData.Response(visitorData: visitorData)
            self.presenter?.presentVisitorChartData(response: visitorResponse)
        }
        
    }
}
