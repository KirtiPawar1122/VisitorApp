


import UIKit

class CustomImageView: UIImageView,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        override init(frame: CGRect) {
            super.init(frame: frame)
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    
        override func layoutSubviews() {
            self.layer.borderWidth = 1
            self.layer.masksToBounds = false
            self.layer.borderColor = UIColor.gray.cgColor
            self.layer.cornerRadius = self.frame.size.width/2
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize.zero
            self.layer.shadowRadius = 1
            self.layer.shadowOpacity = 0.5
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            self.clipsToBounds = true
            
        }
}
























//super.layoutSubviews()
