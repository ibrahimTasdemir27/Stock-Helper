
import UIKit
import SnapKit

class HomeVC : UIViewController {
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = screenHeight * 0.2 + 10
        tableView.register(HomePageCell.self)
        return tableView
    }()
    lazy var plusProduct: UIButton = {
        let button = UIButton()
        DispatchQueue.main.async {
            button.layer.masksToBounds = true
            button.layer.cornerRadius = button.frame.size.width / 2
        }
        button.backgroundColor = .systemGray6
        button.setImage(Icons.plus.image.withConfiguration(Icons.plus.image.config(40)), for: .normal)
        button.addTarget(self, action: #selector(tappedAdd), for: .touchUpInside)
        button.tintColor = .secondaryColor
        return button
    }()
    lazy var shoppingBasket: UIButton = {
        let button = UIButton()
        DispatchQueue.main.async {
            button.layer.masksToBounds = true
            button.layer.cornerRadius = button.frame.size.width / 2
        }
        button.backgroundColor = .systemGray6
        button.setImage(Icons.shopping.image.withConfiguration(Icons.shopping.image.config(40)), for: .normal)
        button.addTarget(self, action: #selector(tappedBasket), for: .touchUpInside)
        button.tintColor = .secondaryColor
        return button
    }()
    
    var viewModel : FeaturesListViewModel!
    
    var delegate: ArrangeProductDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        initViewModel()
        setupUI()
        setupHierarchy()

    }
    
    
    func initViewModel() {
        viewModel.onUpdate = {
            self.tableView.reloadData()
        }
    }
    
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        navigationItem.title = viewModel.title 
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
        view.addSubview(shoppingBasket)
        view.addSubview(plusProduct)
    
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        shoppingBasket.snp.makeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(20)
            make.right.equalTo(view.layoutMarginsGuide.snp.right)
            make.height.width.equalTo(60)
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
    
    @objc private func tappedBasket() {
        viewModel.tappedBasket()
    }
}

extension HomeVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imageName = viewModel.imageName(indexPath.section)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomePageCell.identifier, for: indexPath) as? HomePageCell
        else { return UITableViewCell()}
        cell.productImageView.image = UIImage(named: imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? HomePageCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            tableView.cellForRow(at: indexPath)?.bounce()
            viewModel.selectedIndex = indexPath.section
            delegate.arrengedItem(vm: viewModel.modalAt(indexPath.section))
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            viewModel.removeItem(indexPath: indexPath.section)
        }
    }
}

extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.featuresVM[collectionView.tag].titleModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseCollectionViews.identifier, for: indexPath) as? BaseCollectionViews else {
            return UICollectionViewCell()
        }
        let model = viewModel.modelAt(collectionView.tag, indexPath.row)
        cell.update(vm: model)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2 , height: collectionView.bounds.height)
    }
}
