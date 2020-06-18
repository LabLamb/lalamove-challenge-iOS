//
//  DeliveryMasterProtocols.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit

protocol DeliveryMasterViewControllerInterface: BaseViewController {
    var isRequestingMoreData: Bool { get set }
    func setupTableView(tableView: UIView)
    func showAPIError(alertViewController: UIViewController)
}

protocol DeliveryMasterInteractorInterface: BaseInteractor {
    func initialFetch()
    func fetchDeliveries()
    func showDeliveryDetails(index: Int)
}

protocol DeliveryMasterPresenterInterface: BasePresenter {
    func presentDeliveryDetails(index: Int)
    func presentTableView()
    func presentAPIError()
    
    func updateDeliveries(incomingDeliveries: [Delivery])
    func updateDeliveryImage(with id: String, image: UIImage)
    
    func getPagingInfo(limit: Int) -> DeliveryPagingInfo
    func refreshTableView()
}

protocol DeliveryMasterRouterInterface {
    func routeToDetailPage(viewController: UIViewController)
}
