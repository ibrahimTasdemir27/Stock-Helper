//
//  UIView+Extensions.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 29.11.2022.
//

import UIKit

extension UIView {
    func bounce() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }, completion: { finished in
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        })
    }
    
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.add(shake, forKey: "position")
    }
    
    func isCurcular() {
        DispatchQueue.main.async {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = self.frame.width / 2
        }
    }
    
    func systaTistic() {
        let shapeLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: self.center, radius: CGFloat(self.frame.width / 2), startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = CGFloat(0.8)
        self.layer.addSublayer(shapeLayer)
    }
    
    func shadowLayer(color: UIColor = .purple, shadowRadius: CGFloat = 10, opacity: Float = 1 )  {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = .zero
        DispatchQueue.main.async {
            if let button = self as? UIButton { button.imageView?.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath } else {
                self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            }
        }
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
