//
//  DeliveryMasterProtocols.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit

protocol DeliveryMasterInteractorInterface {
    func fetchDeliveries()
    func setupView()
}

protocol DeliveryMasterRouterInterface {
    func routeToDetailPage(viewController: UIViewController)
}

protocol DeliveryMasterPresenterInterface {
    func updateDeliveries(deliveries: [Delivery])
    func showDeliveryDetails(delivery: Delivery)
    func presentTableView()
}

protocol DeliveryMasterViewControllerInterface {
    func setupTableView(tableView: UIView)
}
