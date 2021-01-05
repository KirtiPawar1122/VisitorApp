
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
        self.setValue(UIColor.systemGray, forKey: "placeholderColor")
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self.alpha = 0.7
        self.backgroundColor = UIColor.black
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 5
        self.textColor = UIColor.white
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
 }


