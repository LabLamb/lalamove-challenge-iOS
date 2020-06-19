//
//  DeliveryDetailConfigurator.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit.UIViewController

class DeliveryDetailConfigurator: Configurator {
    
    var deilvery: Delivery
    
    init(deilvery: Delivery) {
        self.deilvery = deilvery
    }
    
    func configViewController() -> UIViewController {
        let viewController = DeliveryDetailViewController()
        let interactor = DeliveryDetailInteractor(deliveryId: deilvery.id)
        let presenter = DeliveryDetailPresenter(delivery: deilvery)

        viewController.interactor = interactor
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        
        return viewController
    }
}
