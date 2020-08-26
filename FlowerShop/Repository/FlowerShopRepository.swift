//
//  FlowerShopRepository.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 25/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import RxSwift

class FlowerShopRepository{
    private let flowerShopService: FlowerShopService
    private let ordersDbHelper: OrdersDbHelper
    private let schedulers: AppSchedulers
    
    init(flowerShopService: FlowerShopService, ordersDbHelper: OrdersDbHelper,
         schedulers: AppSchedulers){
        self.flowerShopService = flowerShopService
        self.ordersDbHelper = ordersDbHelper
        self.schedulers = schedulers
    }
    
    func requestOrders() -> Observable<Result>{
        let ordersDb = ordersDbHelper
        return flowerShopService.requestOrders().asObservable()
            .observeOn(schedulers.disk)
            .do(onNext: { (orders) in
                try ordersDb.insert(orders: orders)
            })
            .map {ShopResult.homeOrders(orders: $0)}
            .catchError { (error) -> Observable<Result> in
                return .just(ShopResult.error(error: error))
        }
    }
    
    func getOrderById(id: Int) -> Observable<Result>{
        return ordersDbHelper.loadOrderSingle(id: id)
            .subscribeOn(schedulers.disk)
            .asObservable()
            .filter {$0 != nil}
            .map {ShopResult.orderDetails(order: $0!)}
    }
    
}
