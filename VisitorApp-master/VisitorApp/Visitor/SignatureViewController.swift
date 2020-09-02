

import UIKit

class SignatureViewController: UIViewController, CustomSignDelegate {

    @IBOutlet weak var signatureView: CustomView!
    var sign = UIImage()
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        saveBtn.layer.cornerRadius = 15
        clearBtn.layer.cornerRadius = 15
    }
    
    func setupViews(){
        signatureView.layer.borderWidth = 0.5
        signatureView.layer.borderColor = UIColor.gray.cgColor
        signatureView.layer.cornerRadius = 10
    }
    
    @IBAction func onSave(_ sender: Any) {
       
        sign = signatureView.getSignature()
        dismiss(animated: true, completion: nil)
        signatureView.clear()
        
    }
    @IBAction func onClear(_ sender: Any) {
        self.signatureView.clear()
    }
    func didStart(_ view: CustomView) {
        print("did start Method")
    }
    
    func didEnd(_ view: CustomView) {
        print("did end method")
    }

}


