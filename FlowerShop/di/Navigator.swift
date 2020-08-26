//
//  Navigator.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 25/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import UIKit

protocol NavigatorType {
    func navigateToDetails(orderId: Int, sourceViewController: UIViewController)
}

struct Navigator: NavigatorType {
    let assembler: Assembler
    
    init(assembler: Assembler) {
        self.assembler = assembler
    }
    
    func navigateToDetails(orderId: Int, sourceViewController: UIViewController){
        let detailsVC: OrderDetailsViewController = assembler.resolve(orderId: orderId)
        sourceViewController.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}
