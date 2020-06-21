//
//  MockDeliveryMasterRouter.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 21/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

@testable import lalamove_challenge_ios
import UIKit.UIViewController

class MockDeliveryMasterRouter: DeliveryMasterRouterInterface {
    
    private(set) var didRouteToDetailPage = false
    private(set) var didRouteToRetryFetchAlert = false
    
    func routeToDetailPage(viewController: UIViewController) {
        didRouteToDetailPage = true
    }
    
    func routeToRetryFetchAlert(viewController: UIViewController) {
        didRouteToRetryFetchAlert = true
    }
    
    
}
