
import UIKit
import CoreData

protocol VisitorListDisplayLogic{
    func displayVisitorList(viewModel: VisitorList.fetchVisitorList.ViewModel)
}

struct VisitorDataViewControllerConstants{
    static let navRightBarTitle = "View Graph"
    static let deleteAlertMessage = "Are you sure you would like to delete entry"
    static let confirmActionMessage = "Confirm"
    static let cancelActionMessage = "Cancel"
    static let addressString = "address"
    static let nameString = "name"
    static let phoneString = "phoneNo"
    static let profileImage = "profileImage"
    static let emailString = "email"
    static let defaultImage = "person-1"
    static let visitorCell = "VisitorTableViewCell"
    static let timeLimit = 8
    static let fontFamily = "Roboto-Regular"
    static let dateFormatterForSaveDate = "dd/MM/yyyy   hh:mm:ss a"
    static let dateFormatterForDisplayDate = "dd/MM/yyyy   hh:mm a"
    static let searchPlaceholder = "Search here"
    static let defaultFontSize : CGFloat = 17
}

class VisitorListViewController: UIViewController, VisitorListDisplayLogic {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var filterbutton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var viewObj = [Visit]()
    var visitTypeObject = [VisitData]()
    var listInteractor : VisitorListBusinessLogic?
    var visitorDataRouter : visitorListRoutingLogic?
    var searchedData = [Visit]()
    var currentDate = Date()
    var images = [UIImage]()
    let imageCache = NSCache<AnyObject, AnyObject>()
    var uniqueKey = String()
    var visitorCoreData : VisitorCoreDataStore = VisitorCoreDataStore()
    
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    //MARK: - Setup
    private func setup() {
        let viewController = self
        let interactor = VisitorListInteractor()
        let presenter = VisitorListPresenter()
        let router = VisitorListRouter()
        viewController.listInteractor = interactor
        viewController.visitorDataRouter = router
        interactor.listPresenterProtocol = presenter
        presenter.viewDataObject = viewController
        router.viewController = viewController
        // searchedData = viewObj
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setUpUI()
        fetchVisitorList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        imageCache.removeAllObjects()
    }
    
    func setUpUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: VisitorDataViewControllerConstants.navRightBarTitle, style: .plain, target: self, action: #selector(viewGraph))
        tableview.keyboardDismissMode = .onDrag
        hideKeyboardTappedAround()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.tableview.backgroundColor = .clear
        self.searchBar.barTintColor = #colorLiteral(red: 0.9519745291, green: 0.953713613, blue: 0.9518942637, alpha: 1)
        searchBar.barStyle = .default
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.layer.cornerRadius = 5
        searchBar.searchTextField.layer.borderColor = UIColor.clear.cgColor
        searchBar.searchTextField.layer.borderWidth = 2
        searchBar.searchTextField.font = UIFont(name: VisitorDataViewControllerConstants.fontFamily, size: VisitorDataViewControllerConstants.defaultFontSize)
        searchBar.searchTextField.textColor = UIColor.black
        searchBar.searchTextField.placeholder = VisitorDataViewControllerConstants.searchPlaceholder
        self.tableview.tableFooterView = UIView()
        tableview.separatorStyle = .none
        
    }
    
    
    func hideKeyboardTappedAround(){
        let tap : UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dissmissKeyboard(){
        view.endEditing(true)
    }
    
    //MARK: - Fetch Request
    func fetchVisitorList(){
        activityIndicator.startAnimating()
        DispatchQueue.global().async { [unowned self] in
            let request = VisitorList.fetchVisitorList.Request()
            self.listInteractor?.fetchVisitorData(request: request)
        }
    }
    
    //MARK: - Fetch Response
    func displayVisitorList(viewModel: VisitorList.fetchVisitorList.ViewModel){
        print(viewModel)
        viewObj = viewModel.visit!
        searchedData = viewObj
        DispatchQueue.main.async { [unowned self] in
            self.tableview.reloadData()
            self.activityIndicator.stopAnimating()
        }
        loadImageIntoCache()
    }
    
    //MARK: - Delete Record from table
    
    func deleteConfirm(indexpath: IndexPath){
        let alert = UIAlertController(title: nil, message: VisitorDataViewControllerConstants.deleteAlertMessage, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: VisitorDataViewControllerConstants.confirmActionMessage, style: .default) {(_) in
            let visitorInfo = self.searchedData[indexpath.row]
            self.context.delete(visitorInfo)
            self.searchedData.remove(at: indexpath.row)
            //self.imageCache.removeObject(forKey: self.uniqueKey as AnyObject)
            self.appDelegate.saveContext()
            self.tableview.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: VisitorDataViewControllerConstants.cancelActionMessage, style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert,animated: true,completion: nil)
    }
    
    @objc func viewGraph(){
        let data = viewObj
        visitorDataRouter?.routeToChart(data: data)
    }
    
    @IBAction func onFilterButton(_ sender: Any) {
        
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopOverViewController") as! PopOverViewController
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = sender as? UIButton // button
        popController.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    func onClickByName(){
        print("click by Name")
    }
    
    func onClickByPurpose(){
        print("click by Purpose")
    }
    
    //MARK: - Date Difference For dipslay VisitorCard
    
    func getDateDifference(start: Date, end: Date) -> Int  {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([Calendar.Component.second], from: start, to: end)
        
        let seconds = dateComponents.second
        return Int(seconds! / 3600)
    }
    
    func loadImageIntoCache(){
        var counter = 0
        for item in searchedData{
            let email = item.visitors?.value(forKey: VisitorDataViewControllerConstants.emailString) as? String
            let formatter = DateFormatter()
            formatter.dateFormat = VisitorDataViewControllerConstants.dateFormatterForSaveDate
            let compareDate = item.date
            print(item.visitImage as Any)
            DispatchQueue.global().async { [unowned self] in
                
                let uniqueKey = email! + "\(String(describing: compareDate))"
                
                if let imageData = item.visitImage,let imageToCache = UIImage(data: imageData){
                    print(imageToCache)
                    self.imageCache.setObject(imageToCache, forKey: uniqueKey as AnyObject)
                    counter += 1
                    if counter == (self.searchedData.count) - 1{
                        DispatchQueue.main.async {
                            self.tableview.reloadData()
                        }
                    }
                    
                }
            }
        }
    }
}
//MARK: - Tableview DataSource methods

extension VisitorListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return viewObj.count
        return searchedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: VisitorDataViewControllerConstants.visitorCell, for: indexPath) as! VisitorTableViewCell
        
        let visit = searchedData[indexPath.row]
        cell.setUpCellData(visitData: visit)
        let email = visit.visitors?.value(forKey: VisitorDataViewControllerConstants.emailString) as! String
        let formatter = DateFormatter()
        formatter.dateFormat = VisitorDataViewControllerConstants.dateFormatterForSaveDate
        let compareDate = visit.date
        uniqueKey = email + "\(String(describing: compareDate))"
        //let uniqueKey = email + "\(String(describing: compareDate))" + "\(indexPath.row)"
        /* if let imageFromCache = imageCache.object(forKey: uniqueKey as AnyObject) as? UIImage {
         cell.profileImage.image = imageFromCache
         } else {
         DispatchQueue.global().async {
         if let data =  data.visitImage, let imageToCache = UIImage(data: data) {
         self.imageCache.setObject(imageToCache, forKey: self.uniqueKey as AnyObject)
         DispatchQueue.main.async {
         cell.profileImage.image = imageToCache
         }
         } else {
         DispatchQueue.main.async {
         cell.profileImage.image = UIImage(named: VisitorDataViewControllerConstants.defaultImage)
         }
         }
         }
         } */
        
        if let imageFromCache = imageCache.object(forKey: uniqueKey as AnyObject) as? UIImage{
            cell.profileImage.image = imageFromCache
        } else {
            cell.profileImage.image = UIImage(named: VisitorDataViewControllerConstants.defaultImage)
        }
        
        return cell
    }
}
//MARK: - Tableview Delegate Methods

extension VisitorListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            deleteConfirm(indexpath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let data = viewObj
        let item = searchedData[indexPath.row]
        var dataArray = [Visit]()
        let selectedEmail = item.visitors?.value(forKey: VisitorDataViewControllerConstants.emailString) as! String
        for visit in data {
            let email = visit.visitors?.value(forKey: VisitorDataViewControllerConstants.emailString) as? String
            if email == selectedEmail {
                dataArray.append(visit)
            }
        }
        tableview.deselectRow(at: indexPath, animated: true)
        visitorDataRouter?.routeToBarChart(fetcheddata: dataArray, selectedData: item)
    }
}

//MARK: - SearchBar Delegate Methods

extension VisitorListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        searchedData = searchText.isEmpty ? viewObj : viewObj.filter{
            (item : Visit) -> Bool in
            let name = item.visitors?.value(forKey: VisitorDataViewControllerConstants.nameString) as? String
            return name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchedData = viewObj
        searchBar.endEditing(true)
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//MARK: - Popover delegate Method

extension VisitorListViewController: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension UIImageView {
    
    func loadImage(data: Data) {
        DispatchQueue.global().async { [unowned self] in
            let image = UIImage(data: data)
            DispatchQueue.main.async { [unowned self] in
                self.image = image
                self.contentMode = .scaleAspectFill
            }
        }
    }
}

