//
//  DeliveryPresenter.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit

class DeliveryMasterPresenter: NSObject {
    
    private let genericErrorMessage = "Fail to fetch data from server" // Normally this should be a key for localized string
    
    var deliveries: [Delivery] = []
    
    var tableView: (Refreashable & TableViewRefreashable)?
    weak var viewController: (DeliveryMasterViewControllerInterface & UITableViewDelegate)?
    var router: DeliveryMasterRouterInterface?
}

extension DeliveryMasterPresenter: DeliveryMasterPresenterInterface {
    func updateDeliveryImage(with id: String, image: UIImage) {
        guard let index = deliveries.firstIndex(where: { $0.id == id }) else { return }
        tableView?.refresh(with: image, at: index)
    }
    
    func refreshTableView() {
        tableView?.refresh()
    }
    
    func presentAPIError() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController.makeGenericAPIError(message: self.genericErrorMessage)
            self.viewController?.showAPIError(alertViewController: alert)
            self.viewController?.isRequestingMoreData = false
            self.tableView?.refresh()
        }
    }
    
    func getPagingInfo(limit: Int) -> DeliveryPagingInfo {
        return (deliveries.count, limit)
    }
    
    func presentNavigationTitle() {
        viewController?.setupNavigationBarTitle()
    }
    
    func presentTableView() {
        let tempTableView = UITableView()
        tempTableView.dataSource = self
        tempTableView.delegate = viewController
        tempTableView.register(DeliveryMasterCell.self, forCellReuseIdentifier: DeliveryMasterCell.cellIdentifier)
        tableView = tempTableView
        viewController?.setupTableView(tableView: tempTableView)
    }
    
    func updateDeliveries(incomingDeliveries: [Delivery]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            var isOverlap = false
            
            for d in incomingDeliveries {
                if self.deliveries.contains(where: { $0.id == d.id }) {
                    isOverlap = true
                }
            }
            
            if isOverlap && self.deliveries.count <= 20 {
                self.deliveries = incomingDeliveries
            } else {
                self.deliveries.append(contentsOf: incomingDeliveries)
            }

            self.tableView?.refresh()
            self.viewController?.isRequestingMoreData = false
        }
        
    }
    
    func presentDeliveryDetails(index: Int) {
        if index < deliveries.count {
            let delivery = deliveries[index]
            let configurator = DeliveryDetailConfigurator(deilvery: delivery)
            let deliveryDetVC = configurator.configViewController()
            router?.routeToDetailPage(viewController: deliveryDetVC)
            
        }
    }
}

extension DeliveryMasterPresenter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryMasterCell.cellIdentifier, for: indexPath) as? DeliveryMasterCell else {
            return UITableViewCell()
        }
        
        let delivery = deliveries[indexPath.row]
        cell.configData(summary: delivery)
        
        return cell
    }
    
}
