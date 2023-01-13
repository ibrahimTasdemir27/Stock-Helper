//
//  ArrangedProductVC.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 2.12.2022.
//

import UIKit
import SnapKit
import SwiftQRScanner


class ArrangedProductVC: UIViewController {
    
    lazy var contentViewProduct : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 45
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.backgroundColor = .white
        return view
    }()
    
    lazy var contentViewQRCode: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 45
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.backgroundColor = .white
        return view
    }()
    
    lazy var productImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: arrangedVM.imageName)
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
        button.tintColor = .secondaryColor
        button.setImage(Icons.plus.image.withConfiguration(Icons.plus.image.config(40)), for: .normal)
        button.addTarget(self, action: #selector(tappedAddCell), for: .touchUpInside)
        return button
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        //collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(AddProductCollectionViews.self, forCellWithReuseIdentifier: AddProductCollectionViews.identifier)
        return collection
    }()
    
    deinit {
        print("I'm deinit: ArrangedProductVC")
    }
    
    var arrangedVM: ArrangedViewModel!
    var delegate: ArrangeProductDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrangedVM.viewDidLoad()
        initViewModel()
        setupUI()
        setupHierarchy()
    }
    
    private func initViewModel() {
        arrangedVM.onUpdate = { [weak self] in
            self?.collectionView.reloadData()
        }
        arrangedVM.showError = { [weak self] error in
            prepareError(vc: self!, error: error)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        arrangedVM.viewDidDisappear()
    }
    
    @objc private func tappedQR() {
        arrangedVM.requestAuthorization { permission in
            if permission {
                self.arrangedVM.prepareScanner(self)
            }
        }
    }
    
    @objc private func tappedAddCell() {
        arrangedVM.tappedAddCell()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
        navigationItem.title = arrangedVM.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    @objc private func tappedDone() {
        if let delegate = self.delegate, let navigationController = self.navigationController {
            if arrangedVM.tappedDone() {
                delegate.didFinishArrengeItem(vm: arrangedVM.updatedModel(), nav: navigationController)
            }
        }
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
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalToSuperview().multipliedBy(0.5)
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
            make.height.width.equalTo(50)
        }
    }
    
}

extension ArrangedProductVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrangedVM.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let features = arrangedVM.modalAt(indexPath.row)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddProductCollectionViews.identifier, for: indexPath) as? AddProductCollectionViews else {
            return UICollectionViewCell()
        }
        cell.getDelegate(delegate: self)
        cell.update(with: features, at: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2   , height: UIScreen.main.bounds.height / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ArrangedProductVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let currentText = text + string
            let point = textField.convert(textField.bounds.origin, to: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: point)?.row {
                arrangedVM.cellUpdateTextField(indexPath, currentText)
            }
        }
        return true
    }
}
extension ArrangedProductVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText string: String) -> Bool {
        if let text = textView.text {
            let currentText = text + string
            let point = textView.convert(textView.bounds.origin, to: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: point)?.row {
                arrangedVM.cellUpdateTextView(indexPath, currentText)
            }
        }
        return true
    }
}

extension ArrangedProductVC: DidDeleteDelegate {
    func delete(_ cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return }
        arrangedVM.tappedDelete(indexPath.row)
    }
}

extension ArrangedProductVC: QRScannerCodeDelegate {
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        print(result)
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: SwiftQRScanner.QRCodeError) {
        print(error)
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print(controller)
    }
}
