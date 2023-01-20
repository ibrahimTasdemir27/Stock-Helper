//
//  SystatisticDetailCell.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 6.01.2023.
//

import UIKit

class SystatisticDetailCell: UITableViewCell {
    
    
    lazy var productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.shadowLayer(shadowRadius: 5)
        return imageView
    }()
    
    lazy var productTitle: PadLabel = {
        let label = PadLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.edgeInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        label.textColor = .secondaryColor
        return label
    }()
    
    lazy var totalPrice: PadLabel = {
        let label = PadLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.textColor = .secondaryColor
        return label
    }()
    
    lazy var percentView: CircularView = {
        let view = CircularView()
        return view
    }()
    
    
    class var identifier: String {
        return String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addSubview(productImage)
        addSubview(productTitle)
        addSubview(totalPrice)
        addSubview(percentView)
        
        productImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(productImage.snp.height)
        }
        productTitle.snp.makeConstraints { make in
            make.left.equalTo(productImage.snp.right)
            make.top.equalToSuperview().offset(7)
            make.bottom.equalToSuperview().offset(-7)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        totalPrice.snp.makeConstraints { make in
            make.left.equalTo(productTitle.snp.right)
            make.top.equalToSuperview().offset(7)
            make.bottom.equalToSuperview().offset(-7)
            make.width.equalToSuperview().multipliedBy(0.16)
        }
        percentView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(3)
            make.bottom.equalToSuperview().offset(-3)
            make.width.equalTo(percentView.snp.height)
        }
    }
    
    func updateUI(_ vm: SystatisticView) {
        productImage.image = UIImage(named: vm.image)
        productTitle.text = "\(vm.name) x \(vm.quantity) adet"
        guard let quantity = Double(vm.quantity) else { return }
        totalPrice.text = (quantity * vm.price).description
        percentView.strokeEnd = CGFloat(vm.price * quantity / vm.total)
    }
    
}

class CircularView: UIView {
    
    var strokeEnd: CGFloat? {
        didSet {
            label.removeFromSuperview()
            layoutSubviews()
            guard strokeEnd != nil else { return }
            label.text = "%" + strokeEnd!.formatAsPercent()
            strokeEnd = strokeEnd! * 0.8
        }
    }
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let externalLayer = CAShapeLayer()
    
    var label = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(label)
        self.shapeLayer.removeFromSuperlayer()
        self.trackLayer.removeFromSuperlayer()
        self.externalLayer.removeFromSuperlayer()
        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        let circularPath = UIBezierPath(arcCenter: center, radius: CGFloat(self.frame.width / 2) - 10, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        let circularPathh = UIBezierPath(arcCenter: center, radius: CGFloat(self.frame.width / 2) - 5, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        label.center = center
        label.bounds = CGRect(origin: center, size: CGSize(width: self.frame.width * 0.5 , height: self.frame.height * 0.4))
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.purple.cgColor
        trackLayer.lineWidth = 1
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.borderColor = UIColor.purple.cgColor
        
        externalLayer.path = circularPathh.cgPath
        externalLayer.strokeColor =  UIColor.purple.withAlphaComponent(0.6).cgColor
        externalLayer.fillColor = UIColor.clear.cgColor
        externalLayer.lineWidth = 1.25
        externalLayer.lineCap = CAShapeLayerLineCap.round
        
        self.layer.addSublayer(externalLayer)
        self.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.purple.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = CGFloat(strokeEnd ?? 0)
        
        self.layer.addSublayer(shapeLayer)
    }
    
}
