//
//  DeliveryMasterProtocols.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit

protocol DeliveryMasterInteractorInterface {
    func initialFetch()
    func fetchDeliveries()
    func setupView()
    func showDeliveryDetails(index: Int)
}

protocol DeliveryMasterRouterInterface {
    func routeToDetailPage(viewController: UIViewController)
}

protocol DeliveryMasterPresenterInterface {
    func updateDeliveries(incomingDeliveries: [Delivery])
    func presentDeliveryDetails(index: Int)
    func presentTableView()
    func presentNavigationTitle()
    func getPagingInfo(limit: Int) -> DeliveryPagingInfo
    func presentAPIError()
}

protocol DeliveryMasterViewControllerInterface {
    var isRequestingMoreData: Bool { get set }
    func setupTableView(tableView: UIView)
    func setupNavigationBarTitle()
    func setupAPIError(alertViewController: UIViewController)
}
