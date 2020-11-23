

import UIKit

protocol VisitorBarChartBusinessLogic{
    func visitorBarChartData(request: VisitorBarChart.VisitorBarChartData.Request)
}

protocol VisitorBarChartDataStore{
    var visitData: [Visit] { get set}
}


class VisitorBarChartInteractor : VisitorBarChartBusinessLogic, VisitorBarChartDataStore {
    var visitData: [Visit] = []
    
    var presenter : VisitorBarChartPresentationLogic?

    func visitorBarChartData(request: VisitorBarChart.VisitorBarChartData.Request) {
        print(request)
        let response = VisitorBarChart.VisitorBarChartData.Response(visitData: visitData)
        presenter?.presentVisitorBarChartData(response: response)
        
    }
    
}
