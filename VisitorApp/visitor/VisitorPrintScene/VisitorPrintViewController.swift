
import UIKit

protocol VisitorPrintDisplayLogic{
    func displayVisitorPrint(viewModel: VisitorPrint.VisitorPrintData.ViewModel)
}

struct VisitorPrintViewControllerConstant{
    
      static let selectedImageName = "camera-1"
      static let navBarTitle = "Visitor Pass Preview"
      static let dateFormat = "MMM d,yyyy"
      static let xValue = -150
      static let yValue = 300
      static let width = 794
      static let height = 1123
    
}



class VisitorPrintViewController: UIViewController,VisitorPrintDisplayLogic {
   
    
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
    var printVisitData: Visit?
    var selectedImge = "no-image"
    var printInteractor: VisitorPrintBusinessLogic?
    //var printPresentor: VisitorPrintPresentationLogic?
    var printRouter: VisitorPrintRouter = VisitorPrintRouter()
    var cardImage: UIImage?
    var selectedEmail = String()
    var selectedPhoneNo = String()
    var currentDate = Date()
    //var printData: Visit!
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
        let interactor = VisitorPrintInteractor()
        let presenter = VisitorPrintPresenter()
        viewController.printInteractor = interactor
        interactor.printPresenter = presenter
        presenter.viewPrintLogic = viewController
        viewController.printRouter = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorCardView.layer.borderWidth = 1
        visitorCardView.layer.borderColor = #colorLiteral(red: 0.4407853214, green: 0.4373977654, blue: 0.4395006303, alpha: 1)
        visitorCardView.layer.cornerRadius = 10
        visitorCardView.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        printButton.layer.cornerRadius = printButton.frame.height/2
        printButton.layer.borderColor = UIColor.black.cgColor
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.title = VisitorPrintViewControllerConstant.navBarTitle
        
        printInteractor?.fetchVisitorPrintData(request: VisitorPrint.VisitorPrintData.Request(phoneNo: selectedPhoneNo))
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm a"
        //formatter.dateStyle = .medium
        let currentSelectedDate = printVisitData?.date
        let stringDate = formatter.string(from: currentSelectedDate!)
        let selectedDate = formatter.date(from: stringDate)
        let timedata = getDateDiff(start: selectedDate!, end: currentDate)
        print(stringDate)
        
        if timedata <= 8 {
            printButton.isHidden = false
        } else {
            printButton.isHidden = true
        }
    }
    
    func getDateDiff(start: Date, end: Date) -> Int  {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([Calendar.Component.second], from: start, to: end)
        let seconds = dateComponents.second
        return Int(seconds! / 3600)
    }
    
    
    func displayVisitorPrint(viewModel: VisitorPrint.VisitorPrintData.ViewModel) {
        print(viewModel.visitData as Any)
        let formatter = DateFormatter()
        //currentDate = viewModel.visitData!.date!
        formatter.dateFormat = VisitorPrintViewControllerConstant.dateFormat
        let displayDate = formatter.string(from: viewModel.visitData!.date!)
        VisitDate.text = displayDate
        visitorName.text = viewModel.visitData?.visitors?.value(forKey: "name") as? String
        purposeLabel.text = viewModel.visitData?.purpose
        hostLabel.text = viewModel.visitData?.visitorName
        //let image = UIImage(data: selectedData.visitors?.value(forKey: "profileImage") as! Data)
        let image = UIImage(data: viewModel.visitData?.visitors?.value(forKey: "profileImage") as! Data )
        //print(image!)
        profileImage.image = image!
    }
    
    @IBAction func onPrintAction(_ sender: Any) {
        //convert view to image and store it - alert display
        print(visitorCardView as Any)
        print("visitorCardView size - \(visitorCardView.frame)")
        //cardImage = visitorCardView.takeSnapShot()
        //cardImage = view.takeSnapShot()
        //cardImage?.saveToPhotoLibrary(self, nil)
        let pdfFilePath = visitorCardView.createPDFfromView()
        
        let pdfURL = NSURL(fileURLWithPath: pdfFilePath)
        
        //print(pdfURL)
        //print(pdfFilePath)
        let items = [ pdfURL as Any]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            ac.popoverPresentationController?.sourceView = printButton
        }
        present(ac, animated: true, completion: nil)
    }
   
}

extension UIView {
    func takeSnapShot() -> UIImage? {
       UIGraphicsBeginImageContext(CGSize(width: self.frame.width, height: self.frame.height ))
       let rect = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height)
       drawHierarchy(in: rect, afterScreenUpdates: true)
       let image = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       print(image as Any)
       return image
    }
    
    func createPDFfromView() -> String {
        // Fixed height and width to set alignment as center to print preview
        let pdfPageFrame = CGRect(x: VisitorPrintViewControllerConstant.xValue, y: VisitorPrintViewControllerConstant.yValue, width: VisitorPrintViewControllerConstant.width, height: VisitorPrintViewControllerConstant.height)
        let pdfData = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        //UIGraphicsBeginPDFPage()
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
