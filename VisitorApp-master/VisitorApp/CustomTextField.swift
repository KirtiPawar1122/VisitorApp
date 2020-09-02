
import UIKit

class CustomTextField: UITextField, UITextFieldDelegate {
    
    var floatingLabel : UILabel!
    var floatingHeight : CGFloat = 10
    var imageView = UIImageView(frame: CGRect.zero)
    var floatingLabelFont: UIFont = UIFont.systemFont(ofSize: 14)
    var _placeholder: String?
    var view : UIView!
    
    override init(frame: CGRect){
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.delegate = self
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.delegate = self
        self._placeholder = (self._placeholder != nil) ? self._placeholder : placeholder
        placeholder = self._placeholder // Make sure the placeholder is shown
        self.floatingLabel = UILabel(frame: CGRect.zero)
    }
    
   
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.returnKeyType = .next
        return true
    }
    
    
    @objc func addFloatingLabel(){
        if self.text == "" {
            self.floatingLabel.textColor = UIColor.black
            self.floatingLabel.text = self._placeholder
            self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
            self.floatingLabel.clipsToBounds = true
            self.floatingLabel.frame = CGRect(x: 0, y: 0, width: floatingLabel.frame.width, height: floatingLabel.frame.height)
            self.floatingLabel.textAlignment = .center
            self.addSubview(self.floatingLabel)
            self.floatingLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -5).isActive = true // set label 5pts above
            self.placeholder = ""
        }
        self.bringSubviewToFront(subviews.last!)
        self.setNeedsDisplay()
    
    }

    @objc func removeFloatingLabel() {
        //remove flaoting label
        if self.text == "" {
            UIView.animate(withDuration: 0.13) {
                for subview in self.subviews{
                    subview.removeFromSuperview()
                }
                self.setNeedsLayout()
            }
            self.placeholder = self._placeholder
        }
        self.layer.backgroundColor  = UIColor.white.cgColor
        self.borderStyle = .roundedRect
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
//    func addImageOntextField(textfield : UITextField,img : UIImage){
//        let leftImage = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
//        leftImage.image = img
//        textfield.leftView = leftImage
//        textfield.leftViewMode = .always
//    }
    
 }






//    func createTextFeild(){
//        let borderWidth = CGFloat(1.0)
//        self.layer.borderColor = UIColor.white.cgColor
//        self.layer.frame = CGRect(x: 130, y: 450 , width: 550, height: self.frame.size.height )
//        self.layer.borderWidth = borderWidth
//        self.backgroundColor = UIColor.lightGray
//        self.layer.masksToBounds = true
//    }
    
//    func newTextFeild(){
//        let textField = UITextField(frame: CGRect(x: 0, y: 20, width: 100, height: 20))
//        let border = CALayer()
//        let width = CGFloat(2.0)
//        border.borderColor = UIColor.darkGray.cgColor
//        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
//        border.borderWidth = width
//        textField.borderStyle = .none
//        textField.layer.addSublayer(border)
//        textField.layer.masksToBounds = true
//    }
    
//func textFeildVendorName() {
//     print("in textFeildVendorName")
//// let placeholderString = NSAttributedString(string: "vendor Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
// //    self.attributedPlaceholder = placeholderString
//   //  self.text = _placeholder
//   //  self.placeholder = _placeholder
//     let imageVendorname = UIImage(named: "icon")
//     imageView.image = imageVendorname
//     imageView.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
//     let paddingView: UIView = UIView.init(frame:
//         CGRect(x: 0, y: 0, width: 30, height: 30))
//     paddingView.addSubview(imageView)
//     self.leftViewMode = .always
//     self.leftView = paddingView
// }


