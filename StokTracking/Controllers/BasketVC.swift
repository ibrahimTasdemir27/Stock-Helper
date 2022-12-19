//
//  BasketVC.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 17.12.2022.
//

import UIKit
import SnapKit

class BasketVC: UIViewController {
    
    lazy var contentViewQRCode: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 60
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.backgroundColor = .white
        return view
    }()
    
    lazy var QRCodeImageView : UIImageView = {
        let imageView = UIImageView()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedQR))
        imageView.layer.borderColor = UIColor.systemGray6.cgColor
        imageView.addGestureRecognizer(gestureRecognizer)
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "qrscan")
        return imageView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tag = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray6
        tableView.rowHeight = 60
        tableView.register(BasketCell.self)
        return tableView
    }()
    
    let basketVM = BasketViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupHierarchy()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        navigationItem.title = basketVM.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupHierarchy() {
        view.addSubview(contentViewQRCode)
        view.addSubview(tableView)
        contentViewQRCode.addSubview(QRCodeImageView)
        
        let navBarHeight = UIApplication.shared.statusBarHeight + (navigationController?.navigationBar.frame.height ?? 0.0)
        contentViewQRCode.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(navBarHeight + 20)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.26)
        }
        QRCodeImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(contentViewQRCode.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    @objc private func tappedQR() {
        print("qrr")
    }
    
}

extension BasketVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0:
            return basketVM.numberOfRows
        case 1:
            return basketVM.numberOfRowsFeatures()
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 0:
            guard let basketModel = basketVM.modalAt(indexPath.row) else { fatalError("Don't make model at basket") }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BasketCell.identifier, for: indexPath) as? BasketCell else { fatalError("Don't create cell") }
            cell.loadTableView(delegate: self)
            cell.update(basketModel)
            return cell
        case 1:
            let text = basketVM.modalAtFeatures(indexPath.row)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BasketTableViewCell.identifier, for: indexPath) as? BasketTableViewCell else { fatalError("Don't create BasketTableViewCell") }
            cell.titleLabel.text = text
            return cell
        default: return UITableViewCell()
        }
    }
    
}
