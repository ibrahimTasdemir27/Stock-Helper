//
//  BasketCell.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 18.12.2022.
//

import UIKit

protocol DidShowListDelegate: AnyObject {
    func showList(cell: UITableViewCell)
    func selectProduct(vm: CartModel)
    func updateQuantity(_ cell: UITableViewCell,_ vm: CartModel)
    func updatePrice(_ cell: UITableViewCell,_ vm: CartModel)
}

class VIPQuantityField: UITextField {
    override func endEditing(_ force: Bool) -> Bool {
        guard
            let text = self.text,
            let first = text.first,
            let doubleText = Double(text), first.isNumber else {
                self.text = Double.zero.description
                return force
            }
        if doubleText < Double.zero {
            self.text = Double.zero.description
        }
        return force
    }
}

class VIPPriceField: UITextField {
    
    var firstPrice: Double = .zero
    
    override func endEditing(_ force: Bool) -> Bool {
        guard
            let text = self.text,
            let first = text.first,
            let doubleText = Double(text), first.isNumber else {
            self.text = firstPrice.description
            return force }
        if doubleText < Double.zero {
            self.text = firstPrice.description
        } else if doubleText > firstPrice {
            self.text = firstPrice.description
        }
        return force
    }
}

enum ScaleContext {
    case scaleUp
    case scaleDown
}

class ShoppingCartCell: UITableViewCell {
    
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
        label.textColor = .white
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gesture)
        label.edgeInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        label.shadowLayer(shadowRadius: 5, opacity: 0.618)
        return label
    }()
    
    lazy var priceTextField: VIPPriceField = {
        let textField = VIPPriceField()
        textField.tag = .zero
        textField.textAlignment = .center
        textField.textColor = .white
        textField.adjustsFontSizeToFitWidth = true
        textField.delegate = self
        textField.shadowLayer(shadowRadius: 5, opacity: 0.618)
        return textField
    }()
    
    lazy var quantityTextField: VIPQuantityField = {
        let textField = VIPQuantityField()
        textField.tag = 1
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.textColor = .white
        textField.adjustsFontSizeToFitWidth = true
        textField.delegate = self
        textField.shadowLayer(shadowRadius: 5, opacity: 0.618)
        return textField
    }()
    
    lazy var scaleUPQuantityButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tappedScaleUp), for: .touchUpInside)
        button.setImage(Icons.plus.image.withConfiguration(Icons.mount.image.config(20)), for: .normal)
        button.isCurcular()
        
        button.tintColor = .primaryColor
        button.shadowLayer(shadowRadius: 0.2)
        return button
    }()
    
    lazy var scaleDownQuantityButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tappedScaleDown), for: .touchUpInside)
        button.setImage(Icons.minus.image.withConfiguration(Icons.mount.image.config(20)), for: .normal)
        button.isCurcular()
        button.tintColor = .red
        button.shadowLayer(shadowRadius: 1)
        return button
    }()
    
    var cartModel: CartModel!
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
    
    @objc func tappedName() {
        editCheck()
        if let delegate = self.delegate {
            delegate.showList(cell: self)
        }
    }
    
    func update(_ vm: CartModel) {
        self.priceTextField.firstPrice = vm.price
        self.cartModel = vm
        self.productName.text = vm.name
        self.priceTextField.text = vm.price.description
        self.quantityTextField.text = vm.quantity.description
    }
    
    func loadTableView<T: DidShowListDelegate >(delegate: T) {
        self.delegate = delegate
    }
    
    @objc private func tappedScaleUp() {
        scaleAction(.scaleUp)
    }
    
    @objc private func tappedScaleDown() {
        scaleAction(.scaleDown)
    }
    
    private func scaleAction(_ context: ScaleContext) {
        if  let quantity = Double(quantityTextField.text!), quantity.isPositive() {
            var text: Double = .zero
            switch context {
            case .scaleDown:
                text = quantity - 1
                if quantity.isZero { text = .zero }
            case .scaleUp:
                text = quantity + 1
            }
            quantityTextField.text = text.description
            finishEdit(cartModel.price, text)
        } else {
            editCheck()
        }
    }
    
    private func editCheck() {
        guard
            let text = priceTextField.text,
            let textQuant = quantityTextField.text else { return }
        guard
            let priceText = Double(text), priceText.isPositive()
        else {
            if priceTextField.endEditing(true) {}
            return
        }
        guard
            let quantityText = Double(textQuant),
            quantityText.isPositive()
        else {
            if quantityTextField.endEditing(true) {}
            return
        }
        if priceTextField.endEditing(true) {}
        if quantityTextField.endEditing(true) {}
        finishEdit(priceText, quantityText)
    }
    
    private func finishEdit(_ price: Double, _ quantity: Double ) {
        guard let delegate = self.delegate else { return }
        cartModel.updatePrice(price)
        cartModel.updateQuantity(quantity)
        delegate.updatePrice(self, cartModel)
    }
    
    
    private func setupHierarchy() {
        addSubview(contentBasket)
        contentBasket.addSubview(productName)
        contentBasket.addSubview(quantityTextField)
        contentBasket.addSubview(scaleUPQuantityButton)
        contentBasket.addSubview(scaleDownQuantityButton)
        contentBasket.addSubview(priceTextField)
        
        contentBasket.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        productName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(7)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalToSuperview().offset(-7)
        }
        priceTextField.snp.makeConstraints { make in
            make.left.equalTo(productName.snp.right)
            make.top.equalToSuperview().offset(7)
            make.width.equalToSuperview().multipliedBy(0.12)
            make.bottom.equalToSuperview().offset(-7)
        }
        quantityTextField.snp.makeConstraints { make in
            make.left.equalTo(priceTextField.snp.right)
            make.top.equalToSuperview().offset(7)
            make.width.equalToSuperview().multipliedBy(0.262)
            make.bottom.equalToSuperview().offset(-7)
        }
        scaleUPQuantityButton.snp.makeConstraints { make in
            make.left.equalTo(quantityTextField.snp.right).offset(3)
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-5)
            make.height.equalToSuperview().multipliedBy(0.5).offset(-1)
        }
        scaleDownQuantityButton.snp.makeConstraints { make in
            make.top.equalTo(scaleUPQuantityButton.snp.bottom).offset(2)
            make.left.equalTo(quantityTextField.snp.right).offset(3)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview()
        }
    }
    
    deinit {
        print("I'm deinit: BasketCell")
    }
    
}

extension ShoppingCartCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        editCheck()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard
            var currentValue = Double(textField.text! + string), currentValue.isPositive() else {
            editCheck()
            return true
        }
        if string.isEmpty {
            var text = textField.text
            if text!.count > 1 {
                text?.removeLast()
                currentValue = Double(text!)!
            }
        }
        switch textField.tag {
        case .zero:
            finishEdit(currentValue, cartModel.quantity)
        case 1:
            finishEdit(cartModel.price, currentValue)
        default: break
        }
        return true
    }
    
    
}
