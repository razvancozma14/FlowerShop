//
//  Assembler.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 25/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import RxSwift

fileprivate var sharedInstances: [String : Any] = [:]

protocol Assembler: PresentationAssembler, ServicesAssembler, DaoAssembler {
    func resolve() -> AppSchedulers
}

class AppAssembler: Assembler {
    func resolve() -> AppSchedulers {
        let key = String(describing: AppSchedulers.self)
        if let instance = sharedInstances[key] as? AppSchedulers {
            return instance
        }
        
        let diskScheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "disk_serial_queue")
        let networkScheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "network_serial_queue")
        let computationScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        let instance = AppSchedulers(main: MainScheduler.instance, disk: diskScheduler, network: networkScheduler, computation: computationScheduler)
        sharedInstances[key] = instance
        
        return instance
    }
}
