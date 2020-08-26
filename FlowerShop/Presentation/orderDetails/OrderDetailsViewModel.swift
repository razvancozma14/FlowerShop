//
//  OrderDetailsViewModel.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 26/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import RxSwift

class OrderDetailsViewModel {
    let orderUIItems : PublishSubject<[OrderDetailsUIItem]> = PublishSubject()
    
    private let shopRepository: FlowerShopRepository
    private let schedulers: AppSchedulers
    private let orderId: Int
    private let disposable = DisposeBag()
    
    init(orderId: Int,
         shopRepository: FlowerShopRepository,
         schedulers: AppSchedulers){
        self.schedulers = schedulers
        self.shopRepository = shopRepository
        self.orderId = orderId
    }
    
    func fetchData(){
        shopRepository.getOrderById(id: orderId)
            .observeOn(schedulers.computation)
            .do(onNext: {[unowned self] (result) in
                switch result {
                case ShopResult.orderDetails(let order):
                    print(order)
                    let items = [
                        OrderDetailsUIItem.orderTitle(name: order.description ?? "-"),
                        OrderDetailsUIItem.details(detailsTitle: "Price", detailsSubtitle: "\(order.price ?? 0) USD"),
                        OrderDetailsUIItem.details(detailsTitle: "Recipient", detailsSubtitle: order.deliverTo ?? "-"),
                        OrderDetailsUIItem.notes(comment: order.note ?? "-"),
                        OrderDetailsUIItem.details(detailsTitle: "Phone Number", detailsSubtitle: order.contactPhone ?? "-"),
                        OrderDetailsUIItem.details(detailsTitle: "Email", detailsSubtitle: order.contactEmail ?? "-"),
                        OrderDetailsUIItem.details(detailsTitle: "Status", detailsSubtitle: order.deliveredOn == nil ? "Processing" : "Delivered")
                    ]
                    self.orderUIItems.onNext(items)
                default: break
                }
            }).subscribe()
            .disposed(by: disposable)
    }
}


