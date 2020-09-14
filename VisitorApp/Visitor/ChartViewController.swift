
import UIKit
import Charts

class ChartViewController: UIViewController {

    @IBOutlet weak var chartView: PieChartView!
    
    var visits : [Visit]!
    let purpose = ["Meeting", "Guest Visit", "Interview", "Others"]
    //let data = [16.0,10.0,13.0,2.0]
    var meetings = 0
    var guestvisits = 0
    var interviews = 0
    var others = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Overall Visitor Chart"
        for visit in visits {
            if let purpose = visit.purpose{
                if purpose == "Meeting"{
                      meetings = meetings + 1
                } else if purpose == "Guest Visit"{
                      guestvisits = guestvisits + 1
                } else if purpose == "Interview"{
                      interviews = interviews + 1
                } else if purpose == "Others"{
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
        dataEntries.append(dataEntry)
      }

      // 2. Set ChartDataSet
      let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
      pieChartDataSet.entryLabelColor  = UIColor.white
      pieChartDataSet.entryLabelFont = UIFont(name: "futura", size: 17)
     // pieChartDataSet.valueFont = UIFont(name: "futura", size: 17)!
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
      
    // 4. Assign it to the chart’s data
      chartView.data = pieChartData
    }
}

