//
//  HomePageCell.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 6.11.2022.
//

import UIKit
import SnapKit

final class HomePageCell : UITableViewCell {
    
    var viewModel : [TitleModel]!
    private let titleView = UIView()
    private let productView = UIView()
    let productImageView = UIImageView()
    private let baseCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupHierarchy()
    }
    
    private func setupViews() {
        baseCollectionView.delegate = self
        baseCollectionView.dataSource = self
        baseCollectionView.register(BaseCollectionViews.self, forCellWithReuseIdentifier: BaseCollectionViews.identifier)
        
        productView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        productView.layer.cornerRadius = 40
        productView.layer.borderWidth = 1
        productView.layer.borderColor = UIColor.gray.cgColor
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
          super.setSelected(selected, animated: animated)
          if selected{
              UIView.animate(withDuration: 0.2, animations: {
                  self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
              }, completion: { finished in
                  UIView.animate(withDuration: 0.2) {
                      self.transform = .identity
                  }
              })
          }
      }
    
    private func setupHierarchy() {
        contentView.addSubview(titleView)
        contentView.addSubview(productView)
        productView.addSubview(productImageView)
        titleView.addSubview(baseCollectionView)
        
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
        
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(productView.snp.right).offset(10)
            make.right.equalToSuperview()
            make.height.equalToSuperview()
        }
        baseCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension HomePageCell : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseCollectionViews.identifier, for: indexPath) as? BaseCollectionViews else {
            return UICollectionViewCell()
        }
        cell.update(with: viewModel[indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: baseCollectionView.bounds.width / 2 , height: baseCollectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
