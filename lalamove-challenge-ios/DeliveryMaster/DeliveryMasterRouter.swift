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
        if let nav = viewController.navigationController {
            nav.pushViewController(viewController, animated: true)
        } else {
            viewController.present(viewController, animated: true)
        }
    }
}
