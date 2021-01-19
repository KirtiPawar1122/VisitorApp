


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
    
        override func layoutSubviews() {
           /* self.layer.borderWidth = 1
            self.layer.masksToBounds = false
            self.layer.borderColor = UIColor.gray.cgColor
            self.layer.cornerRadius = self.frame.size.width/2
            self.clipsToBounds = true*/
            /*self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 5, height: 5)
            self.layer.shadowRadius = 5
            self.layer.shadowOpacity = 1
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,cornerRadius: self.layer.cornerRadius).cgPath */
            //self.clipsToBounds = false
           
            /*self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.frame.height/2).cgPath
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 1
            self.layer.shadowOffset = CGSize(width: 5, height: 5)
            self.layer.masksToBounds = false*/
            
            
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























