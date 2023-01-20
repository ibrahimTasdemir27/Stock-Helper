//
//  SystatisticViewModel.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 1.01.2023.
//

import Foundation
import Charts

class SystatisticViewModel: DidSelectDateDelegate {
    
    var title = "İstatistikler"
    
    var coreDataManager: CoreDataManager
    
    var onUpdate = {}
    var chartUpdate = {}
    var updateDetailTable = {}
    
    weak var coordinator: SystatisticCoordinator?
    
    var soldItems = [CartModel]()
    var showSold = [SystatisticView]()
    var backShowSold = [SystatisticView]()
    var totalWeekPrice: Double = .zero
    var totalMonthPrice: Double = .zero
    var totalDayPrice: Double = .zero
    
    var timeZone: TimeXone = .thisWeek {
        didSet {
            chartUpdate()
            getTableItem()
            updateTotal()
            updateDetailTable()
        }
    }
    
    lazy var tableShowSold: [SystatisticView] = {
        var tableShowSold = [SystatisticView]()
        currentWeek.forEach { date in
            checkDate(&tableShowSold, date)
        }
        updateDetailTable()
        return tableShowSold
    }()
    
    
    lazy var dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .gmt
        dateFormatter.dateFormat = "dd.MM.yyy"
        return dateFormatter
    }()
    
    var entries: [ChartDataEntry] {
        var dataEntr = [ChartDataEntry]()
        var counter = 1
        switch timeZone {
        case .thisWeek:
            isWantWeek().forEach {
                dataEntr.append(BarChartDataEntry(x: Double(counter), y: $0))
                counter += 1
            }
        case .thisMonth:
            isWantMonth().forEach {
                dataEntr.append(BarChartDataEntry(x: Double(counter), y: $0))
                counter += 1
            }
        default:
            isWantWeek().forEach {
                dataEntr.append(BarChartDataEntry(x: Double(counter), y: $0))
                counter += 1
            }
        }
        return dataEntr
    }
    
    
    var lineCharDataSet: LineChartDataSet {
        return LineChartDataSet(entries: entries, label: "Price")
    }
    
    var currentWeek: [Date] {
        Date().getWeek()
    }
    
    var currentMonth: [Date] {
        Date().getMonthAllDays()
    }
    
    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = .gmt
        return calendar
    }
    
    init() {
        self.coreDataManager = CoreDataManager.shared
        coreDataManager.parseSold(completion: { model in
            self.soldItems = model
        })
    }
    
    func resetAllContent() {
        self.totalWeekPrice = 0
        self.totalMonthPrice = 0
    }
    
    func numberOfRows() -> Int {
        return self.showSold.count
    }
    
    func modalAt(_ index: Int) -> SystatisticView {
        return self.showSold[index]
    }
    
    func tappedDone() {
        coordinator?.didFinish()
    }
    
    func numberOfTable() -> Int {
        return self.tableShowSold.count
    }
    
    func modelOfTable(_ index: Int) -> SystatisticView {
        return self.tableShowSold[index]
    }
    
    
    func getTableItem() {
        tableShowSold.removeAll()
        switch timeZone {
        case .thisWeek:
            currentWeek.forEach { date in
                checkDate(&tableShowSold, date)
            }
        case .thisMonth:
            currentMonth.forEach { date in
                checkDate(&tableShowSold, date)
            }
        default: break
        }
    }
    
    func updateTotal() {
        switch timeZone {
        case .thisWeek:
            for i in 0..<tableShowSold.count {
                tableShowSold[i].total = totalWeekPrice
            }
        case .thisMonth:
            for i in 0..<tableShowSold.count  {
                tableShowSold[i].total = totalMonthPrice
            }
        case .day:
            for i in 0..<tableShowSold.count {
                tableShowSold[i].total = totalDayPrice
            }
        default : break
        }
    }
    
    func isWantWeek() -> [Double] {
        resetAllContent()
        var totalPrice = [Double]()
        currentWeek.forEach { date in
            var value: Double = 0
            soldItems.forEach { model in
                guard let dateModel = model.date else { return }
                if calendar.isDate(date, equalTo: dateModel, toGranularity: .day) {
                    value += model.price * model.quantity
                }
            }
            totalWeekPrice += value
            totalPrice.append(value)
        }
        updateTotal()
        return totalPrice
    }
    
    func isWantMonth() -> [Double] {
        resetAllContent()
        var totalPrice = [Double]()
        currentMonth.forEach { date in
            var value: Double = 0
            soldItems.forEach { model in
                guard let dateModel = model.date else { return }
                if calendar.isDate(date, equalTo: dateModel, toGranularity: .day) {
                    value += model.price * model.quantity
                }
            }
            totalMonthPrice += value
            totalPrice.append(value)
        }
        updateTotal()
        return totalPrice
    }
    
    func isSelect(_ index: Int ) {
        defer { self.onUpdate() }
        showSold.removeAll()
        switch timeZone {
        case .thisWeek:
            checkDate(&showSold,currentWeek[index])
        case .thisMonth:
            checkDate(&showSold,currentMonth[index])
        case .day:
            tableShowSold = backShowSold
            timeZone = .thisWeek
        default: break
        }
    }
    
    func checkDate(_ list: inout [SystatisticView],_ isDate: Date) {
        soldItems.forEach { model in
            guard let modelDate = model.date else { return }
            if calendar.isDate(isDate, equalTo: modelDate, toGranularity: .day) {
                let systa = getTotal(model.name,modelDate)
                if !list.contains(where: { sys -> Bool in
                    return systa == sys
                }) {
                    list.append(systa)
                }
            }
        }
    }
    
    func getTotal(_ name: String, _ date: Date) -> SystatisticView {
        let filtered = soldItems.filter { model in
            return name == model.name && date == model.date
        }
        let quantity = filtered.reduce(0) { partialResult, model in
            return partialResult + model.quantity
        }
        let imageStr = filtered.first?.image
        let price = filtered.first?.price
        return SystatisticView(name: name, quantity: quantity.description ,image: imageStr ?? "", price: price ?? .zero, total: .zero)
    }
    
    func tappedCalendar() {
        self.timeZone = .day
        coordinator?.tappedCalendar()
    }
    
    func selectedDate(_ date: Date) {
        backShowSold = tableShowSold
        tableShowSold.removeAll()
        checkDate(&tableShowSold, date)
        totalDayPrice = .zero
        tableShowSold.forEach { model in
            totalDayPrice += model.price * Double(model.quantity)!
        }
        updateTotal()
        updateDetailTable()
    }
    
    deinit {
        print("I'm deinit: SystatisticViewModel")
    }
    
}

struct SystatisticView: Equatable {
    let name: String
    let quantity: String
    let image: String
    let price: Double
    var total: Double
}

