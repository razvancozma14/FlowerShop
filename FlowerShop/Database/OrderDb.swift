//
//  OrderDb.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 25/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import SQLite

struct OrderDb {
    static let table = Table("Order")
    static let id = Expression<Int>("id")
    static let description = Expression<String?>("description")
    static let price = Expression<Int?>("price")
    static let deliverTo = Expression<String?>("deliverTo")
    static let note = Expression<String?>("note")
    static let deliveredOn = Expression<Date?>("deliveredOn")
    static let created = Expression<Date?>("created")
    static let contactPhone = Expression<String?>("contactPhone")
    static let contactEmail = Expression<String?>("contactEmail")
}
