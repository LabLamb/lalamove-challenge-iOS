//
//  MockDeliveryMasterPresenter.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 21/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

@testable import lalamove_challenge_ios
class MockDeliveryMasterPresenter: DeliveryMasterInteractorOwnedPresenterInterface {
    
    private(set) var didPresentRetryFetchAlert = false
    private(set) var didReloadTableView = false
    
    func presentRetryFetchAlert() {
        didPresentRetryFetchAlert = true
    }
    
    func reloadTableView() {
        didReloadTableView = true
    }
}
