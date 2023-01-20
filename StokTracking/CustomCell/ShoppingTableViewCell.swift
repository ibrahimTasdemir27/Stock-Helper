//
//  BasketTableViewCell.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 19.12.2022.
//

import UIKit

class ShoppingTableViewCell: UITableViewCell {
    
    lazy var titleLabel: PadLabel = {
        let label = PadLabel()
        label.textColor = .purple
        label.tintColor = .primaryColor
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.edgeInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        label.shadowLayer(shadowRadius: 0.2, opacity: 0.1)
        return label
    }()
    
    class var identifier: String {
        return String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        setupHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    deinit {
        print("I'm deinit: BasketTableViewCell")
    }
}
