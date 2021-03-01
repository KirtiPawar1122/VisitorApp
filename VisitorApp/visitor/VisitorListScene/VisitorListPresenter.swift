
import UIKit

protocol VisitorListPresentationLogic {
    func presentVisitorListResult(response: VisitorList.fetchVisitorList.Response)
    func presentAllVisitorsRecord(response: VisitorList.fetchVisitorRecordByName.Response)
    
}

class VisitorListPresenter: VisitorListPresentationLogic  {
   
    
  
    var viewDataObject : VisitorListDisplayLogic?
    
    func presentVisitorListResult(response: VisitorList.fetchVisitorList.Response) {
        //print(response)
        let viewModelList = response.visit
        let viewModel = VisitorList.fetchVisitorList.ViewModel(visit: viewModelList)
        viewDataObject?.displayVisitorList(viewModel: viewModel)
    }
    func presentAllVisitorsRecord(response: VisitorList.fetchVisitorRecordByName.Response) {
        let viewModelData = response.visit
        let viewModel = VisitorList.fetchVisitorRecordByName.ViewModel(visit: viewModelData)
        viewDataObject?.displayAllVisitors(viewModel: viewModel)
        
    }
}
