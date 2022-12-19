//
//  PresentationViewController.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 11.12.2022.
//

import UIKit
import SnapKit

class PresentationViewController: UIViewController {
    
    lazy var explanation: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Bold", size: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Stok takibi, QR Kod kolaylıkları ve daha fazlası"
        label.textColor = .black
        return label
    }()
    
    lazy var shoppingCart: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "shoppingman")
        return imageView
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.setTitle("Başla", for: .normal)
        button.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .primaryColor?.withAlphaComponent(1.2)
        button.addTarget(self, action: #selector(tappedStart), for: .touchUpInside)
        return button
    }()
    
    var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupHierarchy()
    }
    
    @objc private func tappedStart() {
        userDefaults.setValue(true, forKey: "firstdownload")
        navigationController?.dismiss(animated: true)
        coordinator?.tappedStart()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Stok Takibi"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupHierarchy() {
        view.addSubview(explanation)
        view.addSubview(shoppingCart)
        view.addSubview(startButton)
        
        explanation.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(screenHeight * 0.25)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(100)
        }
        shoppingCart.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-screenHeight * 0.2)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        startButton.snp.makeConstraints { make in
            make.top.equalTo(shoppingCart.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(55)
        }
    }
}
