//
//  MigrationHelper.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 25/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import SQLite

class MigrationHelper {
    private let databaseVersion: Int32 = 1
    
    let db: Connection
    let ordersDbHelper: OrdersDbHelper
    
    init( db: Connection,
          ordersDbHelper: OrdersDbHelper
    ){
        self.db = db
        self.ordersDbHelper = ordersDbHelper
    }
    
    func updateDatabase() {
        let dbVersion = db.userVersion
        if dbVersion <= 0 {
            do {
                try db.transaction {
                    try ordersDbHelper.createTable()
                    db.userVersion = databaseVersion
                }
            } catch _ {}
            return
        }
    }
}

extension Connection {
    public var userVersion: Int32 {
        get { return Int32(try! scalar("PRAGMA user_version") as! Int64)}
        set { try! run("PRAGMA user_version = \(newValue)") }
    }
    
    public func exists(column: String, in table: String) throws -> Bool {
        let stmt = try prepare("PRAGMA table_info(\(table))")
        
        let columnNames = stmt.makeIterator().map { (row) -> String in
            return row[1] as? String ?? ""
        }
        
        return columnNames.contains(where: { dbColumn -> Bool in
            return dbColumn.caseInsensitiveCompare(column) == ComparisonResult.orderedSame
        })
    }
}
