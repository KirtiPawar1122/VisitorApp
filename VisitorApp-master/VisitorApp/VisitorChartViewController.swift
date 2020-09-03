
import UIKit
import Charts

class VisitorChartViewController: UIViewController {
    
    @IBOutlet weak var interviewLabel: UILabel!
    @IBOutlet weak var meetingLabel: UILabel!
    @IBOutlet weak var histogram: BarChartView!
    
    var datavisit : [String]!
    let purpose = ["Meeting", "Interview", "Guest Visit", "Others"]
    //let data = [1,2,3,0]
    var meeting = 0
    var interview = 0
    var guestVisit = 0
    var other = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(datavisit)
        for item in datavisit {
            if item == "Meeting" {
                meeting = meeting + 1
            } else if item == "Interview"{
                interview = interview + 1
            } else if item == "Guest Visit" {
                guestVisit = guestVisit + 1
            } else if item == "Others" {
                other = other + 1
            }
        }
      print(meeting)
      print(interview)
      print(guestVisit)
      print(other)
    
        let data = [meeting,interview,guestVisit,other]
        setChart(dataPoints: purpose, values: data.map({ Double($0)}))
       // setChart(dataPoints: purpose, values: Double(data))
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
       var dataEntries: [BarChartDataEntry] = []
                
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]) ,data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
    
        let barChartDataSet = BarChartDataSet(entries: dataEntries, label: "Visitor Data")
        barChartDataSet.colors = [UIColor(red: 0/255, green: 76/255, blue: 153/255, alpha: 1)]
        
        let barChartData = BarChartData(dataSet: barChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        barChartData.setValueFormatter(formatter)
        histogram.data = barChartData
        histogram.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        histogram.xAxis.granularityEnabled = true
        histogram.xAxis.drawGridLinesEnabled = false
        histogram.xAxis.labelPosition = .bottomInside
        histogram.xAxis.labelFont = UIFont(name: "Futura", size: 15)!
        histogram.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInOutQuart)
        
        histogram.rightAxis.drawLabelsEnabled = true
    }
}

