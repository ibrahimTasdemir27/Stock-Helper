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

class AttemptTextView: UITextView {
    deinit {
        print("I'm Deinit: UITextview")
    }
}

class AttemptTextField: UITextField {
    deinit {
        print("I'm Deinit: UITextField")
    }
}

class AttemptLabel: UILabel {
    deinit {
        print("I'm Deinit: UITextField")
    }
}

class AddProductCollectionViews : UICollectionViewCell {
    lazy var titleTextField: AttemptTextField = {
        let textField = AttemptTextField()
        textField.textAlignment = .left
        textField.backgroundColor = .white
        textField.textColor = .purple
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 20
        textField.staticPadding(leftPadding: 15,rightPadding: 15)
        return textField
    }()
    lazy var overviewTextView: AttemptTextView = {
        let textView = AttemptTextView()
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 30
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        return textView
    }()
    lazy var productView: UIView = {
        let view = UIView()
        return view
    }()
    lazy var deleteCell: UIImageView = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedDelete))
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
        imageView.image = UIImage(named: "minus")
        return imageView
    }()
    
    var delegate: DidDeleteDelegate?
    
    deinit {
        titleTextField.removeFromSuperview()
        overviewTextView.removeFromSuperview()
        print("AddProductCollectionViews: I'm deinit")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    @objc private func tappedDelete(_ sender: UIImageView) {
        guard let delegate = self.delegate else { return }
        delegate.delete(self)
        
    }
    
    func update(with viewModel : Features, at index: Int) {
        titleTextField.text = viewModel.title
        overviewTextView.text = viewModel.overview
        if index > 2 {
            titleTextField.isUserInteractionEnabled = true
            deleteCell.isHidden = false
        }
        else {
            titleTextField.isUserInteractionEnabled = false
            deleteCell.isHidden = true
        }
    }
    
    func getDelegate<D: UITextViewDelegate & UITextFieldDelegate & DidDeleteDelegate>(delegate: D) { 
        self.titleTextField.delegate = delegate
        self.overviewTextView.delegate = delegate
        self.delegate = delegate
    }
    
    
    
    
}


extension UICollectionViewCell {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UICollectionViewCell.dismissKeyboard))
        self.addGestureRecognizer(tap)

    }

    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
}
