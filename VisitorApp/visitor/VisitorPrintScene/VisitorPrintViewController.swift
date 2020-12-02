
import UIKit

class VisitorPrintViewController: UIViewController {
    @IBOutlet var visitorCardView: UIView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var printButton: UIButton!
    @IBOutlet var VisitDate: UILabel!
    @IBOutlet var visitorName: UILabel!
    @IBOutlet var companyName: UILabel!
    @IBOutlet var companyLogo: UIImageView!
    @IBOutlet var purposeLabel: UILabel!
    @IBOutlet var hostLabel: UILabel!
    
    var printData = Visit()
    var selectedImge = "no-image"
    var printInteractor: VisitorPrintBusinessLogic?
    var printRouter: VisitorPrintRouter = VisitorPrintRouter()
    var cardImage: UIImage?
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setup()
    }
    
    //MARK: Setup
    private func setup() {
        
        let viewController = self
        let router = VisitorPrintRouter()
        
        viewController.printRouter = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(printData)
        
        VisitDate.text = printData.date
       /* let dateString = printData.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "DD-MMM-YYYY"
        let dateformat = dateFormatter.date(from: dateString!)
        print(dateformat as! Date) */
        
        visitorName.text = printData.visitors?.value(forKey: "name") as? String
        purposeLabel.text = printData.purpose
        hostLabel.text = printData.visitorName
        print(printData.visitors?.value(forKey: "profileImage") as! Data)
        let image = UIImage(data: printData.visitors?.value(forKey: "profileImage") as! Data)
        print(image!)
        profileImage.image = image  
        
        //companyName.text = "Wurth IT India Pvt. Ltd."
        visitorCardView.layer.borderWidth = 3
        visitorCardView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        visitorCardView.layer.cornerRadius = 10
        visitorCardView.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profileImage.layer.cornerRadius = 10
                
        printButton.layer.cornerRadius = 5
        printButton.layer.borderColor = UIColor.black.cgColor
        printButton.layer.shadowColor = UIColor.black.cgColor
        printButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        printButton.layer.shadowRadius = 5
        printButton.layer.shadowOpacity = 1.0
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backImage")!)
        
    }
    
    @IBAction func onPrintAction(_ sender: Any) {
        //convert view to image and store it - alert display
        print(visitorCardView as Any)
        cardImage = visitorCardView.takeSanpShot()
        //let msg: String = "Visitor Card"
        cardImage?.saveToPhotoLibrary(self, nil)
        let pdfFilePath = visitorCardView.createPDFfromView()
        print(pdfFilePath)
       /* let alert = UIAlertController(title: "Saved..!", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert,animated: true,completion: nil)*/
        
       /* let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = UIPrintInfo.OutputType.general
        printInfo.jobName = "My Print Job"
        
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        
        printController.printingItem = cardImage
        
        // if you want to specify
       // guard let printURL = URL(string: "ipps://HPDC4A3E0DE24A.local.:443/ipp/print") else { return }
       // guard let currentPrinter = UIPrinter(url: printURL) else { return }
      //  guard let currentPrinter = UIPrinter(url: printURL) else { return }
       // printController.print(to: currentPrinter, completionHandler: nil)
        
        printController.present(from: self.view.frame, in: self.view, animated: true, completionHandler: nil) */
        
        let items = [cardImage!,pdfFilePath] as [Any]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            ac.popoverPresentationController?.sourceView = printButton
        }
        present(ac, animated: true, completion: nil)
    }
}

extension UIView {
    
    func takeSanpShot() -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: self.frame.size.width, height: self.frame.size.height ))
       let rect = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
       drawHierarchy(in: rect, afterScreenUpdates: true)
       let image = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       print(image as Any)
       return image
    }
    
    
    func createPDFfromView() -> String {
        
        let pdfPageFrame = self.bounds
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        return self.saveViewPdf(data: pdfData)
        
    }
    
    func saveViewPdf(data: NSMutableData) -> String {
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      let docDirectoryPath = paths[0]
      let pdfPath = docDirectoryPath.appendingPathComponent("viewPdf.pdf")
      if data.write(to: pdfPath, atomically: true) {
          return pdfPath.path
      } else {
          return ""
      }
    }
}

extension UIImage{
     func saveToPhotoLibrary(_ completionTarget: Any?, _ completionSelector: Selector?) {
           DispatchQueue.global(qos: .userInitiated).async {
               UIImageWriteToSavedPhotosAlbum(self, completionTarget, completionSelector, nil)
           }
       }
    
}
