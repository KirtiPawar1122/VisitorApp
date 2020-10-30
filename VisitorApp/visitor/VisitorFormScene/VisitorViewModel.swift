

import Foundation


enum VisitorForm {
    
    enum fetchVisitorRecord{
        struct Request {
            var email : String?
        }
        
        struct Response {
            var visit : Visit?
        }
        
        struct ViewModel {
            var visit : Visit?
        }
    }
    
    enum saveVisitorRecord {
        struct Request {
            var name: String?
            var address: String?
            var email: String
            var phoneNo: Int64
            var visitPurpose: String?
            var visitingName: String?
            var companyName: String?
            var profileImage: Data
            var currentDate: String?
        }
        
        struct Response {
            
        }
        
        struct  ViewModel {
            
        }
    }
}
