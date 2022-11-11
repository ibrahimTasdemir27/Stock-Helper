//
//  BaseCollectionViews.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 7.11.2022.
//

import UIKit
import SnapKit

final class BaseCollectionViews : UICollectionViewCell {
    let titleLabel = UILabel()
    let overViewLabel = UILabel()
    
    class var identifier : String {
        return String(describing: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        titleLabel.textAlignment = .center
        titleLabel.layer.borderWidth = 0.4
        titleLabel.layer.borderColor = UIColor.black.cgColor
        
        overViewLabel.textAlignment = .right
        overViewLabel.numberOfLines = 20    
        overViewLabel.layer.borderWidth = 0.4
        overViewLabel.layer.borderColor = UIColor.black.cgColor
    }
    
    func update(with viewModel : TitleModel) {
        titleLabel.text = viewModel.title
        overViewLabel.text = viewModel.overview
    }
    
    private func setupHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(overViewLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        overViewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.width.equalTo(titleLabel.snp.width)
            make.bottom.equalToSuperview()
        }
    }
}
