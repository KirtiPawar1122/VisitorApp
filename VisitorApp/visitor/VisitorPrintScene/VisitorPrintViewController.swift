
import UIKit

protocol VisitorPrintDisplayLogic{
    func displayVisitorPrint(viewModel: VisitorPrint.VisitorPrintData.ViewModel)
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
        
        printInteractor?.fetchVisitorPrintData(request: VisitorPrint.VisitorPrintData.Request(email: selectedEmail))
    }
    
    func displayVisitorPrint(viewModel: VisitorPrint.VisitorPrintData.ViewModel) {
        print(viewModel.visitData as Any)
        VisitDate.text = viewModel.visitData?.date
        visitorName.text = viewModel.visitData?.visitors?.value(forKey: "name") as? String
        purposeLabel.text = viewModel.visitData?.purpose
        hostLabel.text = viewModel.visitData?.visitorName
        //let image = UIImage(data: selectedData.visitors?.value(forKey: "profileImage") as! Data)
        let image = UIImage(data: viewModel.visitData?.visitors?.value(forKey: "profileImage") as! Data)
        print(image!)
        profileImage.image = image!
    }
    
    @IBAction func onPrintAction(_ sender: Any) {
        //convert view to image and store it - alert display
        print(visitorCardView as Any)
        cardImage = visitorCardView.takeSanpShot()
        //cardImage?.saveToPhotoLibrary(self, nil)
        let pdfFilePath = visitorCardView.createPDFfromView()
        let pdfURL = NSURL(fileURLWithPath: pdfFilePath)
        print(pdfURL)
        print(pdfFilePath)
        let items = [pdfURL] as [Any]
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
