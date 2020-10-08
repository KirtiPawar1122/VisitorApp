
import UIKit
import CoreData

protocol VisitorListDisplayLogic{
 //   func viewProtocol(visitorData : [Visit])
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

class VisitorDataViewController: UIViewController, VisitorListDisplayLogic {

    @IBOutlet weak var tableview: UITableView!
    
    var viewObj = [Visit]()
    var visits: Visit?
    var interactor : VisitorListInteractor = VisitorListInteractor()
    var visitorDataRouter : VisitorListRouter = VisitorListRouter()
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad(){
        super.viewDidLoad()
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: VisitorDataViewControllerConstants.navRightBarTitle, style: .plain, target: self, action: #selector(viewGraph))
    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
       // interactor.fecthAllData()
        let request = VisitorList.fetchVisitorList.Request()
        interactor.fetchAllData(request: request)
        self.tableview.reloadData()
    }
    
    func viewProtocol(visitorData: [Visit]){
        print(visitorData)
        viewObj = visitorData
    }
    
    func displayVisitorList(viewModel: VisitorList.fetchVisitorList.ViewModel){
        print(viewModel)
        viewObj = viewModel.visit
    }
    
    func deleteConfirm(indexpath: IndexPath){
        let alert = UIAlertController(title: nil, message: VisitorDataViewControllerConstants.deleteAlertMessage, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: VisitorDataViewControllerConstants.confirmActionMessage, style: .default) {(_) in
                let visitorInfo = self.viewObj[indexpath.row]
                self.context.delete(visitorInfo)
                self.viewObj.remove(at: indexpath.row)
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
        visitorDataRouter.routeToChart(data: data, navigationController: navigationController!)
    }
}
//MARK: - Tableview DataSource methods
extension VisitorDataViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: VisitorDataViewControllerConstants.visitorCell, for: indexPath) as! VisitorTableViewCell
        let data = viewObj[indexPath.row]
        
        cell.companyName.text = data.companyName
        cell.date.text = data.date
        cell.visitPurpose.text = data.purpose
        cell.address.text = data.visitors?.value(forKey: VisitorDataViewControllerConstants.addressString) as? String
        cell.visitorName.text = data.visitors?.value(forKey: VisitorDataViewControllerConstants.nameString) as? String
        cell.phoneNo.text = String(data.visitors?.value(forKey: VisitorDataViewControllerConstants.phoneString) as! Int64)
        
        if let data = data.visitors?.value(forKey: VisitorDataViewControllerConstants.profileImage) as? Data?{
            cell.profileImage.image = UIImage(data: data!)
        } else {
            cell.profileImage.image = UIImage(named: VisitorDataViewControllerConstants.defaultImage )
        }
        return cell
    }
}
//MARK: - Tableview Delegate Methods
extension VisitorDataViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
           deleteConfirm(indexpath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let data = viewObj
        let item = viewObj[indexPath.row]
        var dataArray = [Visit]()
        let selectedEmail = item.visitors?.value(forKey: VisitorDataViewControllerConstants.emailString) as! String
        for visit in data {
            let email = visit.visitors?.value(forKey: VisitorDataViewControllerConstants.emailString) as! String
            if email == selectedEmail {
                dataArray.append(visit)
            }
        }
        visitorDataRouter.routeToBarChart(fetcheddata: dataArray, navigationController: navigationController!)
    }
}

