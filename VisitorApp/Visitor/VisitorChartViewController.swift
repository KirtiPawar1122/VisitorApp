
import UIKit
import Charts

class VisitorChartViewController: UIViewController {
    

    @IBOutlet weak var histogram: BarChartView!
    @IBOutlet weak var viewUI: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var namedataLabel : UILabel!

    var datavisit : [Visit]!
    let purpose = ["Meeting", "Interview", "Guest Visit", "Others"]
    var meeting = 0
    var interview = 0
    var guestVisit = 0
    var other = 0
    var meetingDate = [String]()
    var interviewDate = [String]()
    var guestvisitDate = [String]()
    var otherDate = [String]()
  //  var items : [String :[String]] = [:]
    var items : [[String]] = []
    var sectionName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(datavisit)
         
        tableview.dataSource = self
        tableview.delegate = self
        tableview.layer.borderWidth = 2
        tableview.layer.borderColor = UIColor.black.cgColor
  

      for item in datavisit {
       // print(item.visitors?.value(forKey: "name"))
        namedataLabel.text = "Overall graph represenation of \(item.visitors!.value(forKey: "name"))"
        
        if item.purpose == "Meeting" {
                meeting = meeting + 1
                meetingDate.append(item.date!)
                print(meetingDate)
        } else if item.purpose == "Interview"{
                interview = interview + 1
                interviewDate.append(item.date!)
        } else if item.purpose == "Guest Visit" {
                guestVisit = guestVisit + 1
                guestvisitDate.append(item.date!)
        } else if item.purpose == "Others" {
                other = other + 1
                otherDate.append(item.date!)
        }
        }
        items = [meetingDate,interviewDate,guestvisitDate,otherDate]
       // items = ["Meeting" : meetingDate, "Interview" : interviewDate, "Guestvisit" : guestvisitDate, "Others" : otherDate]
        print(items)
        
        let data = [meeting,interview,guestVisit,other]
        setChart(dataPoints: purpose, values: data.map({ Double($0)}))
       // setChart(dataPoints: purpose, values: Double(data))
        self.navigationItem.title = "Visitor Data Overview"
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
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
        barChartData.barWidth = 0.7
        
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        barChartData.setValueFormatter(formatter)
    
        histogram.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        histogram.xAxis.granularityEnabled = true
        histogram.xAxis.drawGridLinesEnabled = false
        histogram.xAxis.labelPosition = .bottom
        histogram.xAxis.labelFont = UIFont(name: "Arial", size: 17)!
        histogram.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInOutQuart)
        histogram.leftAxis.axisMinimum = 0
        histogram.rightAxis.axisMinimum = 0
        histogram.data = barChartData

    }
}
extension VisitorChartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        //return 50
    }
}
extension VisitorChartViewController: UITableViewDataSource{

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
       // return datavisit.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "VisitorChartTableViewCell") as! VisitorChartTableViewCell
      
        let data = items[indexPath.section][indexPath.row]
        
        let dataitem =  items[indexPath.row]
        print(dataitem.count)
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
               cell.sectionLabel.text = "Meeting"
            } else  {
                cell.sectionLabel.text = ""
            }
            cell.dataLabel.text = data
            cell.backgroundColor = UIColor.red
        }
        
        if (indexPath.section == 1){
          //  let count = items[indexPath.section].count
          //  print(count)
            if (indexPath.row == 0) {
                cell.sectionLabel.text = "Interview"
            } else {
                cell.sectionLabel.text = ""
            }
            cell.dataLabel.text = data
            cell.backgroundColor = UIColor.orange
        }
        
        if (indexPath.section == 2) {
          //  let count = items[indexPath.section].count
          //  print(count)
            if (indexPath.row == 0) {
               cell.sectionLabel.text = "Guest Visit"
            } else {
               cell.sectionLabel.text = ""
            }
            cell.dataLabel.text = data
            cell.backgroundColor = UIColor.systemYellow
        }

        if (indexPath.section == 3){
          //  let count = items[indexPath.section].count
          //  print(count)
            if (indexPath.row == 0) {
               cell.sectionLabel.text = "Others"
            } else {
               cell.sectionLabel.text = ""
            }
            cell.dataLabel.text = data
            cell.backgroundColor = UIColor.systemGreen
        }
    
        return cell
    
    }
}
