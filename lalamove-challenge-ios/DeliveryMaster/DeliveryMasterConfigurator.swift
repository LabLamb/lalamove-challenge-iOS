//
//  DeliveryMasterConfigurator.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit.UIViewController

class DeliveryMasterConfigurator: Configurator {
    
    func configViewController() -> UIViewController {
        let viewController = DeliveryMasterViewController()
        let interactor = DeliveryMasterInteractor()
        let presenter = DeliveryMasterPresenter()
        let router = DeliveryMasterRouter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.router = router
        router.viewController = viewController
        
        return viewController
    }
}