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
        let router = DeliveryMasterRouter()
        
        let presenter = DeliveryMasterPresenter()
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
}
