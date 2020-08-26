//
//  OrdersDbHelper.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 25/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import SQLite
import RxSwift

class OrdersDbHelper{
    let connection: Connection
    init(db: Connection) {
        self.connection = db
    }
    
    func createTable() throws {
        try self.connection.run(OrderDb.table.create(ifNotExists: true) { t in
            t.column(OrderDb.id, primaryKey: true)
            t.column(OrderDb.description)
            t.column(OrderDb.price)
            t.column(OrderDb.deliverTo)
            t.column(OrderDb.note)
            t.column(OrderDb.deliveredOn)
            t.column(OrderDb.created)
            t.column(OrderDb.contactPhone)
            t.column(OrderDb.contactEmail)
        })
    }
    
    func insert(orders: [Order]) throws {
        try connection.run(OrderDb.table.delete())
        for item in orders {
            try connection.run(
                OrderDb.table.insert(or: OnConflict.replace,
                    OrderDb.id <- item.id,
                    OrderDb.description <- item.description,
                    OrderDb.price <- item.price,
                    OrderDb.deliverTo <- item.deliverTo,
                    OrderDb.note <- item.note,
                    OrderDb.deliveredOn <- item.deliveredOn,
                    OrderDb.created <- item.created,
                    OrderDb.contactPhone <- item.contactPhone,
                    OrderDb.contactEmail <- item.contactEmail
                )
            )
        }
    }
    
    func loadOrderSingle(id: Int) -> Single<Order?> {
            return Single.deferred { [weak self] () -> Single<Order?> in
                return Single.just(try self?.loadOrderBy(id: id))
            }
        }
    
    func loadOrderBy(id: Int) throws -> Order? {
        let filter = OrderDb.table.filter(OrderDb.id == id)
        
        guard let row = try connection.pluck(filter) else {
            return nil
        }
        return Order(id: row[OrderDb.id],
        description: row[OrderDb.description],
        price: row[OrderDb.price],
        deliverTo: row[OrderDb.deliverTo],
        note: row[OrderDb.note],
        deliveredOn: row[OrderDb.deliveredOn],
        created: row[OrderDb.created],
        contactPhone: row[OrderDb.contactPhone],
        contactEmail: row[OrderDb.contactEmail])
    }
      
}


