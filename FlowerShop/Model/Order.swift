//
//  Order.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 26/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import Foundation

struct Order: Codable {
    let id: Int
    let description: String?
    let price: Int?
    let deliverTo: String?
    let note: String?
    let deliveredOn: Date?
    let created: Date?
    let contactPhone: String?
    let contactEmail: String?

    enum CodingKeys: String, CodingKey {
        case id
        case description = "description"
        case price
        case deliverTo = "deliver_to"
        case note = "note"
        case deliveredOn
        case created
        case contactPhone = "contact_phone"
        case contactEmail = "contact_email"
    }
    
}
