

import Foundation


enum VisitorForm {
    
    enum fetchVisitorRecord{
        struct Request {
            var name : String?
            var email : String?
            var address : String?
            var phoneNo : Int64
            var companyName : String?
            var visitPurpose : String?
            var visitingName : String?
            var profileImage : Data
            var currentDate : String?
        }
        
        struct Response {
            struct VisitResponse {
                var visit : [Visit]
            }
            
            struct VisitorResponse {
                var visitor : [Visitor]
            }
        }
        
        struct ViewModel {
            struct VisitViewModel {
                var visit : [Visit]
            }
            
            struct VisitorViewModel {
                var visitor : [Visitor]
            }
        }
    }
}
