//
//  DeliveryMasterInteractor.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import Foundation

class DeliveryMasterInteractor {

    var deliveries = [Delivery]()
//    var apiClient = DeliveryApiClient()
    var presenter: DeliveryMasterPresenterInterface?
}

extension DeliveryMasterInteractor: DeliveryMasterInteractorInterface {

    func fetchDeliveriesFromAPI() {
        // Ask API object to fetch
    }
    
    func getDeliverySummaries() -> [DeliverySummary] {
        // Return the object array in Summary form
        return []
    }
    
    func prepareToShowDeliveryDetails(index: Int) {
        guard let presenter = presenter else { return }
        presenter.showDeliveryDetails(deliver: deliveries[index])
    }
}
