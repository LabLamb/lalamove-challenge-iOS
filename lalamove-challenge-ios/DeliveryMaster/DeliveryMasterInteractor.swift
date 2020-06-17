//
//  DeliveryMasterInteractor.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit.UITableView

class DeliveryMasterInteractor {

    var apiClient: DeliveryAPIClientInterface?
    var presenter: DeliveryMasterPresenterInterface?
    
    init() {
        apiClient = DeliveryAPIClient()
        fetchDeliveriesFromAPI()
    }
}

extension DeliveryMasterInteractor: DeliveryMasterInteractorInterface {
    
    func setupView() {
        presenter?.presentTableView()
    }
    
    func fetchDeliveries() {
        fetchDeliveriesFromAPI()
    }

    func fetchDeliveriesFromAPI() {
        apiClient?.fetchDeliveriesFromServer(onResponse: { [weak self] jsonArr in
            guard let self = self,
                let presenter = self.presenter else { return }
            let deliveries = jsonArr.compactMap({ json in
                return Delivery(json: json)
            })
            presenter.updateDeliveries(deliveries: deliveries)
        })
    }
}
