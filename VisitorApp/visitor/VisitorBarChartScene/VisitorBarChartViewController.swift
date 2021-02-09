
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
    static let font = "Roboto-Regular"
    static let fontSize: CGFloat = 17
    static let nameString = "name"
    static let emailString = "email"
    static let phoneString = "phoneNo"
    static let profile = "profileImage"
    static let dateFormat = "dd/MM/yyyy hh:mm a"
    static let dateFormat2 = "dd/MM/yyyy   hh:mm a"
    static let visitorDataLabel = "Visitor Data"
    static let visitorPrintViewController = "VisitorPrintViewController"
    static let visitorChartTableViewCell = "VisitorChartTableViewCell"
}

class VisitorBarChartViewController: UIViewController, VisitorBarChartDisplayLogic {
  
    @IBOutlet var BarChartOuterView: UIView!
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
    var barChartInteractor : VisitorBarChartBusinessLogic?
    var currentDate = Date()
    
    
    //MARK: - Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            setup()
      }

    required init?(coder aDecoder: NSCoder){
            super.init(coder: aDecoder)
            setup()
      }

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
        
        getBarChartData()
        setUpUI()
        
        let formatter = DateFormatter()
        formatter.dateFormat = VisitorsChartViewControllerConstants.dateFormat
        let currentSelectedDate = selectedData.date
        let stringDate = formatter.string(from: currentSelectedDate!)
        print(stringDate)
     
        purposeLabel.text = selectedData.purpose
        nameLabel.text = selectedData.visitors?.value(forKey: VisitorsChartViewControllerConstants.nameString) as? String
        emailLabel.text = selectedData.visitors?.value(forKey: VisitorsChartViewControllerConstants.emailString) as? String
        dateLabel.text = stringDate
        companyLabel.text = selectedData.companyName
        hostLabel.text = selectedData.visitorName
        phoneLabel.text = selectedData.visitors?.value(forKey: VisitorsChartViewControllerConstants.phoneString) as? String
        totalVisitCount.text = String(datavisit.count)
        //let image = UIImage(data: selectedData.visitors?.value(forKey: VisitorsChartViewControllerConstants.profile ) as! Data)
        let image = UIImage(data: selectedData.visitImage!) 
        profileImage.image = image!
        
    }
    
    
    func setUpUI(){
        self.navigationItem.title = VisitorsChartViewControllerConstants.visitorChartTitle
        self.view.backgroundColor = #colorLiteral(red: 0.999904573, green: 1, blue: 0.9998808503, alpha: 1)
        
        onPrintBtn.layer.cornerRadius = onPrintBtn.frame.height/2
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.systemGray3.cgColor
        
        viewUI.backgroundColor = .clear
        histogram.backgroundColor = .clear
        BarChartOuterView.backgroundColor = #colorLiteral(red: 0.9811108733, green: 0.9797196062, blue: 0.9815657106, alpha: 1)
        tableview.backgroundColor = .clear
        tableview.layer.borderColor = UIColor.white.cgColor
        tableview.layer.borderWidth = 2
    }
    
    func getBarChartData() {
        let request = VisitorBarChart.VisitorBarChartData.Request()
        barChartInteractor?.visitorBarChartData(request: request)
    }
    
    func displayVisitorBarChartData(viewModel: VisitorBarChart.VisitorBarChartData.ViewModel) {
        chartData = viewModel.visitData
        print(datavisit)
        let formatter = DateFormatter()
        formatter.dateFormat = VisitorsChartViewControllerConstants.dateFormat2
        for item in datavisit {
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
    
        let barChartDataSet = BarChartDataSet(entries: dataEntries, label: VisitorsChartViewControllerConstants.visitorDataLabel)
        barChartDataSet.colors = [#colorLiteral(red: 0.07873522429, green: 0.4801783562, blue: 0.8375625014, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8235639408, blue: 0.8712158807, alpha: 1), #colorLiteral(red: 0.8907681206, green: 0, blue: 0.1075288955, alpha: 1), #colorLiteral(red: 0.5014447774, green: 0, blue: 0.5014447774, alpha: 1)]

        if let font = UIFont(name: VisitorsChartViewControllerConstants.font, size: VisitorsChartViewControllerConstants.fontSize) {
            barChartDataSet.valueFont = font
        } else {
            print("error in to set font")
        }
        
        let barChartData = BarChartData(dataSet: barChartDataSet)
        barChartData.barWidth = 0.4
        barChartData.setValueTextColor(.black)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        barChartData.setValueFormatter(formatter)
    
        histogram.layer.cornerRadius = 0.5
        histogram.legend.enabled = false
        histogram.clipsToBounds = true
        histogram.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        histogram.xAxis.labelTextColor = UIColor.black
        histogram.xAxis.granularityEnabled = true
        histogram.xAxis.drawGridLinesEnabled = false
        histogram.leftAxis.drawGridLinesEnabled = false
        histogram.rightAxis.drawGridLinesEnabled = false
        histogram.xAxis.labelPosition = .bottom
        histogram.xAxis.labelFont = UIFont(name: VisitorsChartViewControllerConstants.font, size: VisitorsChartViewControllerConstants.fontSize)!
        histogram.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInOutQuart)
        histogram.leftAxis.axisMinimum = .zero
        histogram.rightAxis.axisMinimum = .zero
        histogram.rightAxis.drawAxisLineEnabled = false
        histogram.rightAxis.drawLabelsEnabled = false
        histogram.rightAxis.labelTextColor = UIColor.black
        histogram.leftAxis.labelTextColor = UIColor.black
        histogram.data = barChartData
    }

    @IBAction func printButton(_ sender: Any) {
      
        let vc = storyboard?.instantiateViewController(withIdentifier: VisitorsChartViewControllerConstants.visitorPrintViewController ) as? VisitorPrintViewController
        vc?.selectedPhoneNo = selectedData.visitors?.value(forKey: VisitorsChartViewControllerConstants.phoneString) as! String
        vc?.printVisitData = selectedData
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
        
        let cell = tableview.dequeueReusableCell(withIdentifier: VisitorsChartViewControllerConstants.visitorChartTableViewCell) as! VisitorChartTableViewCell
        let data = items[indexPath.section][indexPath.row]
        cell.sectionLabel.font = UIFont(name: VisitorsChartViewControllerConstants.font, size: VisitorsChartViewControllerConstants.fontSize)
        cell.dataLabel.font = UIFont(name: VisitorsChartViewControllerConstants.font, size: VisitorsChartViewControllerConstants.fontSize)
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.sectionLabel.text = VisitorsChartViewControllerConstants.meetingTitle
            } else  {
                cell.sectionLabel.text = ""
            }
            cell.dataLabel.text = data
            cell.backgroundColor = #colorLiteral(red: 0.07873522429, green: 0.4801783562, blue: 0.8375625014, alpha: 1)
        }
        if (indexPath.section == 1){
            if (indexPath.row == 0) {
                cell.sectionLabel.text = VisitorsChartViewControllerConstants.interviewTitle
            } else {
                cell.sectionLabel.text = ""
            }
            cell.dataLabel.text = data
            cell.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8235639408, blue: 0.8712158807, alpha: 1)
        }
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
               cell.sectionLabel.text = VisitorsChartViewControllerConstants.guestVisitTitle
            } else {
               cell.sectionLabel.text = ""
            }
            cell.dataLabel.text = data
            cell.backgroundColor = #colorLiteral(red: 0.8907681206, green: 0, blue: 0.1075288955, alpha: 1)
        }
        if (indexPath.section == 3){
            if (indexPath.row == 0) {
               cell.sectionLabel.text = VisitorsChartViewControllerConstants.otherTitle
            } else {
               cell.sectionLabel.text = ""
            }
            cell.dataLabel.text = data
            cell.backgroundColor = #colorLiteral(red: 0.5014447774, green: 0, blue: 0.5014447774, alpha: 1)
        }
        return cell
    }
}
