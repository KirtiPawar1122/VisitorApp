
import UIKit
import Charts
import FirebaseFirestore
import FirebaseDatabase

protocol VisitorChartDisplayLogic {
    func displayPercenatageDataOnChart(viewModel: VisitorChart.FetchVisitorPurposeType.ViewModel)
    func displayVisitorChartData(viewModel: VisitorChart.DisplayVisitorData.viewModel)
}

struct ChartViewControllerConstants{
    static let chartTitle = "Overall Visitors Data Chart"
    static let meetingTitle = "Meeting"
    static let guestVisitTitle = "Guest Visit"
    static let interviewTitle = "Interview"
    static let othersTitle = "Other"
    static let font = "Roboto-Regular"
    static let boldFont = "Roboto-Bold"
    static let defaultFontSize: CGFloat = 17
    static let centerString = "Total Visitors"
    static let chartNoDataString = "Loding..."
    static let centerText1Size: CGFloat = 20
    static let centerText2Size: CGFloat = 40
    static let meetingColor = UIColor(red: 20.0/255.0, green: 122.0/255, blue: 214.0/255, alpha: 1)
    static let interviewColor = UIColor(red: 121.0/255.0, green: 210.0/255, blue: 222.0/255, alpha: 1)
    static let guestColor = UIColor(red: 227.0/255.0, green: 0.0/255, blue: 27.0/255, alpha: 1)
    static let otherVisitColor = UIColor(red: 128.0/255.0, green: 0.0/255, blue: 128.0/255, alpha: 1)
}

class VisitorChartViewController: UIViewController, VisitorChartDisplayLogic {
  
    
    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet var tableview: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var visits = [Visit]()
    var visitData = [Visit]()
    var visitChartData = [VisitorChartDataModel]()
    let purpose = ["Meeting", "Guest Visit", "Interview", "Other"]
    var meetings = 0
    var guestVisits = 0
    var interviews = 0
    var others = 0
    var chartRouter: VisitorChartRouter = VisitorChartRouter()
    var chartDataInteractor: VisitorChartDataStore?
    var chartInteractor : VisitorChartBusinessLogic?
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var ref = DatabaseReference.init()
    let db = Firestore.firestore()
    var visitorData = [DisplayData]()
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
        let interactor = VisitorChartInteractor()
        let presenter = VisitorChartPresenter()
        viewController.chartRouter = chartRouter
        viewController.chartInteractor = interactor
        viewController.chartDataInteractor = interactor
        interactor.data = visits
        interactor.presenter = presenter
        presenter.viewObj = viewController

    }
      
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ChartViewControllerConstants.chartTitle
        self.ref = Database.database().reference()
        setupUI()
        //getChartData()
        //displayChartData()
        getVisitorChartData()
    }

    func setupUI(){
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = .clear
        tableview.layer.borderColor = UIColor.white.cgColor
        tableview.layer.borderWidth = 2
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        chartView.legend.enabled = true
        chartView.legend.textColor = UIColor.black
        chartView.legend.orientation = .horizontal
        chartView.legend.font = UIFont(name: ChartViewControllerConstants.font, size: ChartViewControllerConstants.defaultFontSize) ?? UIFont()
        chartView.legend.horizontalAlignment = .center
        chartView.holeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        chartView.noDataText = ChartViewControllerConstants.chartNoDataString
        chartView.noDataFont = UIFont(name: ChartViewControllerConstants.boldFont, size: ChartViewControllerConstants.defaultFontSize) ?? UIFont()
    }
    
    func getChartData(){
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
             self.chartInteractor?.getVisitPurposeType(request: VisitorChart.FetchVisitorPurposeType.Request())
        }
    }
    
    func getVisitorChartData(){
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            self.chartInteractor?.getVisitorsAllData(request: VisitorChart.DisplayVisitorData.Request())
        }
    }
    
    func displayVisitorChartData(viewModel: VisitorChart.DisplayVisitorData.viewModel) {
        print(viewModel.visitorData)
        let chartData = viewModel.visitorData
        for item in chartData{
            if "Meeting" == item.purspose{
                meetings = meetings + 1
                //print("Meeting: " ,meetings)
            } else if "Interview" == item.purspose{
                interviews = interviews + 1
                //print("IN:",interviews)
            } else if "Guest Visit" == item.purspose{
                guestVisits = guestVisits + 1
                //print("GV:", guestVisits)
            } else if "Other" == item.purspose  {
                others = others + 1
                print("OH:",others)
            } else {
                others = others + 1
                print(item.purspose)
            }
        }
        let total = Double(chartData.count)
        var meeting : Double{
            let meetingValue = 100 * Double(meetings) / total
            return meetingValue
        }
        var interview : Double{
            let interviewValue = 100 * Double(interviews) / total
            return interviewValue
        }
        var guestVisit : Double{
            let guestValue = 100 * Double(guestVisits) / total
            return guestValue
        }
        var other : Double{
            let otherValue = 100 * Double(others) / total
            return otherValue
        }
        
        DispatchQueue.main.async {
            let data = [meeting,guestVisit,interview,other]
            self.customizeChart(dataPoints: self.purpose, values: data)
            
            let centerTextStrings = NSMutableAttributedString()
            let centerText1 = NSMutableAttributedString(string: ChartViewControllerConstants.centerString , attributes: [NSAttributedString.Key.font: UIFont(name: ChartViewControllerConstants.font,size:ChartViewControllerConstants.centerText1Size) as Any])
            let centerText2 = NSMutableAttributedString(string: "\n    \(chartData.count)" , attributes: [NSAttributedString.Key.font: UIFont(name: ChartViewControllerConstants.font,size:ChartViewControllerConstants.centerText2Size) as Any])
                             
            centerTextStrings.append(centerText1)
            centerTextStrings.append(centerText2)
            self.chartView.centerAttributedText = centerTextStrings
            self.chartView.notifyDataSetChanged()
            self.tableview.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func displayPercenatageDataOnChart(viewModel:
        VisitorChart.FetchVisitorPurposeType.ViewModel) {
        let data = viewModel.visitTypes
        for item in data{
            if VisitPurpose.meeting == item.visitPurpose{
                meetings = item.purposeCount
            } else if VisitPurpose.guestVisit == item.visitPurpose{
                guestVisits = item.purposeCount
            } else if VisitPurpose.interview == item.visitPurpose{
                interviews = item.purposeCount
            } else if VisitPurpose.other == item.visitPurpose{
                others = item.purposeCount
            }
        }
        let total = Double(viewModel.totalVisitCount)
        var meeting : Double{
            let meetingValue = 100 * Double(meetings) / total
            return meetingValue
        }
        var guestVisit : Double{
            let guestValue = 100 * Double(guestVisits) / total
            return guestValue
        }
        var interview : Double{
            let interviewValue = 100 * Double(interviews) / total
            return interviewValue
        }
        var other : Double{
            let otherValue = 100 * Double(others) / total
            return otherValue
        }
        
        DispatchQueue.main.async {
            let data = [meeting,guestVisit,interview,other]
            self.customizeChart(dataPoints: self.purpose, values: data)
            
            let centerTextStrings = NSMutableAttributedString()
            let centerText1 = NSMutableAttributedString(string: ChartViewControllerConstants.centerString , attributes: [NSAttributedString.Key.font: UIFont(name: ChartViewControllerConstants.font,size:ChartViewControllerConstants.centerText1Size) as Any])
            let centerText2 = NSMutableAttributedString(string: "\n    \(viewModel.totalVisitCount)" , attributes: [NSAttributedString.Key.font: UIFont(name: ChartViewControllerConstants.font,size:ChartViewControllerConstants.centerText2Size) as Any])
                             
            centerTextStrings.append(centerText1)
            centerTextStrings.append(centerText2)
            self.chartView.centerAttributedText = centerTextStrings
            self.chartView.notifyDataSetChanged()
            self.tableview.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
 
    func customizeChart(dataPoints: [String], values: [Double]) {
        
      // 1. Set ChartDataEntry
      var dataEntries: [PieChartDataEntry] = []
        for i in 0..<dataPoints.count {
        let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
        if (dataEntry.y != .zero) {
               dataEntries.append(dataEntry)
            }
      }
      // 2. Set ChartDataSet
      let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        
      pieChartDataSet.entryLabelColor  = UIColor.white
        pieChartDataSet.entryLabelFont = UIFont(name: ChartViewControllerConstants.font, size: ChartViewControllerConstants.defaultFontSize)
        if let font = UIFont(name: ChartViewControllerConstants.font, size: ChartViewControllerConstants.defaultFontSize) {
            pieChartDataSet.valueFont = font
      } else {
            print("error in to set font")
      }
        
      var colors: [UIColor] = []
      for item in dataEntries {
        if item.label == ChartViewControllerConstants.meetingTitle{
            colors.append(ChartViewControllerConstants.meetingColor)
        } else if item.label == ChartViewControllerConstants.guestVisitTitle{
                colors.append(ChartViewControllerConstants.guestColor)
        } else if item.label == ChartViewControllerConstants.interviewTitle{
                colors.append(ChartViewControllerConstants.interviewColor)
        } else if item.label == ChartViewControllerConstants.othersTitle{
                colors.append(ChartViewControllerConstants.otherVisitColor)
        }
      }
      pieChartDataSet.colors = colors
      
            // 3. Set ChartData
      let pieChartData = PieChartData(dataSet: pieChartDataSet)
      let format = NumberFormatter()
      format.numberStyle = .percent
      format.multiplier = 1.0
      format.allowsFloats = true
      format.maximumFractionDigits = 2

      let formatter = DefaultValueFormatter(formatter: format)
      pieChartData.setValueFormatter(formatter)
      pieChartData.setValueTextColor(.white)
        
      //4. Assign it to the chart’s data
      chartView.data = pieChartData
    }
}

extension VisitorChartViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
}

extension VisitorChartViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purpose.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "VisitorPieChartTableViewCell", for: indexPath) as! VisitorPieChartTableViewCell
        let data = purpose[indexPath.row]
        cell.sectionTitleLabel.text = data
        if indexPath.row == 0 {
            if data == ChartViewControllerConstants.meetingTitle {
            cell.dataCountLabel.text = String(meetings)
            cell.backgroundColor = ChartViewControllerConstants.meetingColor
            }
        } else if indexPath.row == 1{
            if data == ChartViewControllerConstants.guestVisitTitle{

                cell.dataCountLabel.text = String(guestVisits)
                cell.backgroundColor = ChartViewControllerConstants.guestColor

            }
        } else if indexPath.row == 2{
            if data == ChartViewControllerConstants.interviewTitle{
                cell.dataCountLabel.text = String(interviews)
                cell.backgroundColor = ChartViewControllerConstants.interviewColor
            }
        } else if indexPath.row == 3{
            if data == ChartViewControllerConstants.othersTitle{
                cell.dataCountLabel.text = String(others)
                cell.backgroundColor = ChartViewControllerConstants.otherVisitColor
            }
        }
        return cell
    }
}

