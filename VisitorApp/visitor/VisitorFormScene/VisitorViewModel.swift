

import Foundation


enum VisitorForm {
    
    enum fetchVisitorRecord{
        struct Request {
            //var email: String?
            var phoneNo: String?
        }
        
        struct Response {
            var visit: Visit?
        }
        
        struct ViewModel {
            var visit: Visit?
        }
    }
    
    enum saveVisitorRecord {
        struct Request {
            var name: String?
            var email: String
            var phoneNo: String?
            var visitPurpose: String?
            var visitingName: String?
            var companyName: String?
            var profileImage: Data
            var currentDate: Date?
        }
        
        struct Response {
            
        }
        
        struct  ViewModel {
            
        }
    }
}
