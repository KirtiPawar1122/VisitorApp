
import UIKit

class PopOverViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    let filterTitles = ["Meeting", "Interview", "Guest Visit", "Other"]
    var delegate: UISearchBarDelegate?
    let searcController = UISearchController(searchResultsController: nil)
    static let cellID = "Cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.isScrollEnabled = false
        preferredContentSize = CGSize(width: 150, height: 180)
    }
    
    func filterSearchController(_ searchBar: UISearchBar){
    }
    //func applyFilter(searchText: String, scope: String = "by Name"){}
}

extension PopOverViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PopOverViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: PopOverViewController.cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: PopOverViewController.cellID)
        }
        cell?.textLabel?.text = filterTitles[indexPath.row]
        return cell ?? UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
    }
}
