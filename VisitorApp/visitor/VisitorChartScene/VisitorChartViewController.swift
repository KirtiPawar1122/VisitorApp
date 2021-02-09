
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
    static let font = "Roboto-Regular"
    static let boldFont = "Roboto-Bold"
    static let defaultFontSize: CGFloat = 17
    static let centerString = "Total Visitors"
    static let centerText1Size: CGFloat = 20
    static let centerText2Size: CGFloat = 40
}

class VisitorChartViewController: UIViewController, VisitorChartDisplayLogic {
   
    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet var tableview: UITableView!
    @IBOutlet var exportButton: UIButton!
    var visits = [Visit]()
    var visitData = [Visit]()
    let purpose = ["Meeting", "Guest Visit", "Interview", "Other"]
    var meetings = 0
    var guestvisits = 0
    var interviews = 0
    var others = 0
    var chartRouter: VisitorChartRouter = VisitorChartRouter()
    var chartDataInteractor: VisitorChartDataStore?
    var chartInteractor : VisitorChartBusinessLogic?
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        getChartData()
        displayDataOnChart()
        setupUI()
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
        chartView.legend.font = UIFont(name: ChartViewControllerConstants.font, size: ChartViewControllerConstants.defaultFontSize)!
        chartView.legend.horizontalAlignment = .center
        chartView.holeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

    }
    
    
    @IBAction func exportData(_ sender: Any) {
        print("in export data")
        let storedUrl = appdelegate.persistentContainer.persistentStoreDescriptions.first?.url
        let fileName = storedUrl!.lastPathComponent
        print(fileName)
        
        let items = [fileName]
        let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            ac.popoverPresentationController?.sourceView = self.exportButton
        }
        present(ac, animated: true, completion: nil)
    }
    
  /*  @objc func exportData(){
        print("in export data")
        let storedUrl = appdelegate.persistentContainer.persistentStoreDescriptions.first?.url
        let fileName = storedUrl!.lastPathComponent
        print(fileName)
        
        let items = [storedUrl]
        let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            ac.popoverPresentationController?.sourceView = exportButton
        }
        present(ac, animated: true, completion: nil)
    } */
    
    func getChartData(){
        let request = VisitorChart.VisitorChartData.Request()
        chartInteractor?.fetchAllData(request: request)
    }
    
    func displayChart(viewModel: VisitorChart.VisitorChartData.ViewModel) {
        visitData = viewModel.visitData
        print(visitData)
        let centerTextStrings = NSMutableAttributedString()
        let centerText1 = NSMutableAttributedString(string: ChartViewControllerConstants.centerString , attributes: [NSAttributedString.Key.font: UIFont(name: ChartViewControllerConstants.font,size:ChartViewControllerConstants.centerText1Size) as Any])
        let centerText2 = NSMutableAttributedString(string: "\n    \(visitData.count)" , attributes: [NSAttributedString.Key.font: UIFont(name: ChartViewControllerConstants.font,size:ChartViewControllerConstants.centerText2Size) as Any])
                  
        centerTextStrings.append(centerText1)
        centerTextStrings.append(centerText2)
        chartView.centerAttributedText = centerTextStrings
        chartView.notifyDataSetChanged()
        
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
                 colors.append(#colorLiteral(red: 0.07873522429, green: 0.4801783562, blue: 0.8375625014, alpha: 1))
        } else if item.label == ChartViewControllerConstants.guestVisitTitle{
                colors.append(#colorLiteral(red: 0.8907681206, green: 0, blue: 0.1075288955, alpha: 1))
        } else if item.label == ChartViewControllerConstants.interviewTitle{
                colors.append(#colorLiteral(red: 0.4745098054, green: 0.8235639408, blue: 0.8712158807, alpha: 1))
        } else if item.label == ChartViewControllerConstants.othersTitle{
                colors.append(#colorLiteral(red: 0.5014447774, green: 0, blue: 0.5014447774, alpha: 1))
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
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = UIColor.clear
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.sectionTitleLabel.font = UIFont(name: ChartViewControllerConstants.boldFont, size: ChartViewControllerConstants.defaultFontSize)
        cell.dataCountLabel.font = UIFont(name: ChartViewControllerConstants.boldFont, size: ChartViewControllerConstants.defaultFontSize)
        cell.sectionTitleLabel.textColor = UIColor.white
        cell.dataCountLabel.textColor = UIColor.white
        cell.sectionTitleLabel.text = data
    
        if indexPath.row == 0 {
            if data == ChartViewControllerConstants.meetingTitle {
            cell.dataCountLabel.text = String(meetings)
            cell.backgroundColor = #colorLiteral(red: 0.07873522429, green: 0.4801783562, blue: 0.8375625014, alpha: 1)
            }
        } else if indexPath.row == 1{
            if data == ChartViewControllerConstants.guestVisitTitle{
                cell.dataCountLabel.text = String(guestvisits)
                cell.backgroundColor = #colorLiteral(red: 0.8907681206, green: 0, blue: 0.1075288955, alpha: 1)
            }
        } else if indexPath.row == 2{
            if data == ChartViewControllerConstants.interviewTitle{
                cell.dataCountLabel.text = String(interviews)
                cell.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8235639408, blue: 0.8712158807, alpha: 1)
            }
        } else if indexPath.row == 3{
            if data == ChartViewControllerConstants.othersTitle{
                cell.dataCountLabel.text = String(others)
                cell.backgroundColor = #colorLiteral(red: 0.5014447774, green: 0, blue: 0.5014447774, alpha: 1)
            }
        }
        return cell
    }
}

