//
//  SettingsVC.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 6.11.2022.
//

import UIKit

class SettingsVC : UIViewController {
    
    let settingsVM = SettingsViewModel()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupHierarchy()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        navigationItem.title = settingsVM.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(self.statusBarNavigationHeight + 10)
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsVM.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as? SettingsCell else { fatalError("Don't create cell") }
        let text = settingsVM.modalAt(indexPath.row)
        cell.update(text, indexPath.row)
        return cell
    }
}
