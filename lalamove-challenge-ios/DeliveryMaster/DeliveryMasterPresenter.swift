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
    
    var tableView: Refreashable?
    weak var viewController: (DeliveryMasterViewControllerInterface & UITableViewDelegate)?
    var router: DeliveryMasterRouterInterface?
}

extension DeliveryMasterPresenter: DeliveryMasterPresenterInterface {
    func updateDeliveryImage(with id: String, image: UIImage) {
        guard let index = deliveries.firstIndex(where: { $0.id == id }) else { return }
        deliveries[index].goodsPicData = image.pngData()?.base64EncodedString()
        tableView?.refresh()
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
        deliveries.append(contentsOf: incomingDeliveries)
        presentCompleteFetchAnimation()
    }
    
    func presentDeliveryDetails(index: Int) {
        if index < deliveries.count {
            let delivery = deliveries[index]
            let configurator = DeliveryDetailConfigurator(deilvery: delivery)
            let deliveryDetVC = configurator.configViewController()
            router?.routeToDetailPage(viewController: deliveryDetVC)
        }
    }
    
    func presentCompleteFetchAnimation() {
        viewController?.stopRequestAnimation()
        tableView?.refresh()
    }
    
    func presentStartingFetchAnimation() {
        viewController?.startRequestAnimation()
        tableView?.refresh()
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
