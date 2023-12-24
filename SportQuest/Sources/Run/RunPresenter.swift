//
//  RunPresenter.swift
//  SportQuest
//
//  Created by Никита Бычков on 04.07.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import Charts
import UIKit

class RunPresenter {    
    private let runService:RunService
    weak private var runViewDelegate : RunViewDelegate?
    
    init(runService:RunService){
        self.runService = runService
    }
    
    func setViewDelegate(runViewDelegate:RunViewDelegate){
        self.runViewDelegate = runViewDelegate
    }
    
    func setQuote() {
        runService.getQuotes {[weak self] data in
            guard let self = self else{return}
            if let randomquote = data.randomElement()
            {
                let text = randomquote.text.trimmingCharacters(in: .whitespaces)
                self.runViewDelegate?.displayQuote(data: text)
            }
        }
    }
    
    func setRunStore() {
        runService.setRunStore()
    }
    
    func setChartStore() {
        runService.getRunData {[weak self] data in
            guard let self = self, let store = data else{return}
            
            let calendar = Calendar.current
            let date = calendar.date(byAdding: .hour, value: 3, to: Date())
            let currentWeek = getDays(dateInterval: Calendar.current.dateInterval(of: .weekOfMonth,for: date!)!)
            
            var daysMonth = Calendar.current.dateInterval(of: .month,for:date!)!
            let newStartDay = Calendar.current.date(byAdding: .day, value: -1, to: daysMonth.start)!
            daysMonth.start = newStartDay
            let currentMonth = getDays(dateInterval: daysMonth)
            
            var dates:[String] = []
            var distances:[Int] = []
            for item in store{
                dates.append(item.currentDate)
                distances.append(item.distance)
            }
            
            let group = DispatchGroup()
            let queue = DispatchQueue.global(qos: .userInitiated)
            
            var weekData: [Double]!
            queue.async(group: group) {
                var data: [Double] = []
                for date in currentWeek {
                    if dates.contains(date) {
                        let result = distances.enumerated().filter({dates[$0.offset] == date}).map({$0.element}).reduce(0, +)
                        data.append(Double(result))
                    } else {
                        data.append(0)
                    }
                }
                weekData = data
            }
            
            var monthData: [Double]!
            queue.async(group: group) {
                var data: [Double] = []
                for date in currentMonth {
                    if dates.contains(date) {
                        let result = distances.enumerated().filter({dates[$0.offset] == date}).map({$0.element}).reduce(0, +)
                        data.append(Double(result))
                    } else {
                        data.append(0)
                    }
                }
                monthData = data
            }
            
            group.notify(queue: .main) {[weak self] in
                guard let self = self else{return}
                self.runService.chartStore = Chart(week: weekData, month: monthData, showValue: false)
                self.setSwitchChartData(switchIndex: 0)
                self.runViewDelegate?.displayRunStatistics(sumWeek: weekData.reduce(0, +), sumMonth: monthData.reduce(0, +))
                self.runViewDelegate?.hiddenChartButton(value: false)
            }
        }
    }
    
    func setTableStore(){
        runService.getRunData {[weak self] data in
            guard let store = data else{return}
            
            var dates:[String] = []
            var distances:[String] = []
            var times:[String] = []
            var coordinates:[String] = []
            
            for item in store{
                dates.append(item.currentDate)
                distances.append(String(item.distance))
                times.append(String(item.time))
                coordinates.append(item.coordinates)
            }
            
            let group = DispatchGroup()
            let queue = DispatchQueue.global(qos: .userInitiated)
            
            var paletteStore:[String:UIColor]!
            queue.async(group: group) {
                let uniqueCoordinates = Set(coordinates)
                var palette = [String:UIColor]()
                for coordinates in uniqueCoordinates{
                    palette[coordinates] = UIColor.random()
                }
                paletteStore = palette
            }
            
            var tableStore:[NSMutableAttributedString]!
            queue.async(group: group) {
                var rows: [NSMutableAttributedString] = []
                for index in 0..<store.count {
                    let distance = String(distances[index])
                    let time = String(times[index])
                    let data = distance + " " + time + " " + dates[index]
                    let mutableString = NSMutableAttributedString.init(string: data)
                    mutableString.setAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)], range: (mutableString.string as NSString).range(of: distance))
                    mutableString.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], range: (mutableString.string as NSString).range(of: time))
                    mutableString.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], range: (mutableString.string as NSString).range(of: dates[index]))
                    rows.append(mutableString)
                }
                tableStore = rows
            }
            
            group.notify(queue: .main) {[weak self] in
                guard let self = self else{return}
                self.runService.tableStore = Table(rows: tableStore, palette: paletteStore)
                self.runViewDelegate?.displayTableData()
            }
        }
    }
    
    func setSwitchChartData(switchIndex: Int) {
        runService.getChartData {[weak self] data in
            guard let store = data else{return}
            var storeData = [Double]()
            if switchIndex == 0{
                storeData = store.week
            }else{
                storeData = store.month
            }
            var actualNormDistance: Int
            if let normDistance = runService.getNormDistance(){
                actualNormDistance = normDistance
            }else{
                actualNormDistance = 0
            }
            
            let group = DispatchGroup()
            let queue = DispatchQueue.global(qos: .userInteractive)
            
            let data = CombinedChartData()
            
            var lineData:LineChartData!
            queue.async(group: group) {[weak self] in
                guard let self = self else{return}
                lineData = self.getLineData(dataForCharts: storeData)
            }
            
            var barData:BarChartData!
            queue.async(group: group) {[weak self] in
                guard let self = self else{return}
                barData = self.getBarData(dataForCharts: storeData, actualNormDistance: actualNormDistance)
            }
            
            group.notify(queue: .main) {[weak self] in
                guard let self = self else{return}
                data.lineData = lineData
                data.barData = barData
                self.runViewDelegate?.displayChartData(data: data)
            }
        }
        
    }
    
    func changeShowValue() {
        runService.getChartData {[weak self] data in
            guard let self = self, let store = data else{return}
            runService.chartStore!.showValue = !store.showValue
            self.runViewDelegate?.displayBorderColor(value: runService.chartStore!.showValue)
        }
    }
    
    func dropTargetMode() {
        runService.targetMode = nil
    }
    
    func setFirstStateTargetMode(index: Int){
        runService.getRunData {[weak self] data in
            guard let self = self, let store = data else{return}
            var distances:[Int] = []
            var coordinates:[String] = []
            
            for item in store{
                distances.append(item.distance)
                coordinates.append(item.coordinates)
            }
            
            self.runService.targetMode = Mode(distance: distances[index], coordinates: coordinates[index])
        }
    }
    
    func setSecondStateTargetMode(formatTime:String, countInterval:String){
        runService.targetMode?.time = formatTime
        runService.targetMode?.countInterval = countInterval
    }
    
    func setDataTransfer(data: Transfer){
        runService.getRunData {[weak self] store in
            guard let self = self else{return}
            if store == nil {
                runService.runStore = [data]
                
            }
            runService.runStore!.insert(data, at: 0)
            checkCompletedAchieve(distance: data.distance)
            self.runViewDelegate?.displayTransfer()
        }
    }
    
    func getTargetMode() -> Mode?{
        switch runService.targetMode {
        case let mode?:
            if mode.checkAllData(){
                return mode
            }else{
                fallthrough
            }
        default:
            return nil
        }
    }
    
    func getTableData() -> Table?{
        return runService.tableStore
    }

    func getRunData() -> Transfers?{
        return runService.runStore
    }
    
    func checkCompletedAchieve(distance: Int){
        if distance > 100 {
            if UserDefaults.standard.string(forKey: "achieve1") == nil{
                UserDefaults.standard.set("First 100m", forKey: "achieve1")
                runViewDelegate?.displayCompletedAchieve(name: "achieve1")
            }
        }
    
    }
    
    //MARK: SUPPORT FUNC
    
    private func getDays(dateInterval: DateInterval) -> [String] {
        var dates: [String] = []
        Calendar.current.enumerateDates(startingAfter: dateInterval.start,
                                        matching: DateComponents(hour:0),
                                        matchingPolicy: .nextTime) { date, _, stop in
                                            guard let date = date else {
                                                return
                                            }
                                            if date <= dateInterval.end {
                                                let dateFormatter = DateFormatter()
                                                dateFormatter.dateFormat = "dd-MM-yyyy"
                                                dates.append(dateFormatter.string(from: date))
                                            } else {
                                                stop = true
                                            }
        }
        return dates
    }
    
    private func getLineData(dataForCharts:[Double]) -> LineChartData {
        let entries: [ChartDataEntry];
        entries = (0..<dataForCharts.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: dataForCharts[i] / 2)
        }
        
        let set = LineChartDataSet(entries: entries, label: "")
        set.setColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        set.lineWidth = 4
        set.setCircleColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        set.circleRadius = 0
        set.circleHoleRadius = 2.5
        set.fillColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        set.mode = .cubicBezier
        set.valueFont = .systemFont(ofSize: 0)
        
        if runService.chartStore!.showValue{
            set.drawValuesEnabled = true
        }else {
            set.drawValuesEnabled = false
        }
        set.valueTextColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        set.axisDependency = .left
        
        return LineChartData(dataSet: set)
    }
    
    private func getBarData(dataForCharts: [Double],  actualNormDistance: Int) -> BarChartData {
        let entries: [ChartDataEntry];
        entries = (0..<dataForCharts.count).map { (i) -> BarChartDataEntry in
            let remainNormDistance = Double(actualNormDistance) - dataForCharts[i]
            
            var dataNormDistance: Double
            if remainNormDistance > 0 && dataForCharts[i] > 0{
                dataNormDistance = remainNormDistance
            }else{
                dataNormDistance = 0
            }
            return BarChartDataEntry(x: Double(i), yValues: [dataForCharts[i], dataNormDistance])
        }
        
        let set = BarChartDataSet(entries: entries, label: "")

        set.colors = [UIColor(red: 61/255, green: 165/255, blue: 255/255, alpha: 1),
                      UIColor(red: 23/255, green: 197/255, blue: 255/255, alpha: 0.3)
        ]
        set.valueTextColor = .white
        set.valueFont = .systemFont(ofSize: 11)
        if runService.chartStore!.showValue {
            set.drawValuesEnabled = true
        }else {
            set.drawValuesEnabled = false
        }
        set.axisDependency = .left
        
        let data =  BarChartData()
        data.dataSets = [set]
        data.barWidth = 0.9
        
        return data
    }
}

private extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

private extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   .random(),
            green: .random(),
            blue:  .random(),
            alpha: 0.85
        )
    }
}
