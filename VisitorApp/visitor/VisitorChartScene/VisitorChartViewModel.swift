
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
    
    enum FetchVisitorPurposeType{
           struct Request {
              
           }
           struct Response {
               var visitTypes: [VisitData]
               var totalVisitCount: Int
           }
           struct ViewModel {
               var visitTypes: [VisitData]
               var totalVisitCount: Int
           }
       }
}
