

import UIKit

protocol VisitorChartPresentationLogic {
    func presentChartPurposeData(response: VisitorChart.FetchVisitorPurposeType.Response)
    func presentVisitorChartData(response: VisitorChart.DisplayVisitorData.Response)
}

class VisitorChartPresenter : VisitorChartPresentationLogic {
  
    var viewObj : VisitorChartDisplayLogic?

    func presentChartPurposeData(response: VisitorChart.FetchVisitorPurposeType.Response) {
        let viewModel = VisitorChart.FetchVisitorPurposeType.ViewModel(visitTypes: response.visitTypes, totalVisitCount: response.totalVisitCount)
        viewObj?.displayPercenatageDataOnChart(viewModel: viewModel)
    }
    
    func presentVisitorChartData(response: VisitorChart.DisplayVisitorData.Response) {
        print(response)
        let viewModel = VisitorChart.DisplayVisitorData.viewModel(visitorData: response.visitorData)
        viewObj?.displayVisitorChartData(viewModel: viewModel)
    }
    
}
