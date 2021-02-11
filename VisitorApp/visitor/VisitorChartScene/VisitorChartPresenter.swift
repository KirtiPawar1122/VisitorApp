

import UIKit

protocol VisitorChartPresentationLogic {
    func prsentChartData(response: VisitorChart.VisitorChartData.Response)
    func presentChartPurposeData(response: VisitorChart.FetchVisitorPurposeType.Response)
}

class VisitorChartPresenter : VisitorChartPresentationLogic {
  
   
    var viewObj : VisitorChartDisplayLogic?
    func prsentChartData(response: VisitorChart.VisitorChartData.Response) {
        //print(response)
        
        let viewModelData = response.visitData
        let viewModel = VisitorChart.VisitorChartData.ViewModel(visitData: viewModelData)
        viewObj?.displayChart(viewModel: viewModel)
    }
    func presentChartPurposeData(response: VisitorChart.FetchVisitorPurposeType.Response) {
        //print(response)
        
        let viewModel = VisitorChart.FetchVisitorPurposeType.ViewModel(visitTypes: response.visitTypes, totalVisitCount: response.totalVisitCount)
        viewObj?.displayPercenatageDataOnChart(viewModel: viewModel)
      }
    
}
