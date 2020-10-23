
import Foundation


enum VisitorChart {
    
    enum VisitorChartData{
        
        struct Request {
            
        }
        
        struct Response {
            var visitData : [Visit]
        }
        
        struct ViewModel {
            var visitData : [Visit]
        }
    }
}
