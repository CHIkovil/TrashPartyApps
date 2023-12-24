//
//  RunViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 13.10.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//

import UIKit
import AMTabView
import BetterSegmentedControl
import Charts
import MarqueeLabel
import AGCircularPicker
import CoreData
import Foundation
import MapKit

protocol RunViewDelegate: NSObjectProtocol {
    func displayQuote(data: String)
    func hiddenChartButton(value: Bool)
    func displayChartData(data: CombinedChartData)
    func displayTableData()
    func displayBorderColor(value: Bool)
    func displayTransfer()
    func displayCompletedAchieve(name: String)
    func displayRunStatistics(sumWeek: Double, sumMonth: Double)
}

class RunViewController: UIViewController, TabItem {
    
    var enableSwipeNavigation: ((Bool) -> ())?
    
    var runView:RunView!
    var runPresenter:RunPresenter = RunPresenter(runService: RunService())
    
    public var tabImage: UIImage? {
        return UIImage(named: "running.png")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runPresenter.setViewDelegate(runViewDelegate: self)
        runView = RunView(frame: view.frame)
        view.addSubview(runView)
        
        runView.scrollView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(swipingScrollView)))
        runView.runStoreTableView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(swipingTableView)))
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action:  #selector(checkLongPress))
        longPressGesture.minimumPressDuration = 1
        runView.runStoreTableView.addGestureRecognizer(longPressGesture)
        
        runView.formatForChartSwitchView.addTarget(self,
                                                   action: #selector(changeRunActivityChart),
                                                   for: .valueChanged)
        runView.targetBlockSwitchView.addTarget(self,
                                                action: #selector(changeTargetBlock),
                                                for: .valueChanged)
        runView.showValueChartsButton.addTarget(self, action: #selector(showValueChart), for: .allEvents)
        runView.runStartButton.addTarget(self, action: #selector(showRunProcess), for: .touchUpInside)
        runView.runIntervalButton.addTarget(self, action: #selector(addRunInterval), for: .touchUpInside)
        
        runView.scrollView.delegate = self
        runView.runStoreTableView.delegate = self
        runView.runStoreTableView.dataSource = self
        runView.runTargetTimePicker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        runView.scrollView.setContentOffset(.init(x: 0, y: -47), animated: true)
        runPresenter.setQuote()
        runPresenter.setRunStore()
        runPresenter.setChartStore()
        runPresenter.setTableStore()
    }
    
    //MARK: OBJC
    
    @objc func swipingTableView() {
        runView.runStoreTableView.isScrollEnabled = true
        runView.scrollView.isScrollEnabled = false
    }
    
    
    @objc func swipingScrollView() {
        runView.runStoreTableView.isScrollEnabled = false
        runView.scrollView.isScrollEnabled = true
    }
    
    @objc func showValueChart(){
        runPresenter.changeShowValue()
        runPresenter.setSwitchChartData(switchIndex: runView.formatForChartSwitchView.index)
    }
    
    @objc func changeRunActivityChart(){
        runPresenter.setSwitchChartData(switchIndex: runView.formatForChartSwitchView.index)
    }
    
    @objc func changeTargetBlock(){
        if runView.targetBlockSwitchView.index == 0 {
            runView.runTargetTimeBlockView.isHidden = true
            runView.runStoreBlockView.isHidden = false
            runView.runStartButton.alpha = 0.6
            runView.runIntervalLabel.text = "2"
            runView.runTargetTimeLabel.text = "00:00:00"
            runView.runTargetTimePicker.isUserInteractionEnabled = false
            runView.runIntervalButton.isUserInteractionEnabled = false
            runView.runTargetTimeBlockView.gestureRecognizers?.removeAll()
            runPresenter.dropTargetMode()
        }else{
            runView.runTargetTimeBlockView.isHidden = false
            runView.runStoreBlockView.isHidden = true
        }
    }
    
    @objc func checkLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let pointPress = gestureRecognizer.location(in: runView.runStoreTableView)
            let indexPath = runView.runStoreTableView.indexPathForRow(at: pointPress)
            guard let index = indexPath?.section else{return}
            
            runView.runStartButton.alpha = 0.8
            runView.targetBlockSwitchView.setIndex(1)
            runView.runStoreBlockView.isHidden = true
            runView.runTargetTimeBlockView.isHidden = false
            runView.scrollView.setContentOffset(.init(x: 0, y: 7), animated: true)
            runView.runTargetTimePicker.isUserInteractionEnabled = true
            runView.runIntervalButton.isUserInteractionEnabled = true
            
            runPresenter.setFirstStateTargetMode(index: index)
        }
    }
    
    @objc func dragTimeBlock(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state{
        case .began:
            runView.scrollView.isScrollEnabled = false
            runView.scrollView.setContentOffset(.init(x: 0, y: 7), animated: true)
        case .changed:
            let point = gestureRecognizer.translation(in: runView.scrollView)
            if point.y <= 0{
                break
            }
            
            if point.y >= 40{
                runView.runStartButton.alpha = 1
                runPresenter.setSecondStateTargetMode(formatTime: runView.runTargetTimeLabel.text!, countInterval: runView.runIntervalLabel.text!)
                fallthrough
            }
            runView.runTargetTimeBlockView.transform = CGAffineTransform(translationX: 0, y: point.y)
        default:
            runView.runTargetTimeBlockView.gestureRecognizers?.removeAll()
            runView.scrollView.isScrollEnabled = true
            runView.runTargetTimeBlockView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    @objc func addRunInterval(){
        runView.runIntervalLabel.alpha = 0
        UIView.animate(withDuration: 0.5){[weak self] in
            guard let self = self else{return}
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.runView.runIntervalLabel.center.x, y: self.runView.runIntervalLabel.center.y + 20))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.runView.runIntervalLabel.center.x, y: self.runView.runIntervalLabel.center.y))
            self.runView.runIntervalLabel.layer.add(animation, forKey: "position")
            self.runView.runIntervalLabel.text = String(Int(self.runView.runIntervalLabel.text!)! + 1)
            self.runView.runIntervalLabel.alpha = 1
        }
        if Int(self.runView.runIntervalLabel.text!)! == 9 {
            runView.runIntervalButton.isEnabled = false
        }
    }
    
    @objc func showRunProcess(){
        if let _ = runPresenter.getTargetMode(){
            if runView.runTargetTimeLabel.text != "00:00:00"{
                UIView.animate(withDuration: 0.3) {[weak self] in
                    guard let self = self else{return}
                    let animationOne = CABasicAnimation(keyPath: "transform.scale.x")
                    animationOne.repeatCount = 2
                    animationOne.autoreverses = true
                    animationOne.fromValue = 1
                    animationOne.toValue = 1.04
                    self.runView.runTargetTimeBlockView.layer.add(animationOne, forKey: "transform.scale.x")
                    let animationTwo = CABasicAnimation(keyPath: "transform.scale.y")
                    animationTwo.repeatCount = 2
                    animationTwo.autoreverses = true
                    animationTwo.fromValue = 1
                    animationTwo.toValue = 1.04
                    self.runView.runTargetTimeBlockView.layer.add(animationTwo, forKey: "transform.scale.y")
                }
               
            }else{
                UIView.animate(withDuration: 1){[weak self] in
                    guard let self = self else{return}
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.toValue = CGPoint(x: self.runView.runTargetTimeBlockView.center.x, y: self.runView.runTargetTimeBlockView.center.y + 40)
                    self.runView.runTargetTimeBlockView.layer.add(animation, forKey: "position")
                    
                }
                return
            }
        }
        
        let viewController = RunProcessViewController()
        let service = RunProcessService(data: runPresenter.getTargetMode())
        service.transfer = {[weak self] transfer in
            guard let self = self else { return }
            self.runPresenter.setDataTransfer(data: transfer)
        }
        viewController.runProcessPresenter = RunProcessPresenter(runProcessService: service)
        self.present(viewController, animated: true)
    }
}

//MARK: DELEGATE

extension RunViewController: RunViewDelegate{
    
    func displayQuote(data: String) {
        runView.motivationLabel.fadeLength = CGFloat(data.count)
        runView.motivationLabel.text = data
    }
    
    func hiddenChartButton(value: Bool){
        runView.formatForChartSwitchView.setIndex(0)
        runView.showValueChartsButton.layer.borderColor = UIColor.white.cgColor
        runView.showValueChartsButton.isHidden = value
    }
    
    func displayTableData()  {
        runView.targetBlockSwitchView.setIndex(0)
        runView.runTargetTimeBlockView.isHidden = true
        runView.runStoreBlockView.isHidden = false
        self.runView.runStoreTableView.reloadData()
    }
    
    func displayChartData(data: CombinedChartData){
        runView.runActivityChartView.xAxis.valueFormatter = self
        runView.runActivityChartView.xAxis.granularity = 1
        runView.runActivityChartView.xAxis.axisMaximum = data.xMax + 0.45
        runView.runActivityChartView.xAxis.axisMinimum = data.xMin - 0.45
        
        runView.runActivityChartView.data = data
        runView.runActivityChartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    func displayBorderColor(value: Bool){
        if value {
            runView.showValueChartsButton.layer.borderColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 0.9).cgColor
        }else{
            runView.showValueChartsButton.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    func displayTransfer(){
        self.viewDidAppear(true)
    }
    
    func displayCompletedAchieve(name: String){
        runView.achieveImageView.loadGif(name: name)
        UIView.animate(withDuration: 4, animations: {[weak self] in
            guard let self = self else {return}
            self.runView.achieveImageView.isHidden = false
            self.runView.achieveImageView.alpha = 1
        }, completion: {[weak self] _ in
            guard let self = self else {return}
            self.runView.achieveImageView.isHidden = true
            self.runView.achieveImageView.alpha = 0
        })
    }
    
    func displayRunStatistics(sumWeek: Double, sumMonth: Double){
        let data = "In just a week: \(Int(sumWeek))(m) and a month: \(Int(sumMonth))(m)"
        runView.runStatisticsLabel.fadeLength = CGFloat(data.count)
        runView.runStatisticsLabel.text = data
    }
}

extension RunViewController: AGCircularPickerDelegate {
    
    func didChangeValues(_ values: Array<AGColorValue>, selectedIndex: Int) {
        runView.scrollView.isScrollEnabled = false
        runView.runTargetTimeBlockView.gestureRecognizers?.removeAll()
        
        let valueComponents = values.map { return String(format: "%02d", $0.value) }
        let fullString = valueComponents.joined(separator: ":")
        let attributedString = NSMutableAttributedString(string:fullString)
        let fullRange = (fullString as NSString).range(of: fullString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white.withAlphaComponent(0.5), range: fullRange)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold), range: fullRange)
        
        let range = NSMakeRange(selectedIndex * 2 + selectedIndex, 2)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: values[selectedIndex].color, range: range)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.black), range: range)
        
        runView.runTargetTimeLabel.attributedText = attributedString
        
        if fullString != "00:00:00"{
            runView.runTargetTimeBlockView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragTimeBlock)))
            self.enableSwipeNavigation!(false)
        }
        
        self.runView.scrollView.isScrollEnabled = true
        self.enableSwipeNavigation!(true)
    }
}

extension RunViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let tableStore = runPresenter.getTableData() else{
            return 1
        }
        return tableStore.rows.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.clipsToBounds = true
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: "TrebuchetMS", size: 18)
        
        guard let tableStore = runPresenter.getTableData() else{
            cell.backgroundColor = .clear
            cell.textLabel?.text = "Not data"
            cell.textLabel?.textColor = .white
            return cell
        }
        
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 20
        cell.textLabel?.attributedText = tableStore.rows[indexPath.section]
        
        var coordinates = [String]()
        var regionImages = [Data]()
        if let runStore = runPresenter.getRunData(){
            for item in runStore{
                coordinates.append(item.coordinates)
                regionImages.append(item.regionImage)
            }
            if Array(tableStore.palette.keys).contains(coordinates[indexPath.section]) {
                cell.backgroundColor = tableStore.palette[coordinates[indexPath.section]]
            }
        }
        
        let cellImg : UIImageView = UIImageView(frame: CGRect(x: 10, y: 2.5, width: 50, height: 50))
        cellImg.image = UIImage(data: regionImages[indexPath.section])
        cellImg.layer.cornerRadius = 15
        cellImg.layer.masksToBounds = true
        cell.addSubview(cellImg)
        
        let view = UIView()
        view.backgroundColor = .clear
        cell.selectedBackgroundView = view
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let runStore = runPresenter.getRunData(), let tableStore = runPresenter.getTableData() else {
            return
        }
        
        let coordinates:[String] = runStore.map {item in
            return item.coordinates
        }
        
        let coordinates2D: [CLLocationCoordinate2D] = coordinates[indexPath.section].split(separator: ",").map {data in
            let point = data.split(separator: " ")
            let latitude = Double(point[0])
            let longitude = Double(point[1])
            return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        }
        
        let viewController = ProgressMapViewController()
        viewController.progressMapPresenter = ProgressMapPresenter(progressMapService: ProgressMapService(data: Progress(coordinates: coordinates2D, info: tableStore.rows[indexPath.section])))
        
        self.present(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: 0, y: cell.frame.height)
        
        UIView.animate(
            withDuration: 2,
            delay: 0.05 * Double(indexPath.row),
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.1,
            options: [.curveEaseInOut],
            animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
    }
}

//MARK: FORMATTER

extension RunViewController: IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if runView.formatForChartSwitchView.index == 0 {
            return Week.allCases[Int(value) % Week.allCases.count].rawValue
        }
        else{
            return String(Int(value) + 1)
        }
    }
}


