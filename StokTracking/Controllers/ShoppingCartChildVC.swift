//
//  BasketChildVC.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 20.12.2022.
//

import UIKit


class ShoppingCartChildVC: UIViewController {
    
    var bottom: CGFloat!
    weak var childVM: ShoppingChildViewModel!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        tableView.separatorEffect = .none
        tableView.register(ShoppingTableViewCell.self)
        return tableView
    }()
    
    deinit {
        print("I'm deinit: BasketChildVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupHierarchy()
    }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().multipliedBy(bottom)
            make.left.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(200)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 14
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchPoint: CGPoint = touch.location(in: self.view)
            if !tableView.frame.contains(touchPoint) {
                closeChild()
            }
        }
    }
    
    func closeChild() {
        self.didMove(toParent: nil)
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
}

extension ShoppingCartChildVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childVM.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let text = childVM.modalAt(indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingTableViewCell.identifier, for: indexPath) as? ShoppingTableViewCell else { fatalError() }
        cell.titleLabel.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        closeChild()
        childVM.selectRow(indexPath.row)
    }
}
