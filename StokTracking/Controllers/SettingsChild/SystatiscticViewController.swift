//
//  SystatiscticViewController.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 1.01.2023.
//

import UIKit
import Charts
import SnapKit


enum ClickLocation {
    case left
    case right
}

enum TimeXone: String, CaseIterable {
    case thisWeek = "Bu Hafta"
    case thisMonth = "Bu Ay"
    case thisYear = "Bu Yıl"
    case day = "Gün"
}

class SystatiscticViewController: UIViewController {
    
    var systatisticVM: SystatisticViewModel!
    
    lazy var lineChart: LineChartView = {
        let lineChart = LineChartView()
        lineChart.backgroundColor = .white
        lineChart.rightAxis.enabled = false
        let yAxis = lineChart.leftAxis
        yAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .bold)
        yAxis.labelTextColor = .black
        yAxis.axisLineColor = .black
        yAxis.drawAxisLineEnabled = false
        yAxis.drawGridLinesEnabled = false
        yAxis.axisMinimum = 0
        lineChart.xAxis.drawAxisLineEnabled = false
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelTextColor = .black
        lineChart.xAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .bold)
        lineChart.xAxis.axisLineColor = .black
        lineChart.animate(xAxisDuration: 2.5)
        lineChart.doubleTapToZoomEnabled = false
        lineChart.delegate = self
        lineChart.layer.masksToBounds = true
        lineChart.layer.cornerRadius = 12
        return lineChart
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 24
        tableView.layer.contentsGravity = .topLeft
        tableView.layer.cornerRadius = 8
        tableView.backgroundColor = .red
        tableView.register(SystatisticChildCell.self)
        tableView.backgroundColor = .clear
        tableView.tag = 0
        return tableView
    }()
    
    lazy var timeZone: UIButton = {
        var configuration = UIButton.Configuration.bordered()
        configuration.cornerStyle  = .capsule
        configuration.image = Icons.clock.image
        configuration.imagePlacement = .leading
        configuration.title = "Bu Hafta"
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 0)
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(tappedTimeZone), for: .touchUpInside)
        button.contentHorizontalAlignment = .leading
        button.tintColor = .secondaryColor
        return button
    }()
    
    lazy var timeZoneTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 36
        tableView.tag = 1
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SystatisticDetailCell.self)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    
    lazy var calendarButton: UIButton = {
        var configuration = UIButton.Configuration.bordered()
        configuration.cornerStyle = .capsule
        configuration.image = Icons.calendar.image
        configuration.imagePlacement = .leading
        configuration.title = "Tarih Seçin"
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 0)
        let button = UIButton(configuration: configuration)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentHorizontalAlignment = .leading
        button.tintColor = .secondaryColor
        button.addTarget(self, action: #selector(tappedCalendar), for: .touchUpInside)
        return button
    }()
    
    lazy var lineChartDataSet: LineChartDataSet = { [weak self] in
        let lineChartDataSet = systatisticVM.lineCharDataSet
        return lineChartDataSet
    }()
    
    lazy var data: LineChartData = { [weak self] in
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        return lineChartData
    }()
    
    lazy var detailTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SystatisticDetailCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tag = 2
        tableView.rowHeight = 60
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        setupUI()
        setupHierarchy()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = systatisticVM.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Icons.back.image.withConfiguration(Icons.back.image.config()), style: .done, target: self, action: #selector(tappedDone))
    }
    
    
    private func setupHierarchy() {
        view.addSubview(timeZone)
        view.addSubview(calendarButton)
        view.addSubview(lineChart)
        view.addSubview(tableView)
        view.addSubview(timeZoneTableView)
        view.addSubview(detailTableView)
        
        timeZone.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(statusBarNavigationHeight + 60)
            make.left.equalToSuperview().offset(5)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(40)
        }
        timeZoneTableView.snp.makeConstraints { make in
            make.top.equalTo(timeZone.snp.bottom).offset(4.5)
            make.left.equalTo(timeZone.snp.left)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(100)
        }
        calendarButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(statusBarNavigationHeight + 60)
            make.right.equalToSuperview().offset(-5)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(40)
        }
        lineChart.snp.makeConstraints { make in
            make.top.equalTo(timeZone.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        detailTableView.snp.makeConstraints { make in
            make.top.equalTo(lineChart.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func initViewModel() {
        systatisticVM.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        systatisticVM.updateDetailTable = { [weak self] in
            self?.detailTableView.reloadData()
        }
        systatisticVM.chartUpdate = { [unowned self] in
            lineChartDataSet = systatisticVM.lineCharDataSet
            data = LineChartData(dataSet: lineChartDataSet)
            viewDidLayoutSubviews()
        }
    }
    
    private func tableLocation(_ location: ClickLocation) {
        tableView.snp.removeConstraints()
        if location == .left {
            tableView.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(30)
                make.top.equalTo(statusBarNavigationHeight + 80)
                make.height.equalTo(screenHeight*0.4*0.35)
                make.width.equalToSuperview().multipliedBy(0.35)
            }
        } else if location == .right {
            tableView.snp.updateConstraints { make in
                make.right.equalToSuperview().offset(-30)
                make.top.equalTo(statusBarNavigationHeight + 80)
                make.height.equalTo(screenHeight*0.4*0.35)
                make.width.equalToSuperview().multipliedBy(0.35)
            }
        }
    }
    
    @objc private func tappedDone() {
        systatisticVM.tappedDone()
    }
    
    @objc private func tappedTimeZone() {
        self.timeZoneTableView.isHidden = false
    }
    
    @objc private func tappedCalendar() {
        systatisticVM.tappedCalendar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchesPoint = touch.location(in: self.view)
            if !timeZoneTableView.isHidden {
                if !timeZoneTableView.frame.contains(touchesPoint) {
                    timeZoneTableView.isHidden = true
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.mode = .horizontalBezier
        lineChartDataSet.lineWidth = 1.5
        lineChartDataSet.setColor(.purple)
        lineChartDataSet.fill = ColorFill(color: .purple)
        lineChartDataSet.fillAlpha = 0.1
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = true
        lineChartDataSet.highlightColor = .black
        lineChartDataSet.highlightLineWidth = 1
        
        data.setDrawValues(false)
        lineChart.data = data
    }
    
    deinit {
        print("I'm Deinit: SystatisticViewController")
    }
    
}

extension SystatiscticViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] {
            let sliceIndex: Int = dataSet.entryIndex( entry: entry)
            guard let xPx = chartView.lastHighlighted?.xPx else { return }
            if xPx > self.view.frame.width / 2 {
                tableLocation(.left)
            } else {
                tableLocation(.right)
            }
            systatisticVM.isSelect(sliceIndex)
        }
    }
}

extension SystatiscticViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0:
            return systatisticVM.numberOfRows()
        case 1:
            return TimeXone.allCases.count
        case 2:
            return systatisticVM.numberOfTable()
        default:
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 0:
            let model = systatisticVM.modalAt(indexPath.row)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SystatisticChildCell.identifier, for: indexPath) as? SystatisticChildCell else { fatalError()}
            cell.titleLabel.text = "\(model.name) x \(model.quantity) adet"
            return cell
        case 1:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
            cell.selectionStyle = .none
            cell.textLabel?.backgroundColor = .systemGray6
            cell.textLabel?.text = TimeXone.allCases[indexPath.row].rawValue
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12.6, weight: .bold)
            return cell
        case 2:
            let model = systatisticVM.modelOfTable(indexPath.row)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SystatisticDetailCell.identifier, for: indexPath) as?
                    SystatisticDetailCell else { fatalError() }
            cell.updateUI(model)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.bounce()
        switch tableView.tag {
        case 0:
            print("case0")
        case 1:
            systatisticVM.timeZone = TimeXone.allCases[indexPath.row]
            timeZoneTableView.isHidden = true
        default:
            print("DefaultTable")
        }
    }
    
}
