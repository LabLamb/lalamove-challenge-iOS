//
//  DeliveryMasterRoute.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit.UIViewController

class DeliveryMasterRouter {
    weak var viewController: UIViewController?
}

extension DeliveryMasterRouter: DeliveryMasterRouterInterface {
    func routeToDetailPage(viewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let nav = self.viewController?.navigationController {
                nav.pushViewController(viewController, animated: true)
            } else {
                self.viewController?.present(viewController, animated: true)
            }
        }
    }
    
    func routeToRetryFetchAlert(viewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewController?.present(viewController, animated: true)
        }
    }
}
