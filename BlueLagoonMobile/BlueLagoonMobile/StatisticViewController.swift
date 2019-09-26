//
//  StatisticViewController.swift
//  BlueLagoonMobile
//
//  Created by Ben Azoulay on 09/05/2018.
//  Copyright © 2018 Benazoulaydev. All rights reserved.
//

import UIKit
import Charts

class StatisticViewController: UIViewController {
    @IBOutlet weak var viewChart: BarChartView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    var weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // #1 Initialize chart
        self.initializeChart()
        
        // #2 Load data to chart
        self.loadDataToChart()
        
    }
    
    func initializeChart() {
        
        viewChart.noDataText = "No Data"
        viewChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        viewChart.xAxis.labelPosition = .bottom
        viewChart.chartDescription?.text = ""
      //  viewChart.xAxis.setLabelsToSkip(0)

        viewChart.legend.enabled = false
        viewChart.scaleYEnabled = false
        viewChart.scaleXEnabled = false
        viewChart.pinchZoomEnabled = false
        viewChart.doubleTapToZoomEnabled = false
        
        viewChart.leftAxis.axisMinimum = 0.0
        viewChart.leftAxis.axisMaximum = 100.00
        viewChart.highlighter = nil
        viewChart.rightAxis.enabled = false
        viewChart.xAxis.drawGridLinesEnabled = false
        
        // add the day in the x axis
        viewChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:weekdays)
        //Also, you probably want to add:
        viewChart.xAxis.granularity = 1
    }
    
    func loadDataToChart() {
        
        APIManager.shared.getDriverRevenue { (json) in
            
            if json != nil {
                
                let revenue = json["revenue"]
                
                var dataEntries: [BarChartDataEntry] = []
                
                for i in 0..<self.weekdays.count
                {
                    let day = self.weekdays[i]
                    let dataentry = BarChartDataEntry(x: Double(i), yValues: [revenue[day].double!])
                    dataEntries.append(dataentry)
                }
                let  chartDataSet = BarChartDataSet(values: dataEntries, label: "Revenue by Day")
                chartDataSet.colors = ChartColorTemplates.material()
                let chartData = BarChartData(dataSet: chartDataSet)
                self.viewChart.data = chartData
               
            }
            
        }
        
    }
   
    
    }

