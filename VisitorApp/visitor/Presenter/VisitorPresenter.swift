

import UIKit

protocol VisitorFormPrsentationLogic {
    func presentFetchResults(response: VisitorForm.fetchVisitorRecord.Response)
}

class VisitorPresenter : VisitorFormPrsentationLogic {
    
    var viewObj : VisitorFormDisplayLogic?
    
    func presentFetchResults(response: VisitorForm.fetchVisitorRecord.Response) {
        print(response)
        let viewModelList = response.visit
        let viewmodel = VisitorForm.fetchVisitorRecord.ViewModel(visit: viewModelList)
        viewObj?.displayVisitorData(viewModel: viewmodel)
        
    }
    
}
