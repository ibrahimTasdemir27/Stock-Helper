//
//  AddProductCollectionViews.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 8.11.2022.
//

import UIKit
import SnapKit

protocol DidDeleteDelegate: AnyObject {
    func delete(_ cell: UICollectionViewCell)
}

class AddProductCollectionViews : UICollectionViewCell {
    let titleTextField = UITextField()
    let overviewTextView = UITextView()
    let productView = UIView()
    lazy var deleteCell: UIImageView = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedDelete))
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
        imageView.image = UIImage(named: "minus")
        return imageView
    }()
    weak var delegate: DidDeleteDelegate?
    
    deinit {
        print("AddProductCollectionViews: I'm deinit")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class var identifier : String {
        return String(describing: self)
    }
    
    private func setupHierarchy() {
        addSubview(productView)
        productView.addSubview(titleTextField)
        productView.addSubview(overviewTextView)
        productView.addSubview(deleteCell)
        
        
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
        deleteCell.snp.makeConstraints { make in
            make.right.equalTo(overviewTextView.snp.right)
            make.top.equalTo(overviewTextView.snp.top)
            make.height.equalTo(17)
            make.width.equalTo(17)
        }
    }
    
    private func setupViews() {
        titleTextField.textAlignment = .left
        titleTextField.backgroundColor = .white
        titleTextField.textColor = .black
        titleTextField.layer.masksToBounds = true
        titleTextField.layer.cornerRadius = 20
        titleTextField.staticPadding(leftPadding: 15,rightPadding: 15)
        
        overviewTextView.backgroundColor = .white
        overviewTextView.textColor = .black
        overviewTextView.layer.masksToBounds = true
        overviewTextView.layer.cornerRadius = 30
        overviewTextView.font = UIFont.systemFont(ofSize: 17)
        overviewTextView.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    @objc private func tappedDelete(_ sender: UIImageView) {
        guard let delegate = self.delegate else { return }
        delegate.delete(self)
        
    }
    
    func update(with viewModel : Features, at index: Int) {
        titleTextField.text = viewModel.title
        overviewTextView.text = viewModel.overview
        if index > 2 {
            deleteCell.isHidden = false
        }
        else {
            deleteCell.isHidden = true
        }
    }
    
    func getDelegate<D: UITextViewDelegate & UITextFieldDelegate & DidDeleteDelegate>(delegate: D) {
        self.titleTextField.delegate = delegate
        self.overviewTextView.delegate = delegate
        self.delegate = delegate
    }
    
}
