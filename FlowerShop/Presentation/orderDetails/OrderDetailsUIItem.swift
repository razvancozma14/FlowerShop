//
//  OrderDetailsUIItem.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 26/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import Foundation

enum OrderDetailsUIItem{
    case orderTitle(name: String)
    case notes(comment: String)
    case details(detailsTitle: String, detailsSubtitle: String)
}

