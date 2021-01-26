


import UIKit

class CustomImageView: UIImageView,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        override init(frame: CGRect) {
            super.init(frame: frame)
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            addRoundedCorner()
            //addShadow()
        }
    
    
     func addRoundedCorner(){
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = true
     }
    
    func addShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
    }
}























