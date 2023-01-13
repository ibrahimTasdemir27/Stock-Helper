//
//  SystatisticChildCell.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 4.01.2023.
//

import UIKit
import SnapKit


class SystatisticChildCell: UITableViewCell {
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    class var identifier: String {
        return String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.618)
            make.bottom.equalToSuperview()
        }
    }
}
