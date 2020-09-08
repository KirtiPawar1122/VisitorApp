
import UIKit
import CoreData

class VisitorDataViewController: UIViewController {
    
   // var visitorObj = [Visitor]()
    var viewObj = [Visit]()
    var visits : Visit?
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(viewObj)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "View Graph", style: .plain, target: self, action: #selector(viewGraph))
    }
    
    @objc func viewGraph(){
        
        let data = viewObj
        print(data)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChartViewController") as? ChartViewController
        vc?.visits = data
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Visit")
        do {
            viewObj = try context.fetch(fetchRequest) as! [Visit]
        } catch let error as NSError{
            print("Error in fetching data \(error)")
        }
        print(viewObj)
        self.tableview.reloadData()
    }
    
    func deleteConfirm(indexpath: IndexPath){
            let alert = UIAlertController(title: nil, message: "Are you sure you would like to delete entry", preferredStyle: .alert)
        
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) {(_) in
                print("Click On Confirm")
                let visitorInfo = self.viewObj[indexpath.row]
                self.context.delete(visitorInfo)
                self.viewObj.remove(at: indexpath.row)
                self.appDelegate.saveContext()
                self.tableview.reloadData()
            }
        
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            present(alert,animated: true,completion: nil)
            
        }
}

extension VisitorDataViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitorTableViewCell", for: indexPath) as! VisitorTableViewCell
        let data = viewObj[indexPath.row]
        print(data)
        
        cell.companyName.text = data.companyName
        cell.date.text = data.date
        cell.visitPurpose.text = data.purpose
        cell.address.text = data.visitors?.value(forKey: "address") as? String
        cell.visitorName.text = data.visitors?.value(forKey: "name") as? String
        cell.phoneNo.text = String(data.visitors?.value(forKey: "phoneNo") as! Int64)
        
        if let data = data.visitors?.value(forKey: "profileImage") as? Data?{
            cell.profileImage.image = UIImage(data: data!)
        }else{
            cell.profileImage.image = UIImage(named: "img.jpeg")
            print("profile image is not set")
        }
        return cell
    }
}

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
                print("Email : \(email), Purpose : \(String(describing: visit.purpose))")
                dataArray.append(visit)
               // dataArray.append(visit)
            }
        }
        storyboard.datavisit = dataArray
       // storyboard.visits = [item]
        navigationController?.pushViewController(storyboard, animated: true)
        print("Select table row")
    }
    
    
}

