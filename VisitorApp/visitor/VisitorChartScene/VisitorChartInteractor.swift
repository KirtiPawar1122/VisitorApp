

import UIKit
import CoreData

protocol VisitorChartBusinessLogic{
    func visitorsChartData(request: VisitorChart.VisitorChartData.Request)
    func fetchAllData(request: VisitorChart.VisitorChartData.Request)
}

protocol VisitorChartDataStore{
    var data : [Visit] { get set }
}

class VisitorChartInteractor : VisitorChartBusinessLogic, VisitorChartDataStore {
    var data: [Visit] = []
    var presenter : VisitorChartPresentationLogic?
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func visitorsChartData(request: VisitorChart.VisitorChartData.Request) {
       
        let visitResponse = VisitorChart.VisitorChartData.Response(visitData: data)
        presenter?.prsentChartData(response: visitResponse)
    }
    
    
    func fetchAllData(request: VisitorChart.VisitorChartData.Request){
        let visitorfetchRequest = NSFetchRequest<Visit>(entityName: VisitorInteractorConstants.entityVisit)
         do {
               let record = try context.fetch(visitorfetchRequest)
               print(record.first?.visitors as Any)
                   for item in record {
                    data = [item]
               }
            let response = VisitorChart.VisitorChartData.Response(visitData: record)
            presenter?.prsentChartData(response: response)
            } catch let error as NSError {
                   print(error.description)
        }
        
    
    }
}
