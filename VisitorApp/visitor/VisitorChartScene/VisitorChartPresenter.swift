

import UIKit

protocol VisitorChartPresentationLogic {
    func prsentChartData(response: VisitorChart.VisitorChartData.Response)
}

class VisitorChartPresenter : VisitorChartPresentationLogic {
   
    var viewObj : VisitorChartDisplayLogic?
    func prsentChartData(response: VisitorChart.VisitorChartData.Response) {
        print(response)
        
        let viewModelData = response.visitData
        let viewModel = VisitorChart.VisitorChartData.ViewModel(visitData: viewModelData)
        viewObj?.displayChart(viewModel: viewModel)
    }
    
}
