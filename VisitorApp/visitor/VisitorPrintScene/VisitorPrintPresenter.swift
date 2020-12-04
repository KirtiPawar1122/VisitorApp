
import Foundation

protocol VisitorPrintPresentationLogic{
    func presentPrintfetchResult(response: VisitorPrint.VisitorPrintData.Response)
}

class VisitorPrintPresenter: VisitorPrintPresentationLogic{
    
    
    var viewPrintLogic: VisitorPrintDisplayLogic?
    
    func presentPrintfetchResult(response: VisitorPrint.VisitorPrintData.Response) {
        print(response)
        let printViewModel = VisitorPrint.VisitorPrintData.ViewModel(visitData: response.visitData)
        viewPrintLogic?.displayVisitorPrint(viewModel: printViewModel)
    }
}
