
import UIKit
import CoreData

protocol VisitorDataProtocol{
    func viewProtocol(visitorData : [Visit])
}

struct VisitorDataViewControllerConstants{
    static let navRightBarTitle = "View Graph"
    static let deleteAlertMessage = "Are you sure you would like to delete entry"
    static let confirmActionMessage = "Confirm"
    static let cancelActionMessage = "Cancel"
}

class VisitorDataViewController: UIViewController, VisitorDataProtocol {

    @IBOutlet weak var tableview: UITableView!
    
    var viewObj = [Visit]()
    var visits: Visit?
    var interactor : VisitorListInteractor = VisitorListInteractor()
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: VisitorDataViewControllerConstants.navRightBarTitle, style: .plain, target: self, action: #selector(viewGraph))
        //tableview.reloadData()
      //  interactor.fecthAllData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Visit")
        do {
            viewObj = try context.fetch(fetchRequest) as! [Visit]
        } catch let error as NSError{
            print(error.description)
        }
      //  interactor.fecthAllData()
        self.tableview.reloadData()
    }
    
    func viewProtocol(visitorData: [Visit]) {
        print(visitorData)
        viewObj = visitorData
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChartViewController") as? ChartViewController
        vc?.visits = data
        navigationController?.pushViewController(vc!, animated: true)
    }
}
//MARK: - Tableview DataSource methods
extension VisitorDataViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitorTableViewCell", for: indexPath) as! VisitorTableViewCell
        let data = viewObj[indexPath.row]
        
        cell.companyName.text = data.companyName
        cell.date.text = data.date
        cell.visitPurpose.text = data.purpose
        cell.address.text = data.visitors?.value(forKey: "address") as? String
        cell.visitorName.text = data.visitors?.value(forKey: "name") as? String
        cell.phoneNo.text = String(data.visitors?.value(forKey: "phoneNo") as! Int64)
        
        if let data = data.visitors?.value(forKey: "profileImage") as? Data?{
            cell.profileImage.image = UIImage(data: data!)
        } else {
            cell.profileImage.image = UIImage(named: "img.jpeg")
            print("profile image is not set")
        }
        return cell
    }
}
//MARK: - Tableview Delegate Methods
extension VisitorDataViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
           deleteConfirm(indexpath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewObj
        let item = viewObj[indexPath.row]
        var dataArray = [Visit]()
        let selectedEmail = item.visitors?.value(forKey: "email") as! String
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "VisitorChartViewController") as! VisitorChartViewController
        for visit in data {
            let email = visit.visitors?.value(forKey: "email") as! String
            if email == selectedEmail {
                dataArray.append(visit)
            }
        }
        storyboard.datavisit = dataArray
        navigationController?.pushViewController(storyboard, animated: true)
       
    }
}

