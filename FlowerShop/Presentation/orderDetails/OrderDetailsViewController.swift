//
//  OrderDetailsViewController.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 26/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import UIKit
import RxSwift

class OrderDetailsViewController: UIViewController {
    private let navigator: NavigatorType
    private let viewModel: OrderDetailsViewModel
    private let disposeBag = DisposeBag()
    private lazy var ordersTableView: UITableView = {
        let tableview = UITableView(frame: CGRect.zero)
        tableview.register(OrderTitleTableViewCell.self, forCellReuseIdentifier: "OrderTitleTableViewCell")
        tableview.register(OrderNoteTableViewCell.self, forCellReuseIdentifier: "OrderNoteTableViewCell")
        tableview.register(SuborderTableViewCell.self, forCellReuseIdentifier: "SuborderTableViewCell")
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 100
        tableview.separatorStyle = .none
        tableview.backgroundColor = .clear
        return tableview
    }()
    
    init(viewModel: OrderDetailsViewModel, navigator: NavigatorType) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.UI.defaultBackgroundColor
        self.view.addSubview(ordersTableView)
        ordersTableView.leadingAnchor(equalTo: view.leadingAnchor)
            .trailingAnchor(equalTo: view.trailingAnchor)
            .topAnchor(equalTo: view.safeAreaLayoutGuide.topAnchor)
            .bottomAnchor(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ordersTableView.reloadData()
        setupBindings()
        viewModel.fetchData()
    }
    
    func setupBindings(){
        viewModel.orderUIItems
            .bind(to: ordersTableView.rx.items){(tableView, row, item) -> UITableViewCell in
                let indexPath = IndexPath.init(row: row, section: 0)
                switch item {
                case .orderTitle(let name):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTitleTableViewCell", for: indexPath) as! OrderTitleTableViewCell
                    cell.nameLabel.text = name
                    return cell
                case .notes(let comment):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "OrderNoteTableViewCell", for: indexPath) as! OrderNoteTableViewCell
                    cell.noteContentLable.text = comment
                    return cell
                case .details(let detailsTitle, let detailsSubtitle):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SuborderTableViewCell", for: indexPath) as! SuborderTableViewCell
                    cell.titleLabel.text = detailsTitle
                    cell.subTitleLabel.text = detailsSubtitle
                    return cell
                }
        }.disposed(by: disposeBag)
    }
}
