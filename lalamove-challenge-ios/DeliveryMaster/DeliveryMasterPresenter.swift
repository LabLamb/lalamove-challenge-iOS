//
//  DeliveryPresenter.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit

class DeliveryMasterPresenter: NSObject {
    var tableView: DeliveryMasterTableView?
    var viewController: (DeliveryMasterViewControllerInterface & UITableViewDelegate)?
    var router: DeliveryMasterRouterInterface?
    var deliveries: [Delivery] = []
}

extension DeliveryMasterPresenter: DeliveryMasterPresenterInterface {
    func presentTableView() {
        let tempTableView = UITableView()
        tempTableView.dataSource = self
        tempTableView.delegate = viewController
        tempTableView.register(DeliveryMasterCell.self, forCellReuseIdentifier: DeliveryMasterCell.cellIdentifier)
        tableView = tempTableView
        viewController?.setupTableView(tableView: tempTableView)
    }
    
    func updateDeliveries(deliveries: [Delivery]) {
        self.deliveries = deliveries
        tableView?.reloadDeliveries()
    }
    
    func showDeliveryDetails(delivery: Delivery) {
//        let deliveryDetVC = UIViewController()
//        router?.routeToDetailPage(viewController: deliveryDetVC)
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
