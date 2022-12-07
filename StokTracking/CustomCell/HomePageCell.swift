//
//  HomePageCell.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 6.11.2022.
//

import UIKit
import SnapKit

class HomePageCell : UITableViewCell {
    
    class var identifier: String {
        return String(describing: self)
    }
    
    private let titleView = UIView()
    let productImageView = UIImageView()
    lazy var productView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 40
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    private let changeImage : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil.line")?.withConfiguration((UIImage(systemName: "pencil.line")?.config())!), for: .normal)
        button.tintColor = .gray
        button.backgroundColor = .clear
        return button
    }()
    private let QRButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "qricon")?.withConfiguration((UIImage(named: "qricon")?.config())!), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    private let mainCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(BaseCollectionViews.self, forCellWithReuseIdentifier: BaseCollectionViews.identifier)
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupHierarchy()
    }
    
    
    @objc private func tappedChange() {
        
    }
    
    private func setupUI() {
        selectionStyle = .none
    }

    private func setupHierarchy() {
        contentView.addSubview(titleView)
        contentView.addSubview(productView)
        productView.addSubview(productImageView)
        productView.addSubview(changeImage)
        productView.addSubview(QRButton)
        titleView.addSubview(mainCollectionView)
        
        productView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalToSuperview().multipliedBy(0.372)
        }
        productImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        changeImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-13)
            make.width.equalToSuperview().multipliedBy(0.16)
            make.height.equalTo(changeImage.snp.width)
        }
        QRButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.left.equalToSuperview().offset(13)
            make.width.equalToSuperview().multipliedBy(0.16)
            make.height.equalTo(QRButton.snp.width)
        }
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(productView.snp.right).offset(10)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        mainCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomePageCell {
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDelegate & UICollectionViewDataSource>(_ datasourceAndDelegate : D, forRow row: Int) {
        mainCollectionView.delegate = datasourceAndDelegate
        mainCollectionView.dataSource = datasourceAndDelegate
        mainCollectionView.tag = row
        mainCollectionView.setContentOffset(mainCollectionView.contentOffset, animated:false)
        mainCollectionView.reloadData()
    }
}
