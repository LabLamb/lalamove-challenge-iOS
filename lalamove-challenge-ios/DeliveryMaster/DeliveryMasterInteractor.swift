//
//  DeliveryMasterInteractor.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit.UITableView
import SwiftyJSON

class DeliveryMasterInteractor {
    
    private let localStorageAsyncHint = "DeliveryLocalStorageQueue"
    private let perPageLimit = 20
    
    var apiClient: DeliveryAPIClientInterface?
    var presenter: DeliveryMasterPresenterInterface?
    var localStorageHandler: LocalStorageHandlerInterface?
    
    init(apiClient: DeliveryAPIClientInterface = DeliveryAPIClient(),
         localStorageHandler: LocalStorageHandlerInterface = LocalStorageHandler()) {
        self.apiClient = apiClient
        self.localStorageHandler = localStorageHandler
    }
}

extension DeliveryMasterInteractor: DeliveryMasterInteractorInterface {
    
    func setupView() {
        presenter?.presentTableView()
        presenter?.presentNavigationTitle()
    }
    
    func initialFetch() {
        let jsons = fetchDeliveryJSONsFromLocal()
        let deliveriesInLocal = makeDelivers(jsons: jsons)
        
        presenter?.updateDeliveries(incomingDeliveries: deliveriesInLocal)
        fetchDeliveries()
    }
    
    func showDeliveryDetails(index: Int) {
        presenter?.presentDeliveryDetails(index: index)
    }
    
    func fetchDeliveries() {
        presenter?.refreshTableView()
        fetchDeliveriesFromAPI()
    }
    
    fileprivate func fetchDeliveriesFromAPI() {
        let pagingInfo = presenter?.getPagingInfo(limit: perPageLimit)
        apiClient?.fetchDeliveriesFromServer(paging: pagingInfo,
                                             onResponse: deliveryResponseHandler,
                                             onError: deliveryErrorHandler)
    }
    
    fileprivate func fetchDeliveryJSONsFromLocal() -> [JSON] {
        return localStorageHandler?.fetchDeliveriesFromLocal() ?? []
    }
    
    fileprivate func deliveryResponseHandler(jsonArr: [JSON]) {
        guard let presenter = self.presenter else { return }
        
        let deliveries = makeDelivers(jsons: jsonArr)
        
        if presenter.getPagingInfo(limit: perPageLimit).offset == 0 {
            cacheDataToLocal(jsonArr: jsonArr)
        }
        
        presenter.updateDeliveries(incomingDeliveries: deliveries)
    }
    
    fileprivate func deliveryErrorHandler(error: DeliveryAPICallError) {
        guard let presenter = self.presenter else { return }
        presenter.presentAPIError()
    }
    
    fileprivate func cacheDataToLocal(jsonArr: [JSON]) {
        DispatchQueue.init(label: localStorageAsyncHint).async { [weak self] in
            guard let self = self else { return }
            for i in 0..<jsonArr.count {
                if let data = try? jsonArr[i].rawData() {
                    self.localStorageHandler?.storeDeliveryRawJSONToLocal(id: String(i), data: data, onError: { _ in })
                }
            }
        }
    }
    
    fileprivate func makeDelivers(jsons: [JSON]) -> [Delivery] {
        var result = [Delivery]()
        
        for json in jsons {
            let delivery = Delivery(json: json)
            let imgUrl = json["goodsPicture"].stringValue
            apiClient?.fetchImageFromLink(imgUrl: imgUrl,
                                          onResponse: { [weak self] image in
                                            guard let self = self else { return }
                                            delivery.goodsPicData = image.pngData()
                                            self.presenter?.updateDeliveryImage(with: delivery.id, image: image)
            })
            result.append(delivery)
        }
        
        return result
    }
}
