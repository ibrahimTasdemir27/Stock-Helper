//
//  BasketCell.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 18.12.2022.
//

import UIKit

protocol DidShowListDelegate: AnyObject {
    func showList(cell: UITableViewCell)
    func selectProduct(vm: BasketModel)
    func updatePrice(_ cell: UITableViewCell,_ vm: BasketModel)
}

class BasketCell: UITableViewCell {
    
    lazy var contentBasket: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .systemGray6
        return view
    }()
    
    lazy var productName: PadLabel = {
        let label = PadLabel()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedName))
        label.textAlignment = .left
        label.backgroundColor = .systemGray6
        label.layer.borderWidth = 0.3
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 20
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gesture)
        label.edgeInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return label
    }()
    
    lazy var priceLabel: PadLabel = {
        let label = PadLabel()
        label.backgroundColor = .systemGray6
        label.textAlignment = .center
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 16
        label.layer.borderWidth = 0.3
        label.layer.borderColor = UIColor.white.cgColor
        return label
    }()
    
    lazy var quantityTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.textAlignment = .center
        textField.backgroundColor = .systemGray6
        textField.keyboardType = .numberPad
        textField.layer.borderWidth = 0.3
        textField.layer.borderColor = UIColor.white.cgColor
        return textField
    }()
    
    lazy var increaseQuantitiy: UIButton = {
        let button = UIButton()
        button.setImage(Icons.plus.image.withConfiguration(Icons.mount.image.config(20)), for: .normal)
        button.isCurcular()
        button.tintColor = .green
        button.backgroundColor = .white
        button.isUserInteractionEnabled = false
        return button
    }()
    
    lazy var decreaseQuantitiy: UIButton = {
        let button = UIButton()
        button.setImage(Icons.minus.image.withConfiguration(Icons.mount.image.config(20)), for: .normal)
        button.isCurcular()
        button.tintColor = .red
        button.backgroundColor = .white
        button.isUserInteractionEnabled = false
        return button
    }()
    
    var basketModel: BasketModel!
    weak var delegate: DidShowListDelegate?
    
    class var identifier: String {
        return String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = true
        contentBasket.isUserInteractionEnabled = true
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
        if let delegate = self.delegate {
            delegate.showList(cell: self)
        }
    }
    
    func update(_ vm: BasketModel) {
        self.basketModel = vm
        self.productName.text = vm.name
        self.priceLabel.text = vm.price.description
        self.quantityTextField.text = vm.quantity.description
    }
    
    func loadTableView<T: UITextFieldDelegate & DidShowListDelegate >(delegate: T) {
        self.delegate = delegate
        quantityTextField.delegate = delegate
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let delegate = self.delegate else { return }
        guard let quantity = Double(quantityTextField.text!) else { return }
        defer { delegate.updatePrice(self,self.basketModel) }
        if let touch = touches.first {
            let touchPoint: CGPoint = touch.location(in: contentBasket)
            if  increaseQuantitiy.frame.contains(touchPoint) {
                let text = (quantity + 1).description
                quantityTextField.text = text
                basketModel.updateQuantity(quantity: text)
            } else if decreaseQuantitiy.frame.contains(touchPoint) {
                    let text = (quantity - 1).description
                    if quantity <= 0 { return }
                    quantityTextField.text = text
                    basketModel.updateQuantity(quantity: text)
                }
            
        }
    }
    
    private func setupHierarchy() {
        addSubview(contentBasket)
        contentBasket.addSubview(productName)
        contentBasket.addSubview(quantityTextField)
        contentBasket.addSubview(increaseQuantitiy)
        contentBasket.addSubview(decreaseQuantitiy)
        contentBasket.addSubview(priceLabel)
        
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
        quantityTextField.snp.makeConstraints { make in
            make.left.equalTo(priceLabel.snp.right)
            make.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.262)
            make.bottom.equalToSuperview()
        }
        increaseQuantitiy.snp.makeConstraints { make in
            make.left.equalTo(quantityTextField.snp.right).offset(3)
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-5)
            make.height.equalToSuperview().multipliedBy(0.5).offset(-1)
        }
        decreaseQuantitiy.snp.makeConstraints { make in
            make.top.equalTo(increaseQuantitiy.snp.bottom).offset(2)
            make.left.equalTo(quantityTextField.snp.right).offset(3)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview()
        }
    }
    
    deinit {    
        print("I'm deinit: BasketCell")
    }

}
