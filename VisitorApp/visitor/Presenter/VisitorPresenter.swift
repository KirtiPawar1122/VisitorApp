

import UIKit

protocol VisitorFormPrsentationLogic {
    func presentFetchResults(response: VisitorForm.fetchVisitorRecord.Response.VisitResponse)
    func presentEmailData(response: VisitorForm.fetchVisitorRecord.Response.VisitorResponse)
    
}

class VisitorPresenter : VisitorFormPrsentationLogic {
    
    var viewObj : VisitorFormDisplayLogic?
    
    func presentFetchResults(response: VisitorForm.fetchVisitorRecord.Response.VisitResponse) {
         print(response)
        
        let viewModelList = response.visit
        let viewmodel = VisitorForm.fetchVisitorRecord.ViewModel.VisitViewModel(visit: viewModelList)
        viewObj?.displayVisitorData(viewModel: viewmodel)
    }
    
    func presentEmailData(response: VisitorForm.fetchVisitorRecord.Response.VisitorResponse) {
        print(response)
        
        let viewModelData = response.visitor
        let viewmodel = VisitorForm.fetchVisitorRecord.ViewModel.VisitorViewModel(visitor: viewModelData)
        viewObj?.displayEmailData(viewModel: viewmodel)
    }
    
    
}
