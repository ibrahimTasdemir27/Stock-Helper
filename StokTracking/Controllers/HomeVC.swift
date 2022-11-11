//
//  HomeVC.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 6.11.2022.
//

import UIKit
import SnapKit

class HomeVC : UIViewController {
    
    
    private let tableView = UITableView()
    private let plusProduct = UIButton()
    var viewModel : HomePageCellViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        viewModel.onUpdate = {
            self.tableView.reloadData()
        }
        configure()
        setupTableViews()
    }
    
    private func setupTableViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomePageCell.self, forCellReuseIdentifier: "HomePageCell")
        
        plusProduct.setImage(Icons.plus.imageName.withConfiguration(Icons.plus.imageName.config(40)), for: .normal)
        plusProduct.addTarget(self, action: #selector(tappedAdd), for: .touchUpInside)
    }
    
    private func configure() {
        view.addSubview(tableView)
        view.addSubview(plusProduct)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        plusProduct.snp.makeConstraints { make in
            make.right.equalTo(view.layoutMarginsGuide.snp.right)
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
            make.height.width.equalTo(60)
        }
    }
    
    @objc private func tappedAdd() {
        viewModel.tappedAdd()
    }
}

extension HomeVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.superTitleCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomePageCell", for: indexPath) as? HomePageCell
        else { return UITableViewCell()}
        switch viewModel.superTitleCells[indexPath.row] {
        case .imageAndText(let titleViewModel):
            cell.selectionStyle = .none
            cell.viewModel = titleViewModel.titleModel
            cell.productImageView.image = UIImage(named: titleViewModel.imageName)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight * 0.2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch viewModel.superTitleCells[indexPath.row] {
        case .imageAndText(let titleViewModel):
            titleViewModel.titleModel.forEach {
                print($0.title)
            }
        }
        viewModel.selectedItem(indexPath.row)
    }
}
