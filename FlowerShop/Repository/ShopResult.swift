//
//  ShopResult.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 26/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import Foundation

protocol Result {}

enum ShopResult: Result {
    case homeOrders(orders: [Order])
    case showLoading
    case orderDetails(order: Order)
    case error(error: Error)
}

enum CoreError: Swift.Error {
    case network(statusCode: Int)
    case decodingResponse(error: Swift.Error)
}
