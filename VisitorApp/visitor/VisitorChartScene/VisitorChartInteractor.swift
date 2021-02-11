

import UIKit
import CoreData

protocol VisitorChartBusinessLogic{
    func visitorsChartData(request: VisitorChart.VisitorChartData.Request)
    func fetchAllData(request: VisitorChart.VisitorChartData.Request)
    func getVisitPurposeType(request: VisitorChart.FetchVisitorPurposeType.Request)
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
    
    func visitorsChartData(request: VisitorChart.VisitorChartData.Request) {
       
        let visitResponse = VisitorChart.VisitorChartData.Response(visitData: data)
        presenter?.prsentChartData(response: visitResponse)
    }
    
    
    func fetchAllData(request: VisitorChart.VisitorChartData.Request){
        let visitorfetchRequest = NSFetchRequest<Visit>(entityName: VisitorInteractorConstants.entityVisit)
         do {
               let record = try context.fetch(visitorfetchRequest)
               //print(record.first?.visitors as Any)
                   for item in record {
                    data = [item]
               }
         let response = VisitorChart.VisitorChartData.Response(visitData: record)
         presenter?.prsentChartData(response: response)
         } catch let error as NSError {
            print(error.description)
        }
    }
    
    
    func getVisitPurposeType(request: VisitorChart.FetchVisitorPurposeType.Request){
        var visitDataObjects = [VisitData]()
        let visitorFetchRequest = NSFetchRequest<Visit>(entityName: VisitorInteractorConstants.entityVisit)
        for visitPurpose in VisitPurpose.allCases {
            let predicate = getPredicate(purpose: visitPurpose)
            visitorFetchRequest.predicate = predicate
            do {
                let record = try context.fetch(visitorFetchRequest)
                let visitData: VisitData = VisitData(visitPurpose: visitPurpose, purposeCount: record.count)
                //visitData.purposeCount = record.count
                //visitData.visitPurpose = visitPurpose
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
}
