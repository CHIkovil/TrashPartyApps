//
//  RunView.swift
//  SportQuest
//
//  Created by Никита Бычков on 04.07.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import UIKit
import BetterSegmentedControl
import Charts
import MarqueeLabel
import AGCircularPicker

class RunView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.09030372649, green: 0.09001786262, blue: 0.09877569228, alpha: 1)
        self.addSubview(scrollView)
        
        scrollView.addSubview(backgroundImageView)
        
        scrollView.addSubview(runActivityChartView)
        scrollView.addSubview(runStatisticsLabel)
        scrollView.addSubview(motivationLabel)
        scrollView.addSubview(showValueChartsButton)
        scrollView.addSubview(formatForChartSwitchView)
        scrollView.addSubview(targetBlockSwitchView)
        
        scrollView.addSubview(runStoreBlockView)
        runStoreBlockView.addSubview(runStoreTableView)
        
        scrollView.addSubview(runTargetTimeBlockView)
        runTargetTimeBlockView.addSubview(runTargetTimeLabel)
        runTargetTimeBlockView.addSubview(runTargetTimePicker)
        runTargetTimeBlockView.addSubview(runIntervalLabel)
        runTargetTimeBlockView.addSubview(runIntervalButton)
        
        scrollView.addSubview(runStartButton)
        
        scrollView.addSubview(achieveImageView)
        
        createConstraintsScrollView()
        createConstraintsBackgroundImageView()
        
        createConstraintsAchieveImageView()
        
        createConstraintsRunActivityChartView()
        createConstraintsFormatForChartSwitchView()
        createConstraintsTargetBlockSwitchView()
        createConstraintsMotivationLabel()
        createConstraintsRunStatisticsLabel()
        createConstraintsShowValueChartsButton()
        
        createConstraintsRunStoreBlockView()
        createConstraintsRunStoreTableView()
        
        createConstraintsRunTargetTimeBlockView()
        createConstraintsRunTargetTimeLabel()
        createConstraintsRunTargetTimeView()
        createConstraintsRunStartButton()
        createConstraintsRunIntervalLabel()
        createConstraintsRunIntervalButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize.height = 980
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    lazy var runActivityChartView: CombinedChartView = {
        let chart = CombinedChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.backgroundColor = .clear
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.chartDescription?.enabled = false
        chart.highlightFullBarEnabled = false
        chart.xAxis.labelPosition = .bottom
        chart.noDataText = "Not data"
        chart.noDataFont = UIFont(name: "TrebuchetMS", size: 18)!
        chart.noDataTextColor = .white
        chart.xAxis.labelTextColor = .white
        chart.alpha = 0.8
        return chart
    }()
    
    lazy var formatForChartSwitchView: BetterSegmentedControl = {
        let segmentView = BetterSegmentedControl(frame: CGRect(), segments: LabelSegment.segments(withTitles:["Week","Month"], normalTextColor: .lightGray,
                                                                                                  selectedTextColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.cornerRadius = 20
        segmentView.alpha = 0.8
        segmentView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        segmentView.indicatorViewBackgroundColor = .white
        return segmentView
    }()
    
    lazy var targetBlockSwitchView: BetterSegmentedControl = {
        let segmentView = BetterSegmentedControl(frame: CGRect(), segments: IconSegment.segments(withIcons: [UIImage(named: "cloud.png")!, UIImage(named: "target.png")!],
                                                                                                 iconSize: CGSize(width: 30, height: 30),
                                                                                                 normalIconTintColor: .lightGray,
                                                                                                 selectedIconTintColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.cornerRadius = 20
        segmentView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        segmentView.alpha = 0.8
        segmentView.indicatorViewBackgroundColor = .lightGray
        return segmentView
    }()
    
    lazy var runStoreTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.rowHeight = 55
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        if #available(iOS 15.0, *) {tableView.sectionHeaderTopPadding = 0}
        return tableView
    }()
    
    lazy var runTargetTimePicker:AGCircularPicker = {
        let circularPicker = AGCircularPicker()
        let hourColor1 = UIColor.rgb_color(r: 255, g: 141, b: 0)
        let hourColor2 = UIColor.rgb_color(r: 255, g: 0, b: 88)
        let hourColor3 = UIColor.rgb_color(r: 146, g: 0, b: 132)
        let hourTitleOption = AGCircularPickerTitleOption(title: "Hor")
        let hourValueOption = AGCircularPickerValueOption(minValue: 0, maxValue: 23, rounds: 2, initialValue: 0)
        let hourColorOption = AGCircularPickerColorOption(gradientColors: [hourColor1, hourColor2, hourColor3], gradientAngle: 20)
        let hourOption = AGCircularPickerOption(valueOption: hourValueOption, titleOption: hourTitleOption, colorOption: hourColorOption)
        
        let minuteColor1 = UIColor.rgb_color(r: 255, g: 141, b: 0)
        let minuteColor2 = UIColor.rgb_color(r: 255, g: 0, b: 88)
        let minuteColor3 = UIColor.rgb_color(r: 146, g: 0, b: 132)
        let minuteColorOption = AGCircularPickerColorOption(gradientColors: [minuteColor1, minuteColor2, minuteColor3], gradientAngle: -20)
        let minuteTitleOption = AGCircularPickerTitleOption(title: "Min")
        let minuteValueOption = AGCircularPickerValueOption(minValue: 0, maxValue: 59)
        let minuteOption = AGCircularPickerOption(valueOption: minuteValueOption, titleOption: minuteTitleOption, colorOption: minuteColorOption)
        
        let secondTitleOption = AGCircularPickerTitleOption(title: "Sec")
        let secondColorOption = AGCircularPickerColorOption(gradientColors: [hourColor3, hourColor2, hourColor1])
        let secondOption = AGCircularPickerOption(valueOption: minuteValueOption, titleOption: secondTitleOption, colorOption: secondColorOption)
        
        circularPicker.options = [hourOption, minuteOption, secondOption]
        circularPicker.translatesAutoresizingMaskIntoConstraints = false
        circularPicker.isUserInteractionEnabled = false
        circularPicker.alpha = 0.9
        return circularPicker
    }()
    
    lazy var runTargetTimeBlockView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.clear.cgColor
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        view.isHidden = true
        view.layer.cornerRadius = 25
        view.alpha = 0.65
        return view
    }()
    
    lazy var runStoreBlockView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        view.isHidden = false
        view.layer.cornerRadius = 25
        view.alpha = 0.65
        return view
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.loadGif(name: "time")
        imageView.alpha = 0.5
        return imageView
    }()
    
    lazy var achieveImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.masksToBounds = true
        imageView.alpha = 0
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var motivationLabel:MarqueeLabel = {
        let text = "When you’re riding, only the race in which you’re riding is important."
        let label = MarqueeLabel(frame: CGRect(), duration: 8.0, fadeLength: CGFloat(text.count))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = label.font.withSize(20)
        label.textColor = .white
        label.alpha = 0.9
        return label
    }()
    
    lazy var runStatisticsLabel:MarqueeLabel = {
        let text = "Soon.."
        let label = MarqueeLabel(frame: CGRect(), duration: 8.0, fadeLength: CGFloat(text.count))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = label.font.withSize(20)
        label.textColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 0.9)
        return label
    }()
    
    lazy var runTargetTimeLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        label.text = "00:00:00"
        return label
    }()
    
    lazy var runIntervalLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2"
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: 25, weight: UIFont.Weight.bold)
        return label
    }()
    
    lazy var showValueChartsButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("value", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.isHidden = true
        button.alpha = 0.85
        return button
    }()
    
    lazy var runStartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = .clear
        button.frame = CGRect(x: 0, y: 0 , width: 110, height: 110)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"flame.png"), for: .normal)
        button.layer.borderWidth = 2
        button.alpha = 0.6
        return button
    }()
    
    lazy var runIntervalButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.frame = CGRect(x: 0, y: 0 , width: 30, height: 30)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.isUserInteractionEnabled = false
        button.setImage(UIImage(named:"plus.png"), for: .normal)
        button.alpha = 0.9
        return button
    }()
    

    
    // MARK: CONSTRAINTS
    
    func createConstraintsScrollView() {
        scrollView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func createConstraintsRunActivityChartView() {
        runActivityChartView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: scrollView.topAnchor, constant:65).isActive = true
        runActivityChartView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        runActivityChartView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 300).isActive = true
        runActivityChartView.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    func createConstraintsFormatForChartSwitchView() {
        formatForChartSwitchView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: motivationLabel.bottomAnchor, constant: 10).isActive = true
        formatForChartSwitchView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        formatForChartSwitchView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 45).isActive = true
        formatForChartSwitchView.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    func createConstraintsTargetBlockSwitchView() {
        targetBlockSwitchView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: formatForChartSwitchView.bottomAnchor, constant: 10).isActive = true
        targetBlockSwitchView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        targetBlockSwitchView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 45).isActive = true
        targetBlockSwitchView.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    func createConstraintsRunStoreTableView() {
        runStoreTableView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: runStoreBlockView.topAnchor).isActive = true
        runStoreTableView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: runStoreBlockView.bottomAnchor).isActive = true
        runStoreTableView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: runStoreBlockView.leadingAnchor).isActive = true
        runStoreTableView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: runStoreBlockView.trailingAnchor).isActive = true
        
    }
    
    func createConstraintsRunTargetTimeView() {
        runTargetTimePicker.safeAreaLayoutGuide.topAnchor.constraint(equalTo: runTargetTimeLabel.bottomAnchor, constant: -5).isActive = true
        runTargetTimePicker.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: runTargetTimeBlockView.centerXAnchor).isActive = true
        runTargetTimePicker.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 125).isActive = true
        runTargetTimePicker.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.77).isActive = true
    }

    func createConstraintsRunStoreBlockView() {
        runStoreBlockView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: targetBlockSwitchView.bottomAnchor, constant: 10).isActive = true
        runStoreBlockView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        runStoreBlockView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 180).isActive = true
        runStoreBlockView.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.77).isActive = true
    }
    
    func createConstraintsRunTargetTimeBlockView() {
        runTargetTimeBlockView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: targetBlockSwitchView.bottomAnchor, constant: 10).isActive = true
        runTargetTimeBlockView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        runTargetTimeBlockView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 180).isActive = true
        runTargetTimeBlockView.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.77).isActive = true
    }
    
     func createConstraintsBackgroundImageView() {
         backgroundImageView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
         backgroundImageView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
         backgroundImageView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -250).isActive = true
         backgroundImageView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:  250).isActive = true
     }
    
     func createConstraintsAchieveImageView() {
         achieveImageView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -100).isActive = true
         achieveImageView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -35).isActive = true
         achieveImageView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 150).isActive = true
         achieveImageView.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 150).isActive = true
     }

    func createConstraintsRunStatisticsLabel() {
        runStatisticsLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: runActivityChartView.bottomAnchor, constant: 10).isActive = true
        runStatisticsLabel.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: runActivityChartView.centerXAnchor).isActive = true
        runStatisticsLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 25).isActive = true
        runStatisticsLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.75).isActive = true
    }
    
    func createConstraintsMotivationLabel() {
        motivationLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: runStatisticsLabel.bottomAnchor, constant: 10).isActive = true
        motivationLabel.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: targetBlockSwitchView.centerXAnchor).isActive = true
        motivationLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 25).isActive = true
        motivationLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.75).isActive = true
    }
    
    func createConstraintsRunTargetTimeLabel() {
        runTargetTimeLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: runTargetTimeBlockView.topAnchor, constant: 10).isActive = true
        runTargetTimeLabel.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: runTargetTimeBlockView.centerXAnchor).isActive = true
        runTargetTimeLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 200).isActive = true
        runTargetTimeLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func createConstraintsRunIntervalLabel() {
        runIntervalLabel.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: runIntervalButton.leadingAnchor).isActive = true
        runIntervalLabel.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: runTargetTimeLabel.centerYAnchor).isActive = true
        runIntervalLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 20).isActive = true
        runIntervalLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func createConstraintsShowValueChartsButton() {
        showValueChartsButton.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: runActivityChartView.topAnchor, constant: -7).isActive = true
        showValueChartsButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 20).isActive = true
        showValueChartsButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 50).isActive = true
        showValueChartsButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: runActivityChartView.trailingAnchor,constant: -10).isActive = true
    }
    
    func createConstraintsRunStartButton() {
        runStartButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: runStoreBlockView.bottomAnchor, constant: 10).isActive = true
        runStartButton.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        runStartButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 110).isActive = true
        runStartButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 110).isActive = true
    }
    
    func createConstraintsRunIntervalButton() {
        runIntervalButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: runTargetTimeBlockView.trailingAnchor, constant: -10).isActive = true
        runIntervalButton.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: runTargetTimeLabel.centerYAnchor).isActive = true
        runIntervalButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 30).isActive = true
        runIntervalButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
}
