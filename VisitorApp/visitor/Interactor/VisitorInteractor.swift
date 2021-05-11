


import UIKit
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseDatabase

struct VisitorInteractorConstants {
    static let visitorName = "name"
    static let visitorAddress = "address"
    static let visitorPhoneNo = "phoneNo"
    static let visitorEmail = "email"
    static let visitorProfileImage = "profileImage"
    static let visitorCompanyName = "companyName"
    static let visitorPurpose = "purpose"
    static let visitorImage = "visitImage"
    static let currentDate = "date"
    static let visitingPersonName = "visitorName"
    static let visitors = "visitors"
    static let entityVisitor = "Visitor"
    static let entityVisit = "Visit"
    static let predicateString = "visitors.phoneNo == %@"
    static let predicateVisitor = "phoneNo == %@"
    static let predicatePurpose = "purpose == %@"

    
}

protocol VisitorFormBusinessLogic{
    func fetchRequest(request: VisitorForm.fetchVisitorRecord.Request)
    func saveVisitorRecord(request: VisitorForm.saveVisitorRecord.Request)
    func saveVisitorsRecord(request: VisitorForm.saveVisitorsRecord.Request)
    func fetchVisitorsReccord(request: VisitorForm.fetchVisitorsRecord.Request)
}

class VisitorInteractor: VisitorFormBusinessLogic {
    
  
    var presenter : VisitorFormPrsentationLogic?
    var visitorCoreData : VisitorCoreDataStore = VisitorCoreDataStore()
    var ref = DatabaseReference.init()
    let db = Firestore.firestore()
    var visitorData = [DisplayData]()
    var sortedData = [DisplayData]()

    func saveVisitorRecord(request: VisitorForm.saveVisitorRecord.Request) {
        visitorCoreData.saveVisitorRecord(request: request)
    }
    
    func fetchRequest(request: VisitorForm.fetchVisitorRecord.Request) {
        
        visitorCoreData.fetchRecord(request: request) { (records) in
            let visitorResponse = VisitorForm.fetchVisitorRecord.Response(visit: records)
            self.presenter?.presentFetchResults(response: visitorResponse)
        }
    }
    
    func saveVisitorsRecord(request: VisitorForm.saveVisitorsRecord.Request){
        let dict : [String: Any] = ["email" : request.email, "phoneNo": request.phonNo, "name": request.name, "profileImage": request.profileImage,"hardwareDetail": request.hardwareDetail,"visits": request.visits]
        db.collection("Visitor").document(request.phonNo).setData(dict)
    }
    
    func fetchVisitorsReccord(request: VisitorForm.fetchVisitorsRecord.Request){
        let ref = db.collection("Visitor").whereField("phoneNo", isEqualTo: request.phoneNo!)
        visitorData.removeAll()
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
            let visitorRecord = VisitorForm.fetchVisitorsRecord.Response(visitorData: self.sortedData)
            self.presenter?.presentFethcedResults(response: visitorRecord)
        }
    }
}
