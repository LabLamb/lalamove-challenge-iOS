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
    func showDeliveryDetails(index: Int)
}

protocol DeliveryMasterRouterInterface {
    func routeToDetailPage(viewController: UIViewController)
}

protocol DeliveryMasterPresenterInterface {
    func updateDeliveries(deliveries: [Delivery])
    func presentDeliveryDetails(index: Int)
    func presentTableView()
    func presentNavigationTitle()
    func getPagingInfo(limit: Int) -> DeliveryPagingInfo?
}

protocol DeliveryMasterViewControllerInterface {
    func setupTableView(tableView: UIView)
    func setupNavigationBarTitle()
}
