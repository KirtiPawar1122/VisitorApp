
import UIKit

protocol VisitorListPresentationLogic {
    func presentVisitorListResult(response: VisitorList.fetchVisitorList.Response)
    func presentAllVisitorsRecord(response: VisitorList.fetchVisitorRecordByName.Response)
    func presentVisitorsList(response: VisitorList.fetchAllVisitorsList.Response)
    
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
    func presentVisitorsList(response: VisitorList.fetchAllVisitorsList.Response) {
        print(response.visitorList)
        let viewModelData = response.visitorList
        let viewModel = VisitorList.fetchAllVisitorsList.ViewModel(visitorList: viewModelData)
        viewDataObject?.displayVisitorsReccord(viewModel: viewModel)
    }
    
}
