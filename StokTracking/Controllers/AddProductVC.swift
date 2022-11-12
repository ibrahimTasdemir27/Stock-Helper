//
//  RegulationVC.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 8.11.2022.
//

import UIKit
import SnapKit

class AddProductVC : UIViewController {
    
    var viewModel : AddProductViewModel!
    private let contentViewProduct = UIView()
    private let contentViewQRCode = UIView()
    private let productImage = UIImageView()
    private let QRCodeImageView = UIImageView()
    private let addCell = UIButton()
    
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        viewModel.onUpdate = {
            self.collectionView.reloadData()
        }
        setupViews()
        configure()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    private func setupViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        pickerView.delegate = self
        pickerView.dataSource = self
        collectionView.register(AddProductCollectionViews.self, forCellWithReuseIdentifier: AddProductCollectionViews.identifier)
        
        view.backgroundColor = .white
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showPickerview))
        productImage.addGestureRecognizer(gestureRecognizer)
        productImage.isUserInteractionEnabled = true
        productImage.image = UIImage(named: "product")
        QRCodeImageView.image = UIImage(named: "qrcode")
        
        contentViewProduct.layer.cornerRadius = 60
        contentViewProduct.layer.borderWidth = 1
        contentViewProduct.layer.borderColor = UIColor.gray.cgColor
        contentViewProduct.backgroundColor = .lightGray.withAlphaComponent(0.2)
        
        contentViewQRCode.layer.cornerRadius = 60
        contentViewQRCode.layer.borderWidth = 1
        contentViewQRCode.layer.borderColor = UIColor.gray.cgColor
        contentViewQRCode.backgroundColor = .lightGray.withAlphaComponent(0.2)
        
        addCell.setImage(Icons.plus.imageName.withConfiguration(Icons.plus.imageName.config(40)), for: .normal)
        addCell.addTarget(self, action: #selector(tappedAddCell), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
        navigationItem.title = "Add Product"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    private func configure() {
        view.addSubview(collectionView)
        view.addSubview(contentViewProduct)
        view.addSubview(contentViewQRCode)
        view.addSubview(addCell)
        contentViewProduct.addSubview(productImage)
        contentViewQRCode.addSubview(QRCodeImageView)
        let navBarHeight = UIApplication.shared.statusBarHeight + (navigationController?.navigationBar.frame.height ?? 0.0)
        
        contentViewProduct.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(navBarHeight + 10)
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
            make.top.equalToSuperview().offset(navBarHeight + 10)
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
    
    @objc private func tappedAddCell() {
        viewModel.tappedAddCell()
    }
    
    @objc private func tappedDone() {
        viewModel.tappedDone(image: "medicine1")
    }
    
    @objc func showPickerview() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "Choose distance", message: "", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
}

extension AddProductVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel.addingcell[0] {
        case .title(let titleModel):
            return titleModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddProductCollectionViews.identifier, for: indexPath) as? AddProductCollectionViews else {
            return UICollectionViewCell()
        }
        switch viewModel.addingcell[0] {
        case .title(let titleModel):
            cell.update(with: titleModel[indexPath.row])
            cell.titleTextField.delegate = self
            cell.overviewTextView.delegate = self
            if indexPath.row >= 0 {
                cell.titleTextField.isUserInteractionEnabled = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2   , height: UIScreen.main.bounds.height / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension AddProductVC : UIPickerViewDelegate , UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return imageList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return imageAbout[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
}

extension AddProductVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else {return false}
        let text = currentText + string
        let point = textField.convert(textField.bounds.origin, to: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point) {
            viewModel.cellUpdateTextField(indexPath , text)
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
            viewModel.cellUpdateTextView(indexPath,text)
        }
        return true
    }
}
