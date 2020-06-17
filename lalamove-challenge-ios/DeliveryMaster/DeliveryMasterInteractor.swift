//
//  DeliveryMasterInteractor.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit.UITableView

class DeliveryMasterInteractor {

    let perPageLimit = 20
    var apiClient: DeliveryAPIClientInterface?
    var presenter: DeliveryMasterPresenterInterface?
    
    init() {
        apiClient = DeliveryAPIClient()
        fetchDeliveriesFromAPI()
    }
}

extension DeliveryMasterInteractor: DeliveryMasterInteractorInterface {
    func showDeliveryDetails(index: Int) {
        presenter?.presentDeliveryDetails(index: index)
    }
    
    func setupView() {
        presenter?.presentTableView()
        presenter?.presentNavigationTitle()
    }
    
    func fetchDeliveries() {
        fetchDeliveriesFromAPI()
    }

    func fetchDeliveriesFromAPI() {
        let pagingInfo = presenter?.getPagingInfo(limit: perPageLimit)
        apiClient?.fetchDeliveriesFromServer(paging: pagingInfo, onResponse: { [weak self] jsonArr in
            guard let self = self,
                let presenter = self.presenter else { return }
            let deliveries = jsonArr.compactMap({ json in
                return Delivery(json: json)
            })
            presenter.updateDeliveries(deliveries: deliveries)
            }, onError: { [weak self] errorMsg in
                print(errorMsg)
        })
    }
}
