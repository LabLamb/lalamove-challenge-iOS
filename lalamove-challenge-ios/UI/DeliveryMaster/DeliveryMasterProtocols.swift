//
//  DeliveryMasterProtocols.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit

protocol DeliveryMasterViewControllerInterface: BaseViewControllerInterface {
    func setupTableView(tableView: UITableView)
    func reloadTableView()
    func toggleRequestAnimation(animate: Bool)
}

protocol DeliveryMasterInteractorInterface {
    func fetchDeliveries(onCompletion: @escaping () -> ())
    func getNumberOfDeliveries() -> Int
    func getDelivery(at index: Int) -> Delivery?
}

protocol DeliveryMasterInteractorOwnedPresenterInterface: class {
    func presentRetryFetchAlert()
    func reloadTableView()
}

protocol DeliveryMasterViewControllerOwnedPresenterInterface: BasePresenterInterface {
    func presentDeliveryDetails(index: Int)
    func updateDeliveries()
}

protocol DeliveryMasterRouterInterface {
    func routeToDetailPage(viewController: UIViewController)
    func routeToRetryFetchAlert(viewController: UIViewController)
}
