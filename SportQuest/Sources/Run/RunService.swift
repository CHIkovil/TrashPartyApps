//
//  RunService.swift
//  SportQuest
//
//  Created by Никита Бычков on 04.07.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class RunService{
    var quotes:Quotes?
    var runStore: Transfers?
    var chartStore: Chart?
    var tableStore: Table?
    var targetMode: Mode?
    
    func getQuotes(callback: @escaping(Quotes) -> Void)
    {
        let qurl = URL(string: "https://type.fit/api/quotes")!
        let task =  URLSession(configuration: .default).dataTask(with: qurl) {[weak self] (data, response, error) in
            guard let data = data, let self = self else {return}
            DispatchQueue.main.async {
                do
                {
                    let quotes = try JSONDecoder().decode(Quotes.self, from: data)
                    self.quotes = quotes
                    callback(quotes)
                }
                catch
                {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func setRunStore() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RunData")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        request.returnsObjectsAsFaults = false
        let context = appDelegate.persistentContainer.viewContext
        
        var store: Transfers!
        do {
            let result = try context.fetch(request)
            if result.isEmpty{
                return
            }
            
            store = []
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let intervalCurrentMonth = Calendar.current.dateInterval(of: .month, for: Date())
            
            for data in result as! [NSManagedObject] {
                
                let transfer = Transfer(time: data.value(forKey: "time") as! Int, distance: data.value(forKey: "distance") as! Int, coordinates: data.value(forKey: "coordinates") as! String, currentDate: data.value(forKey: "date") as! String, regionImage: data.value(forKey: "regionImage") as! Data)
                
                if intervalCurrentMonth!.contains(dateFormatter.date(from: transfer.currentDate)!) {
                    store.append(transfer)
                }else{
                    context.delete(data)
                }
            }
        } catch {
            return
        }
        
        do {
            if store.count > 0{
                self.runStore = store.reversed()
            }
            try context.save()
        }
        catch{
            return
        }
    }
    
    func getRunData(callback:(Transfers?)->Void) {
        callback(runStore)
     }
    

    func getChartData(callback:(Chart?)->Void) {
        callback(chartStore)
     }
    
    func getNormDistance() -> Int? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        request.returnsObjectsAsFaults = false
        let context = appDelegate.persistentContainer.viewContext
        let result =  try? context.fetch(request) as? [NSManagedObject]
        switch result {
        case let result?:
            if !result.isEmpty{
                return result[0].value(forKey: "normDistance") as? Int
            }else{
                fallthrough
            }
        default:
            return nil
        }
    }
}

