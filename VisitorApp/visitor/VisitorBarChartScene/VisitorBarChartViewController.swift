
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
    
    @IBOutlet var leftInnerView: UIView!
    @IBOutlet var rightInnerView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
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
    var currentDate = Date()
    
    
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
        self.view.backgroundColor = #colorLiteral(red: 0.1221894994, green: 0.1234087124, blue: 0.2142429054, alpha: 1)
        getBarChartData()
        histogram.legend.enabled = false
        onPrintBtn.layer.cornerRadius = 5
        profileImage.layer.cornerRadius = 10
        profileImage.layer.borderWidth = 5
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm a"
        //formatter.dateStyle = .medium
        let currentSelectedDate = selectedData.date
        let stringDate = formatter.string(from: currentSelectedDate!)
        let selectedDate = formatter.date(from: stringDate)
        let timedata = getDateDiff(start: selectedDate!, end: currentDate)
        print(stringDate)
     
        if timedata <= 8 {
            onPrintBtn.isHidden = false
        } else {
            onPrintBtn.isHidden = true
        }
        
        purposeLabel.text = selectedData.purpose
        nameLabel.text = selectedData.visitors?.value(forKey: "name") as? String
        emailLabel.text = selectedData.visitors?.value(forKey: "email") as? String
        dateLabel.text = stringDate
        //addressLabel.text = selectedData.visitors?.value(forKey: "address") as? String
        companyLabel.text = selectedData.companyName
        hostLabel.text = selectedData.visitorName
        phoneLabel.text = selectedData.visitors?.value(forKey: "phoneNo") as? String
        totalVisitCount.text = String(datavisit.count)
        let image = UIImage(data: selectedData.visitors?.value(forKey: "profileImage") as! Data)
        print(image!)
        profileImage.image = image!
        viewUI.backgroundColor = .clear
        tableview.backgroundColor = .clear
        tableview.layer.borderColor = UIColor.white.cgColor
        tableview.layer.borderWidth = 2
        //scrollView.contentSize = CGSize(width: self.viewUI.frame.width, height: self.viewUI.frame.height + 100)
    }
    
    func getBarChartData() {
        let request = VisitorBarChart.VisitorBarChartData.Request()
        barChartInteractor?.visitorBarChartData(request: request)
    }
    
    func displayVisitorBarChartData(viewModel: VisitorBarChart.VisitorBarChartData.ViewModel) {
        chartData = viewModel.visitData
        print(datavisit)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm a"
        for item in datavisit {
           // namedataLabel.text = "Details Of \(item.visitors!.value(forKey: "name"))"
           // namedataLabel.textColor = UIColor.white
            if item.purpose == VisitorsChartViewControllerConstants.meetingTitle{
                meeting = meeting + 1
                //meetingDate.append(item.date!)
                let meetingDateString = formatter.string(from: item.date!)
                meetingDate.append(meetingDateString)
                print(meetingDate)
            } else if item.purpose == VisitorsChartViewControllerConstants.interviewTitle{
                interview = interview + 1
                let interviewDateString = formatter.string(from: item.date!)
                interviewDate.append(interviewDateString)
            } else if item.purpose == VisitorsChartViewControllerConstants.guestVisitTitle {
                guestVisit = guestVisit + 1
                let guestVisitDateString = formatter.string(from: item.date!)
                guestvisitDate.append(guestVisitDateString)
            } else if item.purpose == VisitorsChartViewControllerConstants.otherTitle {
                other = other + 1
                let otherDateString = formatter.string(from: item.date!)
                otherDate.append(otherDateString)
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
        barChartDataSet.colors = [UIColor.systemBlue, UIColor.systemYellow, UIColor.systemGreen,UIColor.systemRed]

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
        print(selectedData.visitors?.value(forKey: "email") as Any)
        //barChartRouter?.routeToPrintVisitors(data: selectedData)
        let vc = storyboard?.instantiateViewController(withIdentifier: "VisitorPrintViewController") as? VisitorPrintViewController
        //vc?.selectedEmail = selectedData.visitors?.value(forKey: "email") as! String
        vc?.selectedPhoneNo = selectedData.visitors?.value(forKey: "phoneNo") as! String
        navigationController?.pushViewController(vc!, animated: true)
    }
    
     
    func getDateDiff(start: Date, end: Date) -> Int  {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([Calendar.Component.second], from: start, to: end)

        let seconds = dateComponents.second
        return Int(seconds! / 3600)
    }
    
}

extension VisitorBarChartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        //return 100
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
        //cell.sectionLabel.textColor = .white
        //cell.dataLabel.textColor = .white
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.sectionLabel.text = VisitorsChartViewControllerConstants.meetingTitle
            } else  {
                cell.sectionLabel.text = ""
            }
            cell.dataLabel.text = data
            cell.backgroundColor = UIColor.systemBlue
        }
        if (indexPath.section == 1){
            if (indexPath.row == 0) {
                cell.sectionLabel.text = VisitorsChartViewControllerConstants.interviewTitle
            } else {
                cell.sectionLabel.text = ""
            }
            cell.dataLabel.text = data
            //cell.backgroundColor = UIColor.orange
            cell.backgroundColor = UIColor.systemYellow
        }
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
               cell.sectionLabel.text = VisitorsChartViewControllerConstants.guestVisitTitle
            } else {
               cell.sectionLabel.text = ""
            }
            cell.dataLabel.text = data
            //cell.backgroundColor = UIColor.systemYellow
            cell.backgroundColor = UIColor.systemGreen
        }
        if (indexPath.section == 3){
            if (indexPath.row == 0) {
               cell.sectionLabel.text = VisitorsChartViewControllerConstants.otherTitle
            } else {
               cell.sectionLabel.text = ""
            }
            cell.dataLabel.text = data
            //cell.backgroundColor = UIColor.systemGreen
            cell.backgroundColor = UIColor.systemRed
        }
        return cell
    }
}
