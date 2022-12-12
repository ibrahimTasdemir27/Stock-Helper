//
//  SettingsCell.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 10.12.2022.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    lazy var darkMode: UISwitch = {
        let switchController = UISwitch()
        contentView.isUserInteractionEnabled = true
        switchController.setOn(false, animated: true)
        switchController.isEnabled = true
        switchController.isHidden = true
        switchController.thumbTintColor = .darkGray
        switchController.onTintColor = .clear
        switchController.addTarget(self, action: #selector(tappedSwitch(_ :)), for: .touchUpInside)
        return switchController
    }()
    
    lazy var settingsLabel: PadLabel = {
        let label = PadLabel()
        label.edgeInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    class var identifier: String {
        return String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemGray6
        setupHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tappedSwitch(_ sender: UISwitch) {
        if sender.isOn {
            sender.thumbTintColor = .white
            window?.windowScene?.windows.forEach({ window in
                window.overrideUserInterfaceStyle = .dark
            })
        } else {
            sender.thumbTintColor = .darkGray
            window?.windowScene?.windows.forEach({ window in
                window.overrideUserInterfaceStyle = .light
            })
        }
    }
    
    func update(_ text: String, _ index: Int) {
        if index == 0 {
            darkMode.isHidden = false
        }
        settingsLabel.text = text
    }
    
    private func setupHierarchy() {
        addSubview(settingsLabel)
        addSubview(darkMode)
        
        settingsLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        darkMode.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
        }
    }
}
