//
//  RegulationVC.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 8.11.2022.
//

import UIKit
import SnapKit
import SwiftQRScanner


class AddProductVC : UIViewController {
    
    var addProductVM : AddProductViewModel!
    var delegate : FinishAddProductDidSave?
    lazy var contentViewProduct : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 60
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.backgroundColor = .white
        return view
    }()
    lazy var contentViewQRCode: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 60
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.backgroundColor = .white
        return view
    }()
    lazy var productImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "product")
        return imageView
    }()
    lazy var QRCodeImageView : UIImageView = {
        let imageView = UIImageView()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedQR))
        imageView.addGestureRecognizer(gestureRecognizer)
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "qrscan")
        return imageView
    }()
    lazy var addCell: UIButton = {
        let button = UIButton()
        button.setImage(Icons.plus.image.withConfiguration(Icons.plus.image.config(40)), for: .normal)
        button.addTarget(self, action: #selector(tappedAddCell), for: .touchUpInside)
        button.tintColor = .purple
        button.shadowLayer()
        return button
    }()
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = .zero
        collection.backgroundColor = .systemGray6
        collection.delegate = self
        collection.dataSource = self
        collection.register(AddProductCollectionViews.self, forCellWithReuseIdentifier: AddProductCollectionViews.identifier)
        return collection
    }()
    
    deinit {
        print("AddproductVC: I'm deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addProductVM.viewDidLoad()
        initViewModel()
        setupUI()
        setupHierarchy()
    }
    
    private func initViewModel() {
        addProductVM.onUpdate = { [weak self] in
            self?.collectionView.reloadData()
        }
        addProductVM.showError = { [weak self] error in
            prepareError(vc: self!, error: error)
        }
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        addProductVM.viewDidDisappear()
    }
    
    @objc private func tappedQR() {
        addProductVM.requestAuthorization { permission in
            if permission {
                self.addProductVM.prepareScanner(self)
            }
        }
    }
    
    @objc private func tappedAddCell() {
        addProductVM.tappedAddCell()
    }
    
    @objc private func tappedDone() {
        if let delegate = self.delegate {
            if addProductVM.tappedDone() {
                delegate.didSaveProduct(vm: addProductVM.updateModal())
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
        navigationItem.title = addProductVM.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    private func setupHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(contentViewProduct)
        view.addSubview(contentViewQRCode)
        view.addSubview(addCell)
        contentViewProduct.addSubview(productImage)
        contentViewQRCode.addSubview(QRCodeImageView)
        
        contentViewProduct.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(statusBarNavigationHeight + 20)
            make.left.equalToSuperview().offset(screenWidth * 0.05)
            make.width.equalTo(screenWidth * 0.4)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        productImage.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        contentViewQRCode.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(statusBarNavigationHeight + 20)
            make.right.equalToSuperview().offset(-screenWidth * 0.05)
            make.width.equalTo(screenWidth * 0.4)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        QRCodeImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(contentViewQRCode.snp.bottom).offset(screenHeight * 0.0113)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        addCell.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-screenHeight * 0.1)
            make.right.equalTo(view.layoutMarginsGuide.snp.right)
            make.height.width.equalTo(60)
        }
    }
    
}



extension AddProductVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addProductVM.features.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let features = addProductVM.features[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddProductCollectionViews.identifier, for: indexPath) as? AddProductCollectionViews else {
            return UICollectionViewCell()
        }
        cell.update(with: features, at: indexPath.row)
        cell.getDelegate(delegate: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2   , height: UIScreen.main.bounds.height / 4)
    }
}

extension AddProductVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else {return false}
        let text = currentText + string
        let point = textField.convert(textField.bounds.origin, to: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point) {
            addProductVM.cellUpdateTextField(indexPath , text)
        }
        return true
    }
}

extension AddProductVC : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentText = textView.text else {return false}
        let text = currentText + text
        let point = textView.convert(textView.bounds.origin, to: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point) {
            addProductVM.cellUpdateTextView(indexPath,text)
        }
        return true
    }
}

extension AddProductVC: DidDeleteDelegate {
    func delete(_ cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        addProductVM.tappedDelete(indexPath.row)
    }
}

extension AddProductVC : QRScannerCodeDelegate {
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        print("Result",result)
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: SwiftQRScanner.QRCodeError) {
        print("Error",error)
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("controller",controller)
    }
}
