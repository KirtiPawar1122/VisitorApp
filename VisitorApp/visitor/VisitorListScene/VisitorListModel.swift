

import Foundation

enum VisitorList {
    
    enum fetchVisitorList{
        struct Request {
            
        }
        struct Response {
            var visit : [Visit]?
        }
        struct ViewModel {
            var visit : [Visit]?
        }
    }
    
    enum fetchVisitorPurposeType{
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
