//
//  VisitorChartTableViewCell.swift
//  VisitorApp
//
//  Created by Mayur Kamthe on 04/09/20.
//  Copyright © 2020 Mayur Kamthe. All rights reserved.
//

import UIKit

class VisitorChartTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
  

    @IBOutlet var sectionLabel: UILabel!
    @IBOutlet var dataLabel: UILabel!
    
    @IBOutlet var innerTableview: UITableView!
    var data : [String]?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // setUptable()
      //  addSubview()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
        
    func setUptable(){
        innerTableview.delegate = self
        innerTableview.dataSource = self
    }
    
    func addSubview() {
        innerTableview.frame = CGRect(x: innerTableview.frame.origin.x, y: innerTableview.frame.origin.y, width: innerTableview.frame.size.width, height: innerTableview.contentSize.height)
        innerTableview.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
       // return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return data.count // handle nil value
        return data?.count ?? 0
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      //  let cell = tableView.dequeueReusableCell(withIdentifier: "VisitorInnerTableViewCell")!
      //  cell.textLabel?.text = data[indexPath.row]

        let cell = innerTableview.dequeueReusableCell(withIdentifier: "VisitorInnerTableViewCell") as! VisitorInnerTableViewCell
        cell.innerCellLabel.text = data?[indexPath.row]
        return cell
      }
}
