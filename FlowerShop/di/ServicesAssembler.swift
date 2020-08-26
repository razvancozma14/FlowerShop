//
//  ServicesAssembler.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 25/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import Foundation

fileprivate var sharedInstances: [String : Any] = [:]

protocol ServicesAssembler {
     func resolve() -> FlowerShopService
    func resolve() -> FlowerShopRepository
}

extension ServicesAssembler where Self: Assembler {
    func resolve() -> FlowerShopService {
        let key = String(describing: FlowerShopService.self)
        if let instance = sharedInstances[key] as? FlowerShopService {
            return instance
        }
        let service = FlowerShopService(appSchedulers: resolve())
        
        sharedInstances[key] = service
        return service
    }
    
    func resolve() -> FlowerShopRepository {
        let key = String(describing: FlowerShopRepository.self)
        if let instance = sharedInstances[key] as? FlowerShopRepository {
            return instance
        }
        let service = FlowerShopRepository(flowerShopService: resolve(), ordersDbHelper: resolve(), schedulers: resolve())
        
        sharedInstances[key] = service
        return service
    }
}
