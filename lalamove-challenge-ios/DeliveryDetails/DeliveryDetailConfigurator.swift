//
//  DeliveryDetailConfigurator.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit.UIViewController

class DeliveryDetailConfigurator: Configurator {
    
    weak var deilvery: Delivery?
    
    init(deilvery: Delivery) {
        self.deilvery = deilvery
    }
    
    func configViewController() -> UIViewController {
        let viewController = DeliveryDetailViewController()
//        let interactor = DeliveryDetailInteractor()
//        let presenter = DeliveryDetailPresenter()
//
//        viewController.interactor = interactor
//        interactor.presenter = presenter
//
//        presenter.router = router
//        presenter.viewController = viewController
        
        return viewController
    }
}
