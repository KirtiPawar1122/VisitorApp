

import Foundation

extension String {
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    func isValidEmail(mail : String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z.%+-]+@[A-Za-z-]+\\.[A-Za-z]{2,3}"
        let emailtest = NSPredicate(format: "SELF Matches %@", emailRegEx)
        let result =  emailtest.evaluate(with: self)
        return result
    }
    func isphoneValidate(phone: String) -> Bool {
        let phoneRegEx = "[0-9]{10}"
        let phonetest = NSPredicate(format: "SELF Matches %@", phoneRegEx)
        let result = phonetest.evaluate(with: self)
        return result
    }
    
}
