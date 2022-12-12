//
//  BaseCollectionViews.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 7.11.2022.
//

import UIKit
import SnapKit

class BaseCollectionViews : UICollectionViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.textAlignment = .center
        label.layer.borderWidth = 0.4
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    lazy var overViewLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.textAlignment = .right
        label.numberOfLines = 20
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 0.4
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    class var identifier : String {
        return String(describing: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
    }
    
    func update(vm: Features) {
        self.titleLabel.text = vm.title
        self.overViewLabel.text = vm.overview
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(overViewLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.975)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        overViewLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.width.equalTo(titleLabel.snp.width)
            make.bottom.equalToSuperview()
        }
    }
}
