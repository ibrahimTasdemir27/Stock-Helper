//
//  AddProductCollectionViews.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 8.11.2022.
//

import UIKit
import SnapKit

final class AddProductCollectionViews : UICollectionViewCell {
    
    let titleTextField = UITextField()
    let overviewTextView = UITextView()
    let productView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class var identifier : String {
        return String(describing: self)
    }
    
    private func configure() {
        addSubview(productView)
        productView.addSubview(titleTextField)
        productView.addSubview(overviewTextView)
        
        
        productView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalToSuperview().multipliedBy(0.28)
        }
        overviewTextView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleTextField.snp.bottom).offset(4)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupViews() {
        titleTextField.textAlignment = .left
        titleTextField.isUserInteractionEnabled = false
        titleTextField.backgroundColor = .lightGray.withAlphaComponent(0.2)
        titleTextField.layer.masksToBounds = true
        titleTextField.layer.cornerRadius = 20
        titleTextField.staticPadding(leftPadding: 15,rightPadding: 15)
        
        
        overviewTextView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        overviewTextView.layer.masksToBounds = true
        overviewTextView.layer.cornerRadius = 30
        overviewTextView.font = UIFont.systemFont(ofSize: 17)
        overviewTextView.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    func update(with viewModel : TitleModel) {
        titleTextField.text = viewModel.title
        overviewTextView.text = viewModel.overview
        
    }
    
}
