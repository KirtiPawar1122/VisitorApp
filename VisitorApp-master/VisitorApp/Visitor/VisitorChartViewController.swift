
import UIKit
import Charts

class VisitorChartViewController: UIViewController {
    

    @IBOutlet weak var histogram: BarChartView!
    @IBOutlet weak var viewUI: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var namedataLabel : UILabel!

    var datavisit : [Visit]!
   // var datavisit : [String]!
   // var visits : [Visit]!
    let purpose = ["Meeting", "Interview", "Guest Visit", "Others"]
    //let data = [1,2,3,0]
    var meeting = 0
    var interview = 0
    var guestVisit = 0
    var other = 0
    var meetingDate = [String]()
    var interviewDate = [String]()
    var guestvisitDate = [String]()
    var otherDate = [String]()
    var items : Array<Array<String>> = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(datavisit)
        
        
       // namedataLabel.text = "\(String(describing: datavisit[0].visitors?.value(forKey: "name")))! Visitor Data"

        
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

extension VisitorChartViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
extension VisitorChartViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return purpose.count
       return 4
    }
    
 /*   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return purpose[section]
    } */
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
      //  return purpose.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "VisitorChartTableViewCell") as! VisitorChartTableViewCell
        let data = items[indexPath.section][indexPath.row]
       // print(data)
        cell.dataLabel.text = data
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: view.frame.size.width, height: 25))
        label.text = self.purpose[section]
        label.textColor = .black
        returnedView.addSubview(label)
        
        switch section {
        case 0:
            returnedView.backgroundColor = .red
        case 1:
            returnedView.backgroundColor = .orange
    
        case 2 :
            returnedView.backgroundColor = .systemYellow
            
        case 3 :
            returnedView.backgroundColor = .systemGreen
           
        default:
            returnedView.backgroundColor = .lightGray
        }
        
        return returnedView
    }
}

