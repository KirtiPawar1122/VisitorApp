
import UIKit
import Charts

class VisitorChartViewController: UIViewController {
    

    @IBOutlet weak var histogram: BarChartView!
    @IBOutlet weak var viewUI: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var meetingDateLabel: UILabel!
    @IBOutlet weak var guestVisitLabel: UILabel!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var interviewDateLabel: UILabel!
    var datavisit : [Visit]!
   // var datavisit : [String]!
  //  var visits : [Visit]!
    let purpose = ["Meeting", "Interview", "Guest Visit", "Others"]
    //let data = [1,2,3,0]
    var meeting = 0
    var interview = 0
    var guestVisit = 0
    var other = 0
    var meetingDate = String()
    var interviewDate = String()
    var guestvisitDate = String()
    var otherDate = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(datavisit)
        
        tableview.dataSource = self
        tableview.delegate = self
        tableview.layer.borderWidth = 2
        tableview.layer.borderColor = UIColor.black.cgColor
        
        
        for item in datavisit {
        if item.purpose == "Meeting" {
                meeting = meeting + 1
                //print("Meeting Date :",item.date!)
               // meetingDateLabel.text = item.date
                meetingDate  = item.date!
        } else if item.purpose == "Interview"{
                interview = interview + 1
               // print("Interview Date :",item.date!)
               // interviewDateLabel.text = item.date
               interviewDate = item.date!
               print("Interview Date:", interviewDate)
        } else if item.purpose == "Guest Visit" {
                guestVisit = guestVisit + 1
               // guestVisitLabel.text = item.date
               // print("GuestVisit  Date : ",item.date!)
               guestvisitDate = item.date!
               print("GuestVisit :", guestvisitDate)
        } else if item.purpose == "Others" {
                other = other + 1
              //  otherLabel.text = item.date
              //  print("Others Date :",item.date!)
                otherDate = item.date!
                print("Others")
            }
        }
        print(meeting)
        print(interview)
        print(guestVisit)
        print(other)

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
        barChartDataSet.colors = [UIColor(red: 0/255, green: 76/255, blue: 153/255, alpha: 1)]
      //  barChartDataSet.colors = [UIColor.systemBlue, UIColor.systemYellow, UIColor.purple,UIColor.systemGreen]
        barChartDataSet.colors = ChartColorTemplates.colorful()
        
       /* var colors: [UIColor] = []
        colors.append(UIColor.systemYellow)
        colors.append(UIColor.purple)
        colors.append(UIColor.systemGreen)
        colors.append(UIColor.systemRed)
        barChartDataSet.colors = colors */

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
       // histogram.rightAxis.drawLabelsEnabled = true
       // histogram.rightAxis.axisMinimum = 0
        
        histogram.leftAxis.axisMinimum = 0
       // histogram.leftAxis.axisMaximum = 20
       // histogram.rightAxis.axisMaximum = 20
        histogram.rightAxis.axisMinimum = 0
        histogram.data = barChartData
        
    }
}

extension VisitorChartViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
extension VisitorChartViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rowCount = 0
        if section == 0 {
            rowCount = meeting
        }
        if section == 1 {
            rowCount = interview
        }
        if section == 2{
            rowCount = guestVisit
        }
        if section == 3{
            rowCount = other
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableview.dequeueReusableCell(withIdentifier: "VisitorChartTableViewCell") as! VisitorChartTableViewCell
        cell.meetingLabel.text = meetingDate
        cell.interviewLable.text = interviewDate
        cell.guestvisitLable.text = guestvisitDate
        cell.otherLable.text = otherDate
        return cell
        
    }
}

