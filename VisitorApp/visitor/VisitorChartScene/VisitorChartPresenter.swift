

import UIKit

protocol VisitorChartPresentationLogic {
    func presentChartPurposeData(response: VisitorChart.FetchVisitorPurposeType.Response)
}

class VisitorChartPresenter : VisitorChartPresentationLogic {
  
   
    var viewObj : VisitorChartDisplayLogic?

    func presentChartPurposeData(response: VisitorChart.FetchVisitorPurposeType.Response) {
        let viewModel = VisitorChart.FetchVisitorPurposeType.ViewModel(visitTypes: response.visitTypes, totalVisitCount: response.totalVisitCount)
        viewObj?.displayPercenatageDataOnChart(viewModel: viewModel)
      }
    
}
