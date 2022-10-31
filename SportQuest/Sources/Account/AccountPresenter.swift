//
//  AccountPresenter.swift
//  SportQuest
//
//  Created by Никита Бычков on 17.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import Charts
import CoreData

class AccountPresenter{
    private let accountService:AccountService
    weak private var accountViewDelegate : AccountViewDelegate?
    
    init(accountService:AccountService){
        self.accountService = accountService
    }
    
    func setViewDelegate(accountViewDelegate:AccountViewDelegate?){
        self.accountViewDelegate = accountViewDelegate
    }
    
    func setUserData(){
        accountService.getUserProgressData {[weak self] data in
            if let self = self, let data = data {
                self.accountViewDelegate?.displayProgressData(data: data)
                self.accountViewDelegate?.displayChartData(data: self.getChartData(values: data.skillsStore))
            }
        }
    }
    
    func getNormDistance() -> String {
        if let normDistance = accountService.normDistance {
            return String(normDistance)
        }else{
            return ""
        }
    }
    
    func updateNormDistance(data: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        request.returnsObjectsAsFaults = false
        let context = appDelegate.persistentContainer.viewContext
    
        if let result = try? context.fetch(request) as? [NSManagedObject] {
            if !result.isEmpty{
                let object = result[0]
                object.setValue(data, forKey: "normDistance")
                try? context.save()
                setUserData()
            }
        }
    }
    
    //MARK: SUPPORT FUNC
    
    func getChartData(values: [Double]) -> RadarChartData{
          let block: (Double) -> RadarChartDataEntry = { value in return RadarChartDataEntry(value: value)}
          let entries = values.map(block)
          
          let set = RadarChartDataSet(entries: entries, label: "")
          set.setColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
          set.fillColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
          
        set.fillAlpha = 0.7
          set.lineWidth = 1
          set.drawHighlightCircleEnabled = true
          set.drawFilledEnabled = true
          set.setDrawHighlightIndicators(false)
       
          let data = RadarChartData()
          data.setValueFont(.systemFont(ofSize: 8, weight: .light))
          data.setDrawValues(true)
          data.dataSets = [set]
            data.setValueTextColor(.clear)
          return data
      }
}
