//
//  SystatisticChildCell.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 4.01.2023.
//

import UIKit
import SnapKit


class SystatisticChildCell: UITableViewCell {
    
    lazy var titleLabel: PadLabel = {
        let label = PadLabel()
        label.edgeInset = UIEdgeInsets(top: .zero, left: 3, bottom: .zero, right: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.tintColor = .primaryColor
        label.shadowLayer(color: .secondaryColor!,shadowRadius: 0.2, opacity: 0.22)
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
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
