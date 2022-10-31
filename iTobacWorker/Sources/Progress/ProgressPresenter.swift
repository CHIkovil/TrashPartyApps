//
//  ProgressPresenter.swift
//  iTobacWorker
//
//  Created by Nikolas on 07.12.2021.
//

import CoreData
import UIKit

//MARK: DELEGATE

protocol ProgressStoreDelegate: AnyObject {
    func saveUserData(_ data: UserData)
    func loadUserData()
}

protocol ProgressRecalculateDelegate: AnyObject {
    func recalculateGraphData(newValue: Int, _ data: GraphData)
}

//MARK: STRING

private enum ProgressPresenterString: String {
    case entityName = "UserData"
    case imageValueKey = "image"
    case cigaretteProgressValueKey = "cigaretteProgress"
    case moneyProgressValueKey = "moneyProgress"
    case datesValueKey = "dates"
}

class ProgressPresenter
{
    weak private var progressViewDelegate : ProgressViewDelegate?
    
    init(delegate:ProgressViewDelegate){
        self.progressViewDelegate = delegate
    }
    
    private func requestUserData(callback: @escaping(NSManagedObject?) -> Void){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ProgressPresenterString.entityName.rawValue)
        request.returnsObjectsAsFaults = false
        
        let result = (try? context.fetch(request) as? [NSManagedObject])?.first
        callback(result)
    }
    
    private func clearUserDataStore() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: ProgressPresenterString.entityName.rawValue)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            appDelegate.saveContext()
        } catch _ as NSError {
            // TODO: handle the error
        }
    }
}


//MARK: ProgressStoreDelegate
extension ProgressPresenter: ProgressStoreDelegate{
    
    func loadUserData() {
        requestUserData() {[weak self] result in
            guard let self = self else {return}
        
            var data:UserData!
            
            switch result{
            case (let result?):
                if let image = result.value(forKey: ProgressPresenterString.imageValueKey.rawValue) as? Data,
                   let moneyProgress = result.value(forKey: ProgressPresenterString.moneyProgressValueKey.rawValue) as? NSProgressData,
                    let cigaretteProgress = result.value(forKey: ProgressPresenterString.cigaretteProgressValueKey.rawValue) as? NSProgressData,
                    let dates = result.value(forKey: ProgressPresenterString.datesValueKey.rawValue) as? [String]{
                    
                    if (!dates.contains(Date().noon.ddMMyyyy)) {
                        self.clearUserDataStore()
                        fallthrough
                    }
                    data = UserData(image: image, moneyProgress: moneyProgress, cigaretteProgress: cigaretteProgress, dates: dates)
                }else{
                    fallthrough
                }
            default:
                let dates = Date().daysOfWeek(using: .iso8601).map(\.ddMMyyyy)
                data = UserData(image: nil, moneyProgress: NSProgressData(bank: 0, count: [Int](repeating: 0, count: 7), norm: [Int](repeating: 0, count: 7)), cigaretteProgress: NSProgressData(bank: 0, count: [Int](repeating: 0, count: 7), norm: [Int](repeating: 0, count: 7)), dates: dates)
            }
            
            self.progressViewDelegate?.showUserData(data)
            
        }
    }
    
    func saveUserData(_ data: UserData) {
        requestUserData() {result in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let dates = Date().daysOfWeek(using: .iso8601).map(\.ddMMyyyy)
            
            let userData:NSManagedObject!
            switch result{
            case (let result?):
              userData = result
            default:
                let entity = NSEntityDescription.entity(forEntityName: ProgressPresenterString.entityName.rawValue, in: appDelegate.persistentContainer.viewContext)
                userData = NSManagedObject(entity: entity!, insertInto: appDelegate.persistentContainer.viewContext)
      
            }
            
            userData.setValue(data.image, forKey: ProgressPresenterString.imageValueKey.rawValue)
            userData.setValue(data.moneyProgress, forKey: ProgressPresenterString.moneyProgressValueKey.rawValue)
            userData.setValue(data.cigaretteProgress, forKey: ProgressPresenterString.cigaretteProgressValueKey.rawValue)
            userData.setValue(dates, forKey: ProgressPresenterString.datesValueKey.rawValue)
            appDelegate.saveContext()
        }
    }
}



//MARK: ProgressRecalculateDelegate
extension ProgressPresenter: ProgressRecalculateDelegate{
    func recalculateGraphData(newValue: Int, _ data: GraphData) {
        var newData = data
        let currentDate = Date().noon.ddMMyyyy
        let pointIndex = Date().daysOfWeek(using: .iso8601).map(\.ddMMyyyy).firstIndex {$0 == currentDate}
        
        switch data.graphType{
        case .count:
            newData.setup.points[pointIndex!] += newValue
        case .norm:
            newData.setup.points[pointIndex!] = newValue
        }
        
        progressViewDelegate?.showUpdatedGraph(newData)
    }
}


//MARK: EXTENSION

private extension Date {
    func byAdding(component: Calendar.Component, value: Int, wrappingComponents: Bool = false, using calendar: Calendar = .current) -> Date? {
        calendar.date(byAdding: component, value: value, to: self, wrappingComponents: wrappingComponents)
    }
    
    func dateComponents(_ components: Set<Calendar.Component>, using calendar: Calendar = .current) -> DateComponents {
        calendar.dateComponents(components, from: self)
    }
    
    func startOfWeek(using calendar: Calendar = .current) -> Date {
        calendar.date(from: dateComponents([.yearForWeekOfYear, .weekOfYear], using: calendar))!
    }
    
    var noon: Date {
        return Calendar.current.dateComponents([.day, .month, .year, .calendar], from: self).date!
    }
    
    func daysOfWeek(using calendar: Calendar = .current) -> [Date] {
            let startOfWeek = self.startOfWeek(using: calendar).noon
            return (0...6).map { startOfWeek.byAdding(component: .day, value: $0, using: calendar)! }
        }
}

private extension Formatter {
    static let ddMMyyyy: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
}

private extension Date {
    var ddMMyyyy: String { Formatter.ddMMyyyy.string(from: self) }
}

private extension Calendar {
    static let iso8601 = Calendar(identifier: .iso8601)
    static let gregorian = Calendar(identifier: .gregorian)
}

