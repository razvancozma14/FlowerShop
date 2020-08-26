//
//  HomeViewController.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 25/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftExt

class HomeviewControlller: UIViewController{
    private let navigator: NavigatorType
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var ordersTableView: UITableView = {
        let tableview = UITableView(frame: CGRect.zero)
        tableview.register(OrderItemTableViewCell.self, forCellReuseIdentifier: "OrderItemTableViewCell")
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 100
        tableview.separatorStyle = .none
        tableview.backgroundColor = .clear
        return tableview
    }()
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd hh:mm"
        return dateFormatter
    }()
    
    init(viewModel: HomeViewModel, navigator: NavigatorType) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        viewModel.requestData()
        
        Observable
            .zip(ordersTableView.rx.itemSelected, ordersTableView.rx.modelSelected(Order.self))
            .bind { [unowned self] _, model in
                self.navigator.navigateToDetails(orderId: model.id, sourceViewController: self)
        }
        .disposed(by: disposeBag)
        
    }
    
    func setupBindings(){
        viewModel.error.asObservable()
            .observeOn(MainScheduler.instance)
            .do(onNext: {[unowned self]  (error) in
                self.showAlert(error: error)
            }).subscribe().disposed(by: disposeBag)
        
        viewModel.ordersUIItems.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: ordersTableView.rx.items(cellIdentifier: "OrderItemTableViewCell", cellType: OrderItemTableViewCell.self)) {[unowned self]  (row,item,cell) in
                cell.update(item: item, dateFormatter: self.dateFormatter)
        }.disposed(by: disposeBag)
        
        viewModel.loading.asObservable()
            .observeOn(MainScheduler.instance)
            .do(onNext: {[unowned self]  (show) in
                show ? self.refreshControl.beginRefreshing() : self.refreshControl.endRefreshing()
            }).subscribe().disposed(by: disposeBag)
    }
    
    private func showAlert(error: HomeViewModel.HomeError){
        var message = ""
        switch error {
        case .internetError(let error):
            message = error
        }
        let alert = UIAlertController(title: "Oooops!", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: {[unowned self] (_) in
            self.viewModel.retry()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func loadView() {
        super.loadView()
        self.title = "Home"
        view.backgroundColor = Constants.UI.defaultBackgroundColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.view.addSubview(ordersTableView)
        ordersTableView.leadingAnchor(equalTo: view.leadingAnchor)
            .trailingAnchor(equalTo: view.trailingAnchor)
            .topAnchor(equalTo: view.safeAreaLayoutGuide.topAnchor)
            .bottomAnchor(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        ordersTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)

    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        self.viewModel.retry()
    }
}
