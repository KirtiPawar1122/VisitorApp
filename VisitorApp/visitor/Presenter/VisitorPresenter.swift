

import UIKit

protocol VisitorFormPrsentationLogic {
    func presentFetchResults(response: VisitorForm.fetchVisitorRecord.Response)
    func presentFethcedResults(response: VisitorForm.fetchVisitorsRecord.Response)
    }

class VisitorPresenter : VisitorFormPrsentationLogic {
    
    var viewObj : VisitorFormDisplayLogic?
    
    func presentFetchResults(response: VisitorForm.fetchVisitorRecord.Response) {
        //print(response)
        let viewModelList = response.visit
        let viewmodel = VisitorForm.fetchVisitorRecord.ViewModel(visit: viewModelList)
        viewObj?.displayVisitorData(viewModel: viewmodel)
    }
    
    func presentFethcedResults(response: VisitorForm.fetchVisitorsRecord.Response){
        print(response)
        let viewModelList = response.visitorData
        let viewModel = VisitorForm.fetchVisitorsRecord.ViewModel(visitorData: viewModelList)
        viewObj?.displayVisitorsData(viewModel: viewModel)
    }
}
