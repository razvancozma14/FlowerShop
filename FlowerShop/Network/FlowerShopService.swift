//
//  FlowerShopService.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 25/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import RxSwift
import Moya

class FlowerShopService{
    
    private let appSchedulers: AppSchedulers
    private let decoder = JSONDecoder()
    private let endpoint: MoyaProvider<FlowerShopApi>
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()
    
    init(appSchedulers: AppSchedulers){
        self.appSchedulers = appSchedulers
        
        let shopServiceEndpointClosure = {
            (target: FlowerShopApi) -> Endpoint in
            let apiUrl = URL(string: Constants.NetworkAPI.shopEndpoint)!
            let url = apiUrl.appendingPathComponent(target.path).absoluteString
            return Endpoint(url: url, sampleResponseClosure: { .networkResponse(200, target.sampleData) }, method: target.method, task: target.task, httpHeaderFields: target.headers);
        }
        
        let networkPlugins: [PluginType] = [NetworkLoggerPlugin(configuration:
            NetworkLoggerPlugin.Configuration(
                formatter: NetworkLoggerPlugin.Configuration.Formatter(responseData: JSONResponseDataFormatter),
                logOptions: NetworkLoggerPlugin.Configuration.LogOptions.formatRequestAscURL))]
        
        self.endpoint = MoyaProvider<FlowerShopApi>(endpointClosure: shopServiceEndpointClosure, plugins: networkPlugins)
    }
    
    func requestOrders() -> Single<[Order]>{
        let jsonDecoder = decoder
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return endpoint.rx.request(.getOrders)
            .subscribeOn(appSchedulers.network)
            .observeOn(appSchedulers.computation)
            .catchError({ (error) -> PrimitiveSequence<SingleTrait, Response> in
                throw CoreError.network(statusCode: -1)
            })
            .map { (response) -> [Order] in
                guard response.statusCode == 200 && !response.data.isEmpty else {
                    throw CoreError.network(statusCode: response.statusCode)
                }
                do {
                    return try jsonDecoder.decode([Order].self, from: response.data)
                } catch (let error) {
                    throw CoreError.decodingResponse(error: error)
                }
        }
    }
}

