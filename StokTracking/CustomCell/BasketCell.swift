//
//  BasketCell.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 18.12.2022.
//

import UIKit

class BasketCell: UITableViewCell {
    
    lazy var contentBasket: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var productName: PadLabel = {
        let label = PadLabel()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedName))
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 20
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gesture)
        label.edgeInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return label
    }()
    
    lazy var priceLabel: PadLabel = {
        let label = PadLabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .center
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 16
        return label
    }()
    
    lazy var quantityTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.textColor = .black
        return textField
    }()
    
    lazy var increaseQuantitiy: UIButton = {
        let button = UIButton()
        button.setImage(Icons.mount.image.withConfiguration(Icons.mount.image.config(40)), for: .normal)
        button.tintColor = .systemGray6
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(tappedIncrease), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tag = 1
        tableView.isHidden = true
        tableView.register(BasketTableViewCell.self)
        tableView.rowHeight = 40
        return tableView
    }()
    
    class var identifier: String {
        return String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        setupHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tappedIncrease() {
        print("Increase")
    }
    
    @objc func tappedName() {
        self.tableView.isHidden = false
    }
    
    func update(_ vm: BasketModel) {
        self.productName.text = vm.name
        self.priceLabel.text = vm.price.description
        self.quantityTextField.text = vm.quantity.description
    }
    
    func loadTableView<T: UITableViewDelegate & UITableViewDataSource>(delegate: T) {
        tableView.delegate = delegate
        tableView.dataSource = delegate
    }
    
    private func setupHierarchy() {
        addSubview(contentBasket)
        contentBasket.addSubview(productName)
        contentBasket.addSubview(quantityTextField)
        contentBasket.addSubview(increaseQuantitiy)
        contentBasket.addSubview(priceLabel)
        contentBasket.addSubview(tableView)
        
        contentBasket.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        productName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalToSuperview()
        }
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(productName.snp.right)
            make.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.12)
            make.bottom.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(productName.snp.bottom)
            make.centerX.equalTo(productName.snp.centerX)
            make.width.equalTo(productName.snp.width)
            make.height.equalTo(400)
        }
        quantityTextField.snp.makeConstraints { make in
            make.left.equalTo(priceLabel.snp.right)
            make.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.18)
            make.bottom.equalToSuperview()
        }
        increaseQuantitiy.snp.makeConstraints { make in
            make.left.equalTo(quantityTextField.snp.right)
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
    }

}
