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

protocol DeliveryMasterInteractorInterface: BaseInteractorInterface {
    func fetchDeliveries()
    func showDeliveryDetails(index: Int)
}

protocol DeliveryMasterPresenterInterface: BasePresenterInterface {
    func presentDeliveryDetails(index: Int)
    func presentTableView()
    func presentStartingFetchAnimation()
    func presentStopFetchAnimation()
    
    func updateDeliveries(incomingDeliveries: [Delivery])
    func updateDeliveryImage(with id: String, image: UIImage)
    
    func getPagingInfo(limit: Int) -> DeliveryPagingInfo
}

protocol DeliveryMasterRouterInterface {
    func routeToDetailPage(viewController: UIViewController)
}
