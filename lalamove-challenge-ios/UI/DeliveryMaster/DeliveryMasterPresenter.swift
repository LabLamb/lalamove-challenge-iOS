//
//  DeliveryPresenter.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit

class DeliveryMasterPresenter: NSObject {
    
    var interactor: DeliveryMasterInteractorInterface?
    weak var viewController: DeliveryMasterViewControllerInterface?
    var router: DeliveryMasterRouterInterface?
    
    // MARK: - Helper functions
    
    func presentNavigationTitle() {
        viewController?.setupNavigationBarTitle()
    }
    
    func presentTableView() {
        let tempTableView = UITableView()
        tempTableView.dataSource = self
        tempTableView.register(DeliveryMasterCell.self, forCellReuseIdentifier: DeliveryMasterCell.cellIdentifier)
        viewController?.setupTableView(tableView: tempTableView)
    }
    
}

extension DeliveryMasterPresenter: DeliveryMasterViewControllerOwnedPresenterInterface {
    func setupView() {
        presentTableView()
        presentNavigationTitle()
        updateDeliveries()
    }
    
    func presentDeliveryDetails(index: Int) {
        guard let interactor = self.interactor,
            let delivery = interactor.getDelivery(at: index) else { return }
        
        let configurator = DeliveryDetailConfigurator(deilvery: delivery)
        let deliveryDetVC = configurator.configViewController()
        router?.routeToDetailPage(viewController: deliveryDetVC)
    }
    
    func updateDeliveries() {
        interactor?.fetchDeliveries(onCompletion: { [weak self] in
            guard let self = self else { return }
            self.viewController?.toggleRequestAnimation(animate: false)
        })
    }
    
    func tryAgainButtonHandler(alertBtn: UIAlertAction) {
        self.viewController?.toggleRequestAnimation(animate: true)
        self.updateDeliveries()
    }
}

extension DeliveryMasterPresenter: DeliveryMasterInteractorOwnedPresenterInterface {
    func presentRetryFetchAlert() {
        let alert = UIAlertController(title: "Error", message: "Fail to fetch data", preferredStyle: .alert)
        let tryAgainBtn = UIAlertAction(title: "Try again", style: .default, handler: tryAgainButtonHandler)
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(tryAgainBtn)
        alert.addAction(cancelBtn)
        router?.routeToRetryFetchAlert(viewController: alert)
    }
    func reloadTableView() {
        viewController?.reloadTableView()
    }
}

extension DeliveryMasterPresenter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let interactor = self.interactor else { return 0 }
        return interactor.getNumberOfDeliveries()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryMasterCell.cellIdentifier, for: indexPath) as? DeliveryMasterCell,
            let interactor = self.interactor,
            let delivery = interactor.getDelivery(at: indexPath.row)
            else {
                return UITableViewCell()
        }
        
        cell.configData(summary: delivery)
        
        return cell
    }
    
}
