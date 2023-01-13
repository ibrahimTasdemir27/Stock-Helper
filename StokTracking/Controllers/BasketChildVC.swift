//
//  BasketChildVC.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 20.12.2022.
//

import UIKit


class BasketChildVC: UIViewController {
    
    
    var bottom:CGFloat!
    weak var childVM: BasketChildViewModel!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        tableView.register(BasketTableViewCell.self)
        return tableView
    }()
    
    deinit {
        print("I'm deinit: BasketChildVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupHierarchy()
    }
    
    func setupHierarchy() {
        view.addSubview(tableView)
        let height = 40 * childVM.numberOfRows()
        
        tableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().multipliedBy(bottom)
            make.left.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(height)
        }
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

extension BasketChildVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childVM.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let text = childVM.modalAt(indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasketTableViewCell.identifier, for: indexPath) as? BasketTableViewCell else { fatalError() }
        cell.titleLabel.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        closeChild()
        childVM.selectRow(indexPath.row)
    }
}
