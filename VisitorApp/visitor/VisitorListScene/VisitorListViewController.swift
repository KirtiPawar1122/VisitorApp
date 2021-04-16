
import UIKit
import CoreData
import FirebaseDatabase
import FirebaseStorage
import Firebase
import AlamofireImage
import Alamofire

protocol VisitorListDisplayLogic{
    func displayVisitorList(viewModel: VisitorList.fetchVisitorList.ViewModel)
    func displayAllVisitors(viewModel: VisitorList.fetchVisitorRecordByName.ViewModel)
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
    var filterSerchedData = [Visit]()
    var searchData = [Visit]()
    var currentDate = Date()
    var images = [UIImage]()
    var uniqueKey = String()
    var visitorCoreData : VisitorCoreDataStore = VisitorCoreDataStore()
    var isLoading = false
    var offset = 0
    var ref = DatabaseReference.init()
    let db = Firestore.firestore()
    var visitorAllData = [DisplayData]()
    var sortedData = [DisplayData]()

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
        self.ref = Database.database().reference()
        fetchVisitorData()
        setUpUI()
        //fetchLimitedData(fetchoffset: offset)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: VisitorDataViewControllerConstants.navRightBarTitle, style: .plain, target: self, action: #selector(viewGraph))
        tableview.keyboardDismissMode = .onDrag
        hideKeyboardTappedAround()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.tableview.backgroundColor = .clear
        self.searchBar.barTintColor = #colorLiteral(red: 0.9519745291, green: 0.953713613, blue: 0.9518942637, alpha: 1)
        searchBar.delegate = self
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
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            let request = VisitorList.fetchVisitorList.Request()
            self.listInteractor?.fetchVisitorData(request: request)
        }
    }
    
    func fetchLimitedData(fetchoffset: Int){
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            let request = VisitorList.fetchVisitorList.Request()
            self.listInteractor?.fetchVisitorDataWithLimit(fetchOffset: fetchoffset, request: request)
        }
    }
    
    func fetchVisitorData(){
        activityIndicator.startAnimating()
        let ref = db.collection("Visitor")
        ref.getDocuments { (snapshots, error) in
               guard let snap = snapshots?.documents else {return}
               for document in snap{
                   let data = document.data()
                   let visitdata = data["visits"] as! [[String:Any]]
                   for item in visitdata{
                       let name = data["name"] as? String
                       let email = data["email"] as? String
                       let phoneNo = data["phoneNo"] as? String
                       let profileImage = data["profileImage"] as? String
                       let currentdate = item["date"] as! Timestamp
                       let date = currentdate.dateValue()
                       let purpose = item["purpose"] as? String
                       let company = item["company"] as? String
                       let contactPerson = item["contactPersonName"] as? String
                       //let profileVisitImg = data["profileVisitImage"] as? Data
                    let dataArray = DisplayData(name: name!, email: email!, phoneNo: phoneNo!, purspose: purpose!, date: date , companyName: company!, profileImage: profileImage ?? "", contactPerson: contactPerson!)
                    self.visitorAllData.append(dataArray)
                   }
               }
            self.sortedData = self.visitorAllData.sorted(by: { $0.date > $1.date })
            DispatchQueue.main.async {
                self.tableview.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    
    //MARK: - Fetch Response
    func displayVisitorList(viewModel: VisitorList.fetchVisitorList.ViewModel){
        viewObj = viewModel.visit!
        if viewObj.count != 10 || searchedData.count != 0  {
            for item in viewObj{
                searchedData.append(item)
            }
        } else {
            searchedData = viewObj
        }
        filterSerchedData = searchedData
        loadImageIntoCache()
        DispatchQueue.main.async {
            self.tableview.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func displayAllVisitors(viewModel: VisitorList.fetchVisitorRecordByName.ViewModel) {
        searchData = viewModel.visit!
        //print("SearchData:", searchData)
    }
    
    //MARK: - Delete Record from table
    
    func deleteConfirm(indexpath: IndexPath){
        let alert = UIAlertController(title: nil, message: VisitorDataViewControllerConstants.deleteAlertMessage, preferredStyle: .alert)
        
       /* let confirmAction = UIAlertAction(title: VisitorDataViewControllerConstants.confirmActionMessage, style: .default) {(_) in
            //let visitorInfo = self.searchedData[indexpath.row]
            let visitorInfo = self.filterSerchedData[indexpath.row]
            //self.filterSerchedData.remove(at: indexpath.row)
            self.context.delete(visitorInfo)
            //self.searchedData.remove(at: indexpath.row)
            self.appDelegate.saveContext()
            self.filterSerchedData.remove(at: indexpath.row)
            self.searchedData.remove(at: indexpath.row)
            /*if self.searchData.count != 0 {
                self.filterSerchedData.remove(at: indexpath.row)
            } */
            self.tableview.reloadData()
        } */
        let confirmAction = UIAlertAction(title: VisitorDataViewControllerConstants.confirmActionMessage, style: .default) {(_) in
            let ref = Database.database().reference()
            let dataRef = ref.child("Visitor")
            dataRef.removeValue()
            self.sortedData.remove(at: indexpath.row)
            self.tableview.reloadData()
        }
        let cancelAction = UIAlertAction(title: VisitorDataViewControllerConstants.cancelActionMessage, style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert,animated: true,completion: nil)
    }
    
    @objc func viewGraph(){
        visitorDataRouter?.routeToChart()
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
    
    //MARK: - Date Difference For display VisitorCard
    
    func getDateDifference(start: Date, end: Date) -> Int  {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([Calendar.Component.second], from: start, to: end)
        let seconds = dateComponents.second
        return Int(seconds! / 3600)
    }
    //MARK: - Image Caching
    func loadImageIntoCache(){
        
        var counter = 0
        for item in searchedData{
            guard let email = item.visitors?.value(forKey: VisitorDataViewControllerConstants.emailString) as? String else {
                return
            }
            let formatter = DateFormatter()
            formatter.dateFormat = VisitorDataViewControllerConstants.dateFormatterForSaveDate
            let compareDate = item.date
            let uniqueKey = email + "\(String(describing: compareDate))"
            counter += 1
            if appDelegate.imageCache.object(forKey: uniqueKey as AnyObject) != nil{
                //Do nothing
                print("No need to cache!!!!")
            } else {
                if let imageData = item.visitImage,let imageToCache = UIImage(data: imageData){
                    self.appDelegate.imageCache.setObject(imageToCache, forKey: uniqueKey as AnyObject)
                }
            }
            if counter == (self.searchedData.count) - 1{
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    //MARK: - Load data while scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // var fetchOffSet = Int()
        //self.activityIndicator.startAnimating()
        //UItableview move only one direction
        let offsetY = scrollView.contentOffset.y
        //let contentHeight = scrollView.contentSize.height
        let maximumOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - offsetY <= 50.0 {
            //sleep(1)
            offset = offset + 10
            fetchLimitedData(fetchoffset: offset)
            /* if self.viewObj.count > 10 {
             offset = offset + 10
             fetchLimitedData(fetchoffset: offset)
             } */
        }
    }
}
//MARK: - Tableview DataSource methods
extension VisitorListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return viewObj.count
        //return searchedData.count
        //return filterSerchedData.count
        //return visitorAllData.count
        return sortedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: VisitorDataViewControllerConstants.visitorCell, for: indexPath) as! VisitorTableViewCell
        //let visit = filterSerchedData[indexPath.row]
        let visit = sortedData[indexPath.row]
       /* cell.setUpCellData(visitData: visit)
        let email = visit.visitors?.value(forKey: VisitorDataViewControllerConstants.emailString) as? String
        let formatter = DateFormatter()
        formatter.dateFormat = VisitorDataViewControllerConstants.dateFormatterForSaveDate
        let compareDate = visit.date
        uniqueKey = (email ?? "") + "\(String(describing: compareDate))"
        
        if let imageFromCache = appDelegate.imageCache.object(forKey: uniqueKey as AnyObject){
            cell.profileImage.image = imageFromCache
        } else {
            cell.profileImage.image = UIImage(named: VisitorDataViewControllerConstants.defaultImage)
        }
        //self.activityIndica or.stopAnimating() */
        /*cell.visitPurpose.text = visit.purspose
        cell.visitorName.text = visit.name
        let formatter = DateFormatter()
        formatter.dateFormat = VisitorDataViewControllerConstants.dateFormatterForDisplayDate
        let compareDate = visit.date
        let compareDbDate = formatter.string(from: compareDate)
        cell.date.text = compareDbDate */
        cell.setUpCellData(visitData: visit)
        
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
        //let data = viewObj
        //let data = searchedData
       /* let item = filterSerchedData[indexPath.row]
        //let item = sortedData[indexPath.row]
        let selectedEmail = item.visitors?.value(forKey: VisitorDataViewControllerConstants.emailString) as! String
        let filterdata =  data.filter{ $0.visitors?.value(forKey: VisitorDataViewControllerConstants.emailString) as? String == selectedEmail }
        //let selectedEmail = item.email
        
        tableview.deselectRow(at: indexPath, animated: true)
        visitorDataRouter?.routeToBarChart(fetcheddata: filterdata, selectedData: item) */
        print(sortedData)
        let data = sortedData
        let item = sortedData[indexPath.row]
        let selectedPhoneNo = item.phoneNo
        let filterdata = data.filter{ $0.phoneNo == selectedPhoneNo }
        print(filterdata)
        print(item)
        
        tableview.deselectRow(at: indexPath, animated: true)
        visitorDataRouter?.routeToBarChart(fetcheddata: filterdata, selectedData: item)
    }
}

//MARK: - SearchBar Delegate Methods

extension VisitorListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
      /*  if searchBar.text != "" {
            activityIndicator.startAnimating()
            DispatchQueue.global(qos: .userInteractive).async {
                self.listInteractor?.fetchVisitorsListByName(request: VisitorList.fetchVisitorRecordByName.Request(name: searchText))
                
            }
            filterSerchedData = searchText.isEmpty ? searchData : searchData.filter{
                (item : Visit) -> Bool in
                let name = item.visitors?.value(forKey: VisitorDataViewControllerConstants.nameString) as? String
                return name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            
        }  else {
            //filterSerchedData = viewObj
            fetchLimitedData(fetchoffset: offset)
        } */
        self.activityIndicator.startAnimating()
        sortedData = searchText.isEmpty ? visitorAllData: visitorAllData.filter({ (dataString: DisplayData) -> Bool in
            let name = dataString.name
            return name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        DispatchQueue.main.async {
            self.tableview.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("on click cancel")
        searchBar.text = ""
        searchBar.resignFirstResponder()
        //searchedData = viewObj
        filterSerchedData = viewObj
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
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            let image = UIImage(data: data)
            DispatchQueue.main.async { [unowned self] in
                self.image = image
                self.contentMode = .scaleAspectFill
            }
        }
    }
}

