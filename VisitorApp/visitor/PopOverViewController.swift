
import UIKit

class PopOverViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    let dataArray = ["by Name", "by Purpose"]
    static let cellID = "Cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
    }
}

extension PopOverViewController: UITableViewDelegate{
    
}

extension PopOverViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: PopOverViewController.cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: PopOverViewController.cellID)
        }
        cell?.textLabel?.text = dataArray[indexPath.row]
        return cell ?? UITableViewCell()
        
    }
}
