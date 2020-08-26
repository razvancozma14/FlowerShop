//
//  FlowerShopEndpoint.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 25/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import Moya
import Alamofire


enum FlowerShopApi{
    case getOrders
}

extension FlowerShopApi: TargetType {
    var baseURL: URL {
        return URL(string: Constants.NetworkAPI.shopEndpoint)!
    }
    
    var path: String {
        switch self {
        case .getOrders:
            return "/orders"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getOrders:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}

func JSONResponseDataFormatter(data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data, options: [])
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? ""
    } catch {
        return String(data: data, encoding: .utf8) ?? ""
    }
}
