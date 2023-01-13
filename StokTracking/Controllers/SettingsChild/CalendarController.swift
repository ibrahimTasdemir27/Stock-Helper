//
//  CalendarController.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 11.01.2023.
//

import UIKit
import SnapKit

class CalendarController: UIViewController {
    
    lazy var calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        var gregorianCalendar = Calendar(identifier: .gregorian)
        calendarView.calendar = gregorianCalendar
        calendarView.timeZone = .gmt
        calendarView.fontDesign = .rounded
        calendarView.delegate = self
        calendarView.backgroundColor = .systemGray6
        calendarView.visibleDateComponents = DateComponents(calendar: Calendar(identifier: .gregorian),year: 2023,month: 2,day: 1)
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        return calendarView
    }()
    
    var delegate: DidSelectDateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        navigationController?.navigationBar.isHidden = true
        setupHierarchy()
    }
    
    private func setupHierarchy() {
        view.addSubview(calendarView)
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(statusBarNavigationHeight + 100)
            make.right.equalToSuperview().offset(-20)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.35)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchesPoint = touch.location(in: self.view)
            if !calendarView.frame.contains(touchesPoint) {
                self.dismiss(animated: false)
            }
        }
    }
    
}

extension CalendarController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let selectedDate = dateComponents?.date, let delegate = self.delegate else { return }
        delegate.selectedDate(selectedDate)
    }
    
    
    
}
