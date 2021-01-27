
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
    static let defaultImage = "profile"
    static let visitorCell = "VisitorTableViewCell"
    static let timeLimit = 8
    static let fontFamily = "Roboto-Regular"
    static let dateFormatter = "dd/MM/yyyy   hh:mm a"
    static let fontSize : CGFloat = 17
}

class VisitorListViewController: UIViewController, VisitorListDisplayLogic {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var filterbutton: UIButton!
    
    var viewObj = [Visit]()
    var listInteractor : VisitorListBusinessLogic?
    var visitorDataRouter : visitorListRoutingLogic?
    var searchedData = [Visit]()
    var currentDate = Date()

    let imageCache = NSCache<AnyObject, AnyObject>()

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
        fetchVisitorList()
        setUpUI()

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
        searchBar.searchTextField.font = UIFont(name: VisitorDataViewControllerConstants.fontFamily, size: VisitorDataViewControllerConstants.fontSize)
        searchBar.searchTextField.textColor = UIColor.black
        searchBar.searchTextField.placeholder = "Search here"
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
        let request = VisitorList.fetchVisitorList.Request()
        listInteractor?.fetchVisitorData(request: request)
    }
    
   //MARK: - Fetch Response
    func displayVisitorList(viewModel: VisitorList.fetchVisitorList.ViewModel){
        print(viewModel)
        viewObj = viewModel.visit!
        searchedData = viewObj
    }
    
   //MARK: - Delete Record from table
    
    func deleteConfirm(indexpath: IndexPath){
        let alert = UIAlertController(title: nil, message: VisitorDataViewControllerConstants.deleteAlertMessage, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: VisitorDataViewControllerConstants.confirmActionMessage, style: .default) {(_) in
                //let visitorInfo = self.viewObj[indexpath.row]
                 let visitorInfo = self.searchedData[indexpath.row]
                 self.context.delete(visitorInfo)
                 self.searchedData.remove(at: indexpath.row)
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
}
//MARK: - Tableview DataSource methods

extension VisitorListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return viewObj.count
        return searchedData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: VisitorDataViewControllerConstants.visitorCell, for: indexPath) as! VisitorTableViewCell
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = UIColor.clear
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.cellConfigure()
        
        let data = searchedData[indexPath.row]
        print(data as Any)
        let formatter = DateFormatter()
        formatter.dateFormat = VisitorDataViewControllerConstants.dateFormatter
        let compareDate = data.date
        let compareDbDate = formatter.string(from: compareDate!)
        let compareDateDbDate = formatter.date(from: compareDbDate)
        let timedata = getDateDifference(start: compareDateDbDate!, end: currentDate)
        print(timedata)
        
        cell.date.text = compareDbDate
        cell.visitorName.text = data.visitors?.value(forKey: VisitorDataViewControllerConstants.nameString) as? String
        cell.visitPurpose.text = data.purpose
        let email = data.visitors?.value(forKey: VisitorDataViewControllerConstants.emailString) as! String
        let uniqueKey = email + "\(String(describing: compareDate))"
        
        if let imageFromCache = imageCache.object(forKey: uniqueKey as AnyObject) as? UIImage {

                    cell.profileImage.image = imageFromCache
        } else {
            DispatchQueue.main.async {
                        if let data = data.visitors?.value(forKey: VisitorDataViewControllerConstants.profileImage) as? Data, let imageToCache = UIImage(data: data) {

                           
                               cell.profileImage.image = imageToCache
                           self.imageCache.setObject(imageToCache, forKey: uniqueKey as AnyObject)
                                  } else {
                                      cell.profileImage.image = UIImage(named: VisitorDataViewControllerConstants.defaultImage)
                           }
                   }
                   
        }
            
        //Comment: 8 hrs time limit
        if timedata <= VisitorDataViewControllerConstants.timeLimit {
            print("green")
            cell.subView.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        } else {
            print("Red")
            cell.subView.backgroundColor = #colorLiteral(red: 0.6087739468, green: 0.09021262079, blue: 0.1081616506, alpha: 1)
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



