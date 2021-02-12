

import UIKit

protocol  VisitorBarChartPresentationLogic {
    func presentVisitorBarChartData(response: VisitorBarChart.VisitorBarChartData.Response)
}

class VisitorBarChartPresenter : VisitorBarChartPresentationLogic {
   
    var viewObject : VisitorBarChartDisplayLogic?
    
    func presentVisitorBarChartData(response: VisitorBarChart.VisitorBarChartData.Response) {
        let viewModelChartData = response.visitData
        let viewmodel = VisitorBarChart.VisitorBarChartData.ViewModel(visitData: viewModelChartData)
        print(viewmodel)
        viewObject?.displayVisitorBarChartData(viewModel: viewmodel)
    }
    
}
