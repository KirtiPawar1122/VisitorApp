
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
    static let defaultImage = "img.jpeg"
    static let visitorCell = "VisitorTableViewCell"
}

class VisitorListViewController: UIViewController, VisitorListDisplayLogic {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var filterbutton: UIButton!
    
    var viewObj = [Visit]()
    //var visits: Visit?
    var listInteractor : VisitorListBusinessLogic?
    var visitorDataRouter : visitorListRoutingLogic?
   // var searchedData: [Visit]?
    var searchedData = [Visit]()
    var currentDate = Date()

    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: VisitorDataViewControllerConstants.navRightBarTitle, style: .plain, target: self, action: #selector(viewGraph))
        tableview.keyboardDismissMode = .onDrag
        hideKeyboardTappedAround()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "backImage")!)
        self.tableview.backgroundColor = UIColor(patternImage: UIImage(named: "backImage")!)
        self.searchBar.barTintColor = #colorLiteral(red: 0.006955888588, green: 0.0941728428, blue: 0.1826652586, alpha: 0.8777022688)
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.7952535152, green: 0.7952535152, blue: 0.7952535152, alpha: 1)
        searchBar.searchTextField.layer.cornerRadius = 5
        searchBar.searchTextField.layer.borderColor = UIColor.white.cgColor
        searchBar.searchTextField.layer.borderWidth = 2
        searchBar.searchTextField.placeholder = "Search here"
        filterbutton.layer.cornerRadius = 5
        filterbutton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.tableview.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
       // fetchVisitorList()
       // self.tableview.reloadData()
    }
    
    func hideKeyboardTappedAround(){
        let tap : UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dissmissKeyboard(){
        view.endEditing(true)
    }
    
    func fetchVisitorList(){
        let request = VisitorList.fetchVisitorList.Request()
        listInteractor?.fetchVisitorData(request: request)
    }

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
        print("on Click")
        
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
        
    
       /* let optionMenu = UIAlertController(title: nil, message: "Filter By", preferredStyle: .actionSheet)
        optionMenu.modalPresentationStyle = .popover
        optionMenu.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        optionMenu.popoverPresentationController?.delegate = self
        optionMenu.popoverPresentationController?.sourceView = sender as? UIButton // button
        optionMenu.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
       
        let FirstAction = UIAlertAction(title: "by Name", style: .default){ (_) in
            self.onClickByName()
            return
        }
        let SecondAction = UIAlertAction(title: "by Purpose", style: .default){ (_) in
            self.onClickByPurpose()
            return
        }
        optionMenu.addAction(FirstAction)
        optionMenu.addAction(SecondAction)
        
        optionMenu.popoverPresentationController?.sourceView = filterbutton
        switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                optionMenu.popoverPresentationController?.sourceView = self.view
                optionMenu.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: .zero, height: .zero)
                optionMenu.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
            default:
                    break
        }
        self.navigationController?.present(optionMenu, animated: true, completion: nil) */
        
    }
    
    func onClickByName(){
        print("click by Name")
        
    }
    
    func onClickByPurpose(){
        print("click by Purpose")
    }
    
    func constructMenu(){
       // let byPerson = UIMenuItem(title: "by Name", action: #selector(viewPersonFilter))
    }
    
    @objc func viewPersonFilter(){
        
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
        //cell.subView.backgroundColor = #colorLiteral(red: 0.6087739468, green: 0.09021262079, blue: 0.1081616506, alpha: 1)
        cell.contentView.backgroundColor = UIColor.clear
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        let data = searchedData[indexPath.row]
        print(data as Any)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        let stringDate = formatter.string(from: currentDate)
       /* let todaysDate = currentDate
        print(todaysDate)
        print(data.date!) */
        
        if data.date! == stringDate {
            cell.subView.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            cell.date.text = data.date
            cell.emailID.text = data.visitors?.value(forKey: "email") as? String
            cell.address.text = data.visitors?.value(forKey: VisitorDataViewControllerConstants.addressString) as? String
            cell.visitorName.text = data.visitors?.value(forKey: VisitorDataViewControllerConstants.nameString) as? String
            cell.visitPurpose.text = data.purpose
            cell.phoneNo.text = String(data.visitors?.value(forKey: VisitorDataViewControllerConstants.phoneString) as! Int64)
            if let data = data.visitors?.value(forKey: VisitorDataViewControllerConstants.profileImage) as? Data {
                       cell.profileImage.image = UIImage(data: data)
            }else {
                cell.profileImage.image = UIImage(named: VisitorDataViewControllerConstants.defaultImage)
            }
        } else {
            cell.subView.backgroundColor = #colorLiteral(red: 0.6087739468, green: 0.09021262079, blue: 0.1081616506, alpha: 1)
            cell.date.text = data.date
            cell.emailID.text = data.visitors?.value(forKey: "email") as? String
            cell.address.text = data.visitors?.value(forKey: VisitorDataViewControllerConstants.addressString) as? String
            cell.visitorName.text = data.visitors?.value(forKey: VisitorDataViewControllerConstants.nameString) as? String
            cell.visitPurpose.text = data.purpose
            cell.phoneNo.text = String(data.visitors?.value(forKey: VisitorDataViewControllerConstants.phoneString) as! Int64)
            if let data = data.visitors?.value(forKey: VisitorDataViewControllerConstants.profileImage) as? Data {
                       cell.profileImage.image = UIImage(data: data)
            }else {
                cell.profileImage.image = UIImage(named: VisitorDataViewControllerConstants.defaultImage)
            }
        }
       // cell.date.text = data.date
        //cell.companyName.text = data.companyName
/*cell.emailID.text = data.visitors?.value(forKey: "email") as? String
        cell.address.text = data.visitors?.value(forKey: VisitorDataViewControllerConstants.addressString) as? String
        cell.visitorName.text = data.visitors?.value(forKey: VisitorDataViewControllerConstants.nameString) as? String
        cell.visitPurpose.text = data.purpose
        cell.phoneNo.text = String(data.visitors?.value(forKey: VisitorDataViewControllerConstants.phoneString) as! Int64)
        if let data = data.visitors?.value(forKey: VisitorDataViewControllerConstants.profileImage) as? Data {
            cell.profileImage.image = UIImage(data: data)
        }else {
            cell.profileImage.image = UIImage(named: VisitorDataViewControllerConstants.defaultImage)
        } */
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
       // return UITableView.automaticDimension
        return 110
    }
      
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let data = viewObj
       // let item = viewObj[indexPath.row]
        let item = searchedData[indexPath.row]
        var dataArray = [Visit]()
        let selectedEmail = item.visitors?.value(forKey: VisitorDataViewControllerConstants.emailString) as! String
        for visit in data {
            let email = visit.visitors?.value(forKey: VisitorDataViewControllerConstants.emailString) as? String
            if email == selectedEmail {
                dataArray.append(visit)
            }
        }
        //visitorDataRouter?.routeToBarChartData(selectedData: item)
       // visitorDataRouter?.routeToBarChart(fetcheddata: dataArray,selectedData: item)
        visitorDataRouter?.routeToBarChart(fetcheddata: dataArray, selectedData: item)
    }
}
//MARK: - SearchBar Delegate Methods
extension VisitorListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        searchedData = searchText.isEmpty ? viewObj : viewObj.filter{
            (item : Visit) -> Bool in
            let name = item.visitors?.value(forKey: "name") as? String
            return name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil 
           // let email = item.visitors?.value(forKey: "email") as? String
           // return email?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            
           /* if let name = item.visitors?.value(forKey: "name") as? String  {
                return name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            } else if let email = item.visitors?.value(forKey: "email") as? String  {
                return email.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            return true*/
        }
        tableview.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchedData = viewObj
        searchBar.endEditing(true)
        tableview.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("click")
    }
}

extension VisitorListViewController: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
 
}
