//
//  PresentationAssembler.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 25/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import Foundation

protocol PresentationAssembler {
    func resolve() -> NavigatorType
    func resolve() -> HomeViewModel
    func resolve() -> HomeviewControlller
    func resolve(orderId: Int) -> OrderDetailsViewModel
    func resolve(orderId: Int) -> OrderDetailsViewController
}

extension PresentationAssembler where Self: Assembler {
    func resolve() -> NavigatorType {
        return Navigator(assembler: self)
    }
    
    func resolve() -> HomeViewModel{
        return HomeViewModel(shopRepository: resolve(), schedulers: resolve())
    }
    
    func resolve() -> HomeviewControlller{
        return HomeviewControlller(viewModel: resolve(), navigator: resolve())
    }
    
    func resolve(orderId: Int) -> OrderDetailsViewModel{
        return OrderDetailsViewModel(orderId: orderId, shopRepository: resolve(), schedulers: resolve())
    }
    
    func resolve(orderId: Int) -> OrderDetailsViewController{
        return OrderDetailsViewController(viewModel: resolve(orderId: orderId), navigator: resolve())
    }
}
