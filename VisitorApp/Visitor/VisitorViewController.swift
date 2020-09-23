
import UIKit
import CoreData
import AVFoundation
import Toast_Swift

protocol ViewProtocol{
    func loadData(visitorData : [Visit])
}

class VisitorViewController: UIViewController,ViewProtocol,UITextFieldDelegate{
    @IBOutlet weak var submitLable: UIButton!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var visitorImage: CustomImageView!
    @IBOutlet weak var userTextField: CustomTextField!
    @IBOutlet weak var addressTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var phoneTextField: CustomTextField!
    @IBOutlet weak var companyTextField: CustomTextField!
    @IBOutlet weak var purposeTextFeild: CustomTextField!
    @IBOutlet weak var visitTextField: CustomTextField!
    @IBOutlet weak var loadDataButton: UIBarButtonItem!
    @IBOutlet weak var logoImage: UIImageView!
    
    var visitor : [Visitor] = []
    var visit : [Visit] = []
    var tapCount = 0
    var containerView = UIView()
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var selectedImage = UIImage(named: "no-image")
    var interactor : VisitorInteractor = VisitorInteractor()
    let imagePicker = UIImagePickerController()
    var campareData : String = ""
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    var name: String = ""
    var compareEmail: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userTextField.delegate = self
        addressTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        companyTextField.delegate = self
        purposeTextFeild.delegate = self
        visitTextField.delegate = self
    
        hideKeyboardTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector( VisitorViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(VisitorViewController
            .keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapOnImageView = UITapGestureRecognizer(target: self, action: #selector(imageAction))
        visitorImage.addGestureRecognizer(tapOnImageView)
        visitorImage.isUserInteractionEnabled = true
        
        let tapPurposeTextFeild = UITapGestureRecognizer(target: self, action: #selector(purposeAction))
        purposeTextFeild.addGestureRecognizer(tapPurposeTextFeild)
        purposeTextFeild.isUserInteractionEnabled = true
        
        submitLable.layer.cornerRadius = 5
        submitLable.layer.borderColor = UIColor.black.cgColor
        submitLable.layer.shadowColor = UIColor.black.cgColor
        submitLable.layer.shadowOffset = CGSize(width: 5, height: 5)
        submitLable.layer.shadowRadius = 5
        submitLable.layer.shadowOpacity = 1.0
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7621263266, green: 0.08146793395, blue: 0.1015944257, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        let personImage = UIImage(named: "person")
        addImageOntextField(textField: userTextField, img: personImage!)

        let addressImage = UIImage(named: "icon-1")
        addImageOntextField(textField: addressTextField, img: addressImage!)

        let phoneImage = UIImage(named: "phone")
        addImageOntextField(textField: phoneTextField, img: phoneImage!)

        let mailImage = UIImage(named: "email")
        addImageOntextField(textField: emailTextField, img: mailImage!)
        emailTextField.delegate = self as UITextFieldDelegate
        
        let companyImage = UIImage(named: "company")
        addImageOntextField(textField: companyTextField, img: companyImage!)

        let visitImage = UIImage(named: "persons")
        addImageOntextField(textField: visitTextField, img: visitImage!)

        let purposeImage = UIImage(named: "purpose")
        addImageOntextField(textField: purposeTextFeild, img: purposeImage!)
        
        fetchData()

    } //end of viewDidiLoad()

    func addImageOntextField(textField : CustomTextField,img : UIImage){
        let imageView = UIImageView()
        imageView.image = img
        imageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        textField.addSubview(imageView)
        let leftView = UIView.init(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
        textField.leftView = leftView;
        textField.leftViewMode = .always
        textField.returnKeyType = .next
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
         guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
         }
         let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
         scrollView.contentInset = contentInsets
         scrollView.scrollIndicatorInsets = contentInsets
     }

    @objc func keyboardWillHide(notification: NSNotification) {
         let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
         scrollView.contentInset = contentInsets
         scrollView.scrollIndicatorInsets = contentInsets
    }

    func hideKeyboardTappedAround(){
        let tap : UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dissmissKeyboard(){
        view.endEditing(true)
    }
    
    func loadData(visitorData: [Visit]) {
        visit = visitorData
        for item in visit{
            name = item.visitors?.value(forKey: "name") as? String ?? ""
        }
    }
    
    func fetchData(){
        interactor.fetchRecord()
    }
    
    func checkMail(checkmail: String){
        for item in visit {
            if (checkmail == item.visitors?.value(forKey: "email") as? String) {
                compareEmail = checkmail
                let alert = UIAlertController(title: nil, message: "Welcome to Wurth IT", preferredStyle: .alert)
                let alertAtion = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(alertAtion)
                present(alert, animated: true, completion: nil)            }
        }
    }
    
    @IBAction func submitButtonClick(_ sender: Any) {
        validate()
    }
    
    private func switchnextTextField(_ textField: UITextField){
        switch textField {
        case self.emailTextField:
            self.userTextField.becomeFirstResponder()
            
        case self.userTextField:
            self.addressTextField.becomeFirstResponder()
            
        case self.addressTextField:
            self.phoneTextField.becomeFirstResponder()
            
        case self.phoneTextField:
            self.companyTextField.becomeFirstResponder()
            
        case self.companyTextField:
            self.purposeTextFeild.becomeFirstResponder()
            
        case self.purposeTextFeild:
            self.visitTextField.becomeFirstResponder()
            
        case self.visitTextField:
            self.submitLable.becomeFirstResponder()
            
        default:
            self.submitLable.becomeFirstResponder()
        }
    }
    // textfeild character limits for PhoneNumber
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case phoneTextField:
            guard let text = phoneTextField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 10
        default:
            return true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       var nameString : String = ""
       switchnextTextField(textField)
       textField.resignFirstResponder()
      
       purposeTextFeild.addTarget(self, action: #selector(purposeAction), for: .editingDidBegin)
    
        let fetchRequest = NSFetchRequest<Visit>(entityName: "Visit")
              do {
                  let record = try context.fetch(fetchRequest)
                  for item in record {
                    if textField.text == "" {
                        switchnextTextField(textField)
                    } else if emailTextField.text != item.visitors?.value(forKey: "email") as? String {
                        switchnextTextField(textField)
                    } else if emailTextField.text == item.visitors?.value(forKey: "email") as? String {
                        
                          switchnextTextField(textField)
                          companyTextField.text = item.companyName!
                         // purposeTextFeild.text = item.purpose!
                          visitTextField.text = item.visitorName!
                          userTextField.text = item.visitors?.value(forKey: "name") as? String
                          emailTextField.text = item.visitors?.value(forKey: "email") as? String
                          addressTextField.text = item.visitors?.value(forKey: "address") as? String
                          phoneTextField.text = String(item.visitors?.value(forKey: "phoneNo") as! Int64)
                          visitorImage.image = UIImage(data: item.visitors?.value(forKey: "profileImage") as! Data)
                          purposeTextFeild.addTarget(self, action: #selector(purposeAction), for: .touchUpInside)
                          nameString = "Hello \(userTextField.text!), Welcome to Wurth-IT"
                          userTextField.resignFirstResponder()
                      }
                  }
                  myUtterance = AVSpeechUtterance(string: nameString)
                  myUtterance.rate = 0.4
                  synth.speak(myUtterance)
                  userTextField.resignFirstResponder()
              }catch{
                  print("error")
              }
        return true
    }

    /* Navigation bar hide button */
    @IBAction func savedData(_ sender: Any) {
        tapCount = tapCount + 1
        if tapCount == 5 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitorDataViewController") as! VisitorDataViewController
            vc.viewObj = visit
            navigationController?.pushViewController(vc, animated: true)
            tapCount = 0
        } else {
            print("error in load data")
        }
    }
        
    func validate(){
        guard let email = emailTextField.text, !email.isEmpty, email.isValidEmail(mail: email) else {
            self.view.makeToast("Please enter valid email ID", duration: 3, position: .center)
            return
        }
        guard let name = userTextField.text, !name.isEmpty else{
             self.view.makeToast("Please enter name", duration: 3, position: .center)
            return
        }
        guard let address = addressTextField.text, !address.isEmpty else{
             self.view.makeToast("Please enter address", duration: 3, position: .center)
            return
        }
        guard let phoneNo = phoneTextField.text, !phoneNo.isEmpty, phoneNo.isphoneValidate(phone: phoneNo) else{
             self.view.makeToast("Please enter valid phone number", duration: 3, position: .center)
            return
        }
        guard let companyName = companyTextField.text, !companyName.isEmpty else{
             self.view.makeToast("Please enter company Name", duration: 3, position: .center)
            return
        }
        guard let visitPurpose = purposeTextFeild.text, !visitPurpose.isEmpty else{
             self.view.makeToast("Please enter visit purpose", duration: 3, position: .center)
            return
        }
        guard let visitorName = visitTextField.text, !visitorName.isEmpty else{
            self.view.makeToast("Please enter visiting person name", duration: 3, position: .center)
            return
        }
        guard let profileImg = selectedImage!.pngData() else {
             self.view.makeToast("Please select Image", duration: 3, position: .center)
            return
        }
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MMM d, h:mm a"
        let dateString = formatter.string(from: now)
        checkMail(checkmail: email)
        
        if(compareEmail != email) {
            saveData(name: name, address: address, phoneNo: Int64(phoneNo) ?? 0, email: email, companyName: companyName, visitPurpose: visitPurpose, visitingName: visitorName, profileImage: profileImg, currentDate: dateString)
            showAlert(for: "Hello \(name), Welcome to Wurth-IT")
            
        } else {
            saveData(name: name, address: address, phoneNo: Int64(phoneNo) ?? 0, email: email, companyName: companyName, visitPurpose: visitPurpose, visitingName: visitorName, profileImage: profileImg, currentDate: dateString)
        }
        resetTextFields()
    }
    
    func saveData(name: String, address: String, phoneNo: Int64, email: String, companyName: String, visitPurpose: String, visitingName: String, profileImage: Data,currentDate: String)
     {
        interactor.save(name: name, address: address, phoneNo: phoneNo, email: email, companyName: companyName, visitPurpose: visitPurpose, visitingName: visitingName, profileImage: profileImage, currentDate: currentDate)
     }

    func resetTextFields() {
        userTextField.text = ""
        addressTextField.text = ""
        emailTextField.text = ""
        phoneTextField.text = ""
        companyTextField.text = ""
        visitTextField.text = ""
        purposeTextFeild.text = ""
        visitorImage.image = UIImage(named: "no-image.png")
        selectedImage = UIImage(named: "no-image.png")
    }
    
    @IBAction func refreshPage(_ sender: UIBarButtonItem) {
        resetTextFields()
    }
    
    func showAlert(for alert : String) {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
        myUtterance = AVSpeechUtterance(string: alertController.message!)
        myUtterance.rate = 0.4
        synth.speak(myUtterance)
    }
}

extension String {
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    func isValidEmail(mail : String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z.%+-]+@[A-Za-z.-]+\\.[A-Za-z]{2,3}"
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

extension VisitorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imageAction() {
          print("click on imageview")
          let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
          alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
               self.openCamera()
          }))
          alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
               self.openGallary()
          }))
          alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

          switch UIDevice.current.userInterfaceIdiom {
              case .pad:
                  alert.popoverPresentationController?.sourceView = self.view
                  alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                  alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
              default:
                      break
          }
          self.present(alert, animated: true, completion: nil)
      }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        selectedImage = image
        visitorImage.image = selectedImage
        self.dismiss(animated: true, completion: nil)
        
    }

    @objc func purposeAction(){
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let FirstAction = UIAlertAction(title: "Guest Visit", style: .default){ (_) in
            self.purposeTextFeild.text = "Guest Visit"
            return
        }
        let SecondAction = UIAlertAction(title: "Interview", style: .default){ (_) in
            self.purposeTextFeild.text = "Interview"
        }
        let ThirdAction = UIAlertAction(title: "Meeting", style: .default){ (_) in
            self.purposeTextFeild.text = "Meeting"
        }
        let FourthAction = UIAlertAction(title: "Others", style: .default){ (_) in
            self.purposeTextFeild.text = "Others"
        }
        
        optionMenu.addAction(FirstAction)
        optionMenu.addAction(SecondAction)
        optionMenu.addAction(ThirdAction)
        optionMenu.addAction(FourthAction)

        switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                optionMenu.popoverPresentationController?.sourceView = self.view
                optionMenu.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                optionMenu.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
            default:
                    break
        }
        self.present(optionMenu, animated: true,completion: nil)
    }
}

