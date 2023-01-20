//
//  HomePageCell.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 6.11.2022.
//

import UIKit
import SnapKit

class HomePageCell : UITableViewCell, SkeletonLoadable {
    
    class var identifier: String {
        return String(describing: self)
    }
    
    let imageLayer = CAGradientLayer()
    let collectionLayer = CAGradientLayer()
    
    lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.shadowLayer()
        return imageView
    }()
    lazy var productView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
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
        collection.register(BaseCollectionViews.self)
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
        backgroundColor = .systemGray6
        
        productView.layer.addSublayer(imageLayer.caLayer())
        mainCollectionView.layer.addSublayer(collectionLayer.caLayer())
        
        let contentGroup = makeAnimationGroup()
        imageLayer.add(contentGroup, forKey: "backgroundColor")
        let detailGroup = makeAnimationGroup(previousGroup: contentGroup)
        collectionLayer.add(detailGroup, forKey: "backgroundColor")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.42) { [self] in
            imageLayer.removeAllAnimations()
            collectionLayer.removeAllAnimations()
            productImageView.isHidden = false
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageLayer.frame = productView.bounds
        imageLayer.cornerRadius = productView.layer.cornerRadius
        
        
        collectionLayer.frame = mainCollectionView.bounds
        collectionLayer.cornerRadius = 10
    }

    private func setupHierarchy() {
        contentView.addSubview(productView)
        productView.addSubview(productImageView)
        productView.addSubview(changeImage)
        productView.addSubview(QRButton)
        contentView.addSubview(mainCollectionView)
        
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
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(productView.snp.right).offset(10)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
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
