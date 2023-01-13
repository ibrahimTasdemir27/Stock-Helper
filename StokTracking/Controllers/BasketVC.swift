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
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelectionDuringEditing = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray6
        tableView.rowHeight = 60
        tableView.register(BasketCell.self)
        return tableView
    }()
    
    lazy var sellButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Satıldı", for: .normal)
        button.addTarget(self, action: #selector(tappedSell), for: .touchUpInside)
        return button
    }()
    
    lazy var slit: UILabel = {
        let label = UILabel()
        label.text = "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    lazy var contentDetailShopping: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    lazy var detailShoppingPrice: PadLabel = {
        let label = PadLabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16.5, weight: .semibold)
        label.edgeInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return label
    }()
    
    deinit {
        print("I'm deinit: BasketVC")
    }
    
    weak var basketVM: BasketViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        setupUI()
        setupHierarchy()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        basketVM.viewDidDisappear()
    }
    
    private func initViewModel() {
        basketVM.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        basketVM.readPrice = { [weak self] in
            self?.detailShoppingPrice.text = self?.basketVM.totalBasket.description
        }
    }
    
    @objc private func tappedSell() {
        basketVM.tappedSell()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        navigationItem.title = basketVM.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupHierarchy() {
        view.addSubview(contentViewQRCode)
        view.addSubview(tableView)
        view.addSubview(slit)
        view.addSubview(contentDetailShopping)
        contentDetailShopping.addSubview(detailShoppingPrice)
        contentDetailShopping.addSubview(sellButton)
        contentViewQRCode.addSubview(QRCodeImageView)
        
        contentViewQRCode.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(statusBarNavigationHeight + 20)
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
            make.bottom.equalToSuperview().offset(-screenHeight * 0.2)
        }
        slit.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(5)
        }
        contentDetailShopping.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(slit.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        detailShoppingPrice.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(30)
        }
        sellButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-screenWidth * 0.0618)
            make.left.equalTo(detailShoppingPrice.snp.right)
            make.height.equalTo(40)
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
        return basketVM.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let basketModel = basketVM.modalAt(indexPath.row) else { fatalError("Don't make model at basket") }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasketCell.identifier, for: indexPath) as? BasketCell else { fatalError("Don't create cell") }
        cell.loadTableView(delegate: self)
        cell.update(basketModel)
        return cell
    }
}

extension BasketVC: DidShowListDelegate {
    func showList(cell: UITableViewCell) {
        guard let index = tableView.indexPath(for: cell)?.row else { return }
        basketVM.selectedIndex = index
        basketVM.showList(index)
    }
    
    func selectProduct(vm: BasketModel) {
        basketVM.updateBasket(vm)
    }
    
    func updatePrice(_ cell: UITableViewCell, _ vm: BasketModel) {
        guard let index = tableView.indexPath(for: cell)?.row else { return }
        basketVM.updatePrice(index,vm)
        basketVM.readPrice()
    }
}


extension BasketVC: UITextFieldDelegate {
    
}
