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
    
    init() {
        apiClient = DeliveryAPIClient()
    }
}

extension DeliveryMasterInteractor: DeliveryMasterInteractorInterface {
    
    func initialFetch() {
        let deliveriesInLocal = fetchDeliveriesFromLocal()
        presenter?.updateDeliveries(incomingDeliveries: deliveriesInLocal)
        fetchDeliveries()
    }
    
    func showDeliveryDetails(index: Int) {
        presenter?.presentDeliveryDetails(index: index)
    }
    
    func setupView() {
        presenter?.presentTableView()
        presenter?.presentNavigationTitle()
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
    
    fileprivate func fetchDeliveriesFromLocal() -> [Delivery] {
        return LocalStorageHandler().fetchDeliveriesFromLocal()
    }
    
    fileprivate func deliveryResponseHandler(jsonArr: [JSON]) {
        guard let presenter = self.presenter else { return }
        
        if presenter.getPagingInfo(limit: perPageLimit).offset == 0 {
            cacheDataToLocal(jsonArr: jsonArr)
        }
        
        let deliveries = jsonArr.compactMap({ json in
            return Delivery(json: json)
        })
        
        presenter.updateDeliveries(incomingDeliveries: deliveries)
    }
    
    fileprivate func deliveryErrorHandler(error: DeliveryAPICallError) {
        guard let presenter = self.presenter else { return }
        presenter.presentAPIError()
    }
    
    fileprivate func cacheDataToLocal(jsonArr: [JSON]) {
        DispatchQueue.init(label: localStorageAsyncHint).async {
            for i in 0..<jsonArr.count {
                if let data = try? jsonArr[i].rawData() {
                    LocalStorageHandler().storeDeliveryRawJSONToLocal(id: String(i), data: data, onError: { _ in
                        print("fuck")
                    })
                }
            }
        }
    }
}
