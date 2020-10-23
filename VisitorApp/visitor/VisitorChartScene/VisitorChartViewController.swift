
import UIKit
import Charts

protocol VisitorChartDisplayLogic {
    func displayChart(viewModel: VisitorChart.VisitorChartData.ViewModel)
}

struct ChartViewControllerConstants{
    static let chartTitle = "Overall Visitors Data Chart"
    static let meetingTitle = "Meeting"
    static let guestVisitTitle = "Guest Visit"
    static let interviewTitle = "Interview"
    static let othersTitle = "Other"
}

class VisitorChartViewController: UIViewController, VisitorChartDisplayLogic {
   
    @IBOutlet weak var chartView: PieChartView!
    var visits = [Visit]()
    var visitData = [Visit]()
    let purpose = ["Meeting", "Guest Visit", "Interview", "Others"]
    var meetings = 0
    var guestvisits = 0
    var interviews = 0
    var others = 0
    var chartRouter: VisitorChartRouter = VisitorChartRouter()
   // var chartInteractor : VisitorChartInteractor = VisitorChartInteractor()
    var chartDataInteractor: VisitorChartDataStore?
    var chartInteractor : VisitorChartBusinessLogic?
   // var chartRouter: VisitorChartDataPassing?
    
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
        //let router = VisitorChartRouter()
        
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
        getChartData()
        displayDataOnChart()
        print(visits.count)
    }
    
    func getChartData(){
        let request = VisitorChart.VisitorChartData.Request()
        chartInteractor?.visitorsChartData(request: request)
    }
    
    func displayChart(viewModel: VisitorChart.VisitorChartData.ViewModel) {
        visitData = viewModel.visitData
    }
       
    func displayDataOnChart(){
        for visit in visits {
            if let purpose = visit.purpose{
                if purpose == ChartViewControllerConstants.meetingTitle{
                      meetings = meetings + 1
                } else if purpose == ChartViewControllerConstants.guestVisitTitle{
                      guestvisits = guestvisits + 1
                } else if purpose == ChartViewControllerConstants.interviewTitle{
                      interviews = interviews + 1
                } else if purpose == ChartViewControllerConstants.othersTitle{
                      others = others + 1
                }
            }
        }
        let total = Double(visits.count)
        var meeting : Double{
            let meetingValue = 100 * Double(meetings) / total
            return meetingValue
        }
        var guestvisit : Double{
            let guestValue = 100 * Double(guestvisits) / total
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
        let data = [meeting, guestvisit, interview, other]
        customizeChart(dataPoints: purpose, values: data)
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
      // 1. Set ChartDataEntry
      var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
        let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            if (dataEntry.y != 0) {
               dataEntries.append(dataEntry)
            }
      }
      // 2. Set ChartDataSet
      let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
      pieChartDataSet.entryLabelColor  = UIColor.white
      pieChartDataSet.entryLabelFont = UIFont(name: "futura", size: 17)
      if let font = UIFont(name: "futura", size: 17) {
            pieChartDataSet.valueFont = font
      } else {
            print("error in to set font")
      }
      var colors: [UIColor] = []
      colors.append(UIColor.systemBlue)
      colors.append(UIColor.purple)
      colors.append(UIColor.systemGreen)
      colors.append(UIColor.systemRed)
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
        
      //4. Assign it to the chart’s data
      chartView.data = pieChartData
    }
}

