

import UIKit

class VisitorBarChartInteractor {
    
    var presenterObj : visitorBarChartPresenterProtocol?
    var data = [Visit]()

    func loadData(){
        presenterObj?.visitorData(data: data)
    }
}
