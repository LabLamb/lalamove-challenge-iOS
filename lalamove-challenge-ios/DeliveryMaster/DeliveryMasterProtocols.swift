//
//  DeliveryMasterProtocols.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit.UIViewController

protocol DeliveryMasterInteractorInterface {
    func fetchDeliveriesFromAPI()
    func getDeliverySummaries() -> [DeliverySummary]
    func prepareToShowDeliveryDetails(index: Int)
}

protocol DeliveryMasterRouterInterface {
    func routeToDetailPage(viewController: UIViewController)
}

protocol DeliveryMasterPresenterInterface {
    func showDeliveryDetails(deliver: Delivery)
}
