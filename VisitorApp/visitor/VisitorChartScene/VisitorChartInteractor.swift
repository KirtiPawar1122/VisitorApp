

import UIKit

protocol VisitorChartBusinessLogic{
    func visitorsChartData(request: VisitorChart.VisitorChartData.Request)
}

protocol VisitorChartDataStore{
    var data : [Visit] { get set }
}

class VisitorChartInteractor : VisitorChartBusinessLogic, VisitorChartDataStore {
    var data: [Visit] = []
    var presenter : VisitorChartPresentationLogic?
    
    func visitorsChartData(request: VisitorChart.VisitorChartData.Request) {
        //let visitResponse = VisitorChart.VisitorChartData.Response(visitData: data)
        let visitResponse = VisitorChart.VisitorChartData.Response(visitData: data)
        presenter?.prsentChartData(response: visitResponse)
    }
}
