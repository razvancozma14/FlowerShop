//
//  DaoAssembler.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 25/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import SQLite

fileprivate var sharedInstances: [String : Any] = [:]

protocol DaoAssembler {
    func resolve() -> Connection
    func resolve() -> OrdersDbHelper
    func resolve() -> MigrationHelper
}
extension DaoAssembler where Self: Assembler {
    func resolve() -> Connection {
        let key = String(describing: Connection.self)
        
        if let con = sharedInstances[key] as? Connection {
            return con
        }
        
        let dbConnection = try! Connection(filetWith(name: "orders_database.db"))
        sharedInstances[key] = dbConnection
        
        return dbConnection
    }
    
    func resolve() -> OrdersDbHelper {
        let key = String(describing: OrdersDbHelper.self)
        
        if let instance = sharedInstances[key] as? OrdersDbHelper {
            return instance
        }
        
        let instance = OrdersDbHelper(db: resolve())
        sharedInstances[key] = instance
        
        return instance
    }
    
    func resolve() -> MigrationHelper {
        let key = String(describing: MigrationHelper.self)
        if let instance = sharedInstances[key] as? MigrationHelper {
            return instance
        }
        
        let instance = MigrationHelper(db: resolve(), ordersDbHelper: resolve())
        sharedInstances[key] = instance
        
        return instance
    }
}
fileprivate func filetWith(name: String) -> String {
    let x = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    return URL(fileURLWithPath: x).appendingPathComponent(name).path;
}
