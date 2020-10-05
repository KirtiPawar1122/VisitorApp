

import UIKit


protocol  visitorBarChartPresenterProtocol {
    func visitorData(data : [Visit])
}

class VisitorBarChartPresenter : visitorBarChartPresenterProtocol {
    
    var viewObject : visitorViewBarChartProtocol?
    func visitorData(data: [Visit]) {
        print(data)
        viewObject?.laodbarChartData(loadDataObj: data)
    }
}
