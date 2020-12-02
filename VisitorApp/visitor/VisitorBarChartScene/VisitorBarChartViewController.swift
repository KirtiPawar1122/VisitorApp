
import UIKit
import Charts

protocol VisitorBarChartDisplayLogic {
    func displayVisitorBarChartData(viewModel : VisitorBarChart.VisitorBarChartData.ViewModel)
}

struct VisitorsChartViewControllerConstants {
    static let visitorChartTitle = "Visitor Details"
    static let meetingTitle = "Meeting"
    static let interviewTitle = "Interview"
    static let guestVisitTitle = "Guest Visit"
    static let otherTitle = "Other"
}

class VisitorBarChartViewController: UIViewController, VisitorBarChartDisplayLogic {
  
    @IBOutlet weak var histogram: BarChartView!
    @IBOutlet weak var viewUI: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var namedataLabel : UILabel!
    @IBOutlet var detailView: UIView!
    @IBOutlet var purposeLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var onPrintBtn: UIButton!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var hostLabel: UILabel!
    @IBOutlet var totalVisitCount: UILabel!
    var datavisit = [Visit]()
    var chartData = [Visit]()
    var selectedData = Visit()
    let purpose = ["Meeting", "Interview", "Guest Visit", "Others"]
    var meeting = 0
    var interview = 0
    var guestVisit = 0
    var other = 0
    var meetingDate = [String]()
    var interviewDate = [String]()
    var guestvisitDate = [String]()
    var otherDate = [String]()
    var items : [[String]] = []
    var sectionName = String()
    var barChartRouter : VisitorBarChartRoutingLogic?
    //var barChartInterator : VisitorBarChartInteractor = VisitorBarChartInteractor()
    var barChartInteractor : VisitorBarChartBusinessLogic?
    //var barChartRouter: VisitorBarChartRoutingLogic?
    
    
      //MARK: Object lifecycle
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
        let router = VisitorBarChartRouter()
        let interactor = VisitorBarChartInteractor()
        let presenter = VisitorBarChartPresenter()
        viewController.barChartInteractor = interactor
        interactor.visitData = chartData
        interactor.presenter = presenter
        presenter.viewObject = viewController
        viewController.barChartRouter = router

    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = VisitorsChartViewControllerConstants.visitorChartTitle
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backImage")!)
        getBarChartData()
        histogram.legend.enabled = false
        onPrintBtn.layer.cornerRadius = 5
        profileImage.layer.cornerRadius = 10
        profileImage.layer.borderWidth = 5
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        purposeLabel.text = selectedData.purpose
        nameLabel.text = selectedData.visitors?.value(forKey: "name") as? String
        emailLabel.text = selectedData.visitors?.value(forKey: "email") as? String
        dateLabel.text = selectedData.date
        addressLabel.text = selectedData.visitors?.value(forKey: "address") as? String
        companyLabel.text = selectedData.companyName
        hostLabel.text = selectedData.visitorName
        phoneLabel.text = selectedData.visitors?.value(forKey: "phoneNo") as? String
        totalVisitCount.text = String(datavisit.count)
        let image = UIImage(data: selectedData.visitors?.value(forKey: "profileImage") as! Data)
        print(image!)
        profileImage.image = image!
        
        
    }
    
    func getBarChartData() {
        let request = VisitorBarChart.VisitorBarChartData.Request()
        barChartInteractor?.visitorBarChartData(request: request)
    }
    
    func displayVisitorBarChartData(viewModel: VisitorBarChart.VisitorBarChartData.ViewModel) {
        chartData = viewModel.visitData
        print(datavisit)
        for item in datavisit {
           // namedataLabel.text = "Details Of \(item.visitors!.value(forKey: "name"))"
          //  namedataLabel.textColor = UIColor.white
    
            if item.purpose == VisitorsChartViewControllerConstants.meetingTitle{
                meeting = meeting + 1
                meetingDate.append(item.date!)
                print(meetingDate)
            } else if item.purpose == VisitorsChartViewControllerConstants.interviewTitle{
                interview = interview + 1
                interviewDate.append(item.date!)
            } else if item.purpose == VisitorsChartViewControllerConstants.guestVisitTitle {
                guestVisit = guestVisit + 1
                guestvisitDate.append(item.date!)
            } else if item.purpose == VisitorsChartViewControllerConstants.otherTitle {
                other = other + 1
                otherDate.append(item.date!)
            }
        }
        items = [meetingDate,interviewDate,guestvisitDate,otherDate]
               
        let data = [meeting,interview,guestVisit,other]
        setDataOnChart(dataPoints: purpose, values: data.map({ Double($0)}))
        
    }
    
    func setDataOnChart(dataPoints: [String], values: [Double]) {
       var dataEntries: [BarChartDataEntry] = []
                
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]) ,data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
    
        let barChartDataSet = BarChartDataSet(entries: dataEntries, label: "Visitor Data")
        barChartDataSet.colors = [UIColor.red, UIColor.orange, UIColor.systemYellow,UIColor.systemGreen]

        if let font = UIFont(name: "Arial", size: 17) {
            barChartDataSet.valueFont = font
        } else {
            print("error in to set font")
        }
        
        let barChartData = BarChartData(dataSet: barChartDataSet)
        barChartData.barWidth = 0.6
        barChartData.setValueTextColor(.white)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        barChartData.setValueFormatter(formatter)
    
        histogram.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        histogram.xAxis.labelTextColor = UIColor.white
        histogram.xAxis.granularityEnabled = true
        histogram.xAxis.drawGridLinesEnabled = false
        histogram.xAxis.labelPosition = .bottom
        histogram.xAxis.labelFont = UIFont(name: "Arial", size: 17)!
        histogram.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInOutQuart)
        histogram.leftAxis.axisMinimum = 0
        histogram.rightAxis.axisMinimum = 0
        histogram.rightAxis.labelTextColor = UIColor.white
        histogram.leftAxis.labelTextColor = UIColor.white
        histogram.data = barChartData
    }

    @IBAction func printButton(_ sender: Any) {
        print(selectedData)
        barChartRouter?.routeToPrintVisitors(data: selectedData)
    }
}

/*
extension VisitorBarChartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt in
 dexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension VisitorBarChartViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return purpose.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return purpose[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count 
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "VisitorChartTableViewCell") as! VisitorChartTableViewCell
        let data = items[indexPath.section][indexPath.row]
        //let dataitem =  items[indexPath.row]
        cell.selectionStyle = .none
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.sectionLabel.text = VisitorsChartViewControllerConstants.meetingTitle
            } else  {
                cell.sectionLabel.text = ""
            }
            cell.dataLabel.text = data
            cell.backgroundColor = UIColor.red
        }
        if (indexPath.section == 1){
            if (indexPath.row == 0) {
                cell.sectionLabel.text = VisitorsChartViewControllerConstants.interviewTitle
            } else {
                cell.sectionLabel.text = ""
            }
            cell.dataLabel.text = data
            cell.backgroundColor = UIColor.orange
        }
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
               cell.sectionLabel.text = VisitorsChartViewControllerConstants.guestVisitTitle
            } else {
               cell.sectionLabel.text = ""
            }
            cell.dataLabel.text = data
            cell.backgroundColor = UIColor.systemYellow
        }
        if (indexPath.section == 3){
            if (indexPath.row == 0) {
               cell.sectionLabel.text = VisitorsChartViewControllerConstants.otherTitle
            } else {
               cell.sectionLabel.text = ""
            }
            cell.dataLabel.text = data
            cell.backgroundColor = UIColor.systemGreen
        }
        return cell
    }
} */
