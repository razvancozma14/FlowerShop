//
//  HomeViewModel.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 25/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import RxSwiftExt
import RxSwift
import RxCocoa

class HomeViewModel {
    public enum HomeError {
        case internetError(String)
    }
    
    let ordersUIItems : PublishSubject<[Order]> = PublishSubject()
    let uiEvents: PublishSubject<UIEvent> = PublishSubject<UIEvent>()
    let loading: PublishSubject<Bool> = PublishSubject()
    let error : PublishSubject<HomeError> = PublishSubject()
    
    private let shopRepository: FlowerShopRepository
    private let schedulers: AppSchedulers
    private let disposable = DisposeBag()
    
    init(shopRepository: FlowerShopRepository,
         schedulers: AppSchedulers){
        self.schedulers = schedulers
        self.shopRepository = shopRepository
    }
    
    func requestData(){
        uiEvents.ofType(HomeOrdersEvent.self)
            .startWith(HomeOrdersEvent())
            .do(onNext: {[unowned self] (orders) in
                self.loading.onNext(true)
            })
            .observeOn(schedulers.computation)
            .flatMapLatest{[unowned self] _ in
                return self.shopRepository.requestOrders()
        }.do(onNext: {[unowned self] (result) in
            self.loading.onNext(false)
            switch result {
            case ShopResult.homeOrders(let orders):
                self.ordersUIItems.onNext(orders)
            case ShopResult.error(let error):
                print(error)
                self.error.onNext(.internetError("Something went wrong"))
            default: break
            }
        })
            .subscribe()
            .disposed(by: disposable)
    }
    
    func retry(){
        uiEvents.onNext(HomeOrdersEvent())
    }
    
}
