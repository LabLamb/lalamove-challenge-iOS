//
//  DeliveryMasterPresenterTests.swift
//  UITests
//
//  Created by LabLamb on 21/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

@testable import lalamove_challenge_ios
import XCTest

class DeliveryMasterPresenterTests: XCTestCase {
    
    var viewController: MockDeilveryMasterViewController!
    var interactor: DeliveryMasterInteractor!
    var presenter: DeliveryMasterPresenter!
    var router: MockDeliveryMasterRouter!
    
    override func setUp() {
        let mockAPIClient = MockDeliveryAPIClient()
        let mockLocalHandler = MockDeliveryLocalStorageHandler()
        interactor = DeliveryMasterInteractor(apiClient: mockAPIClient,
                                                  localStorageHandler: mockLocalHandler)
        
        viewController = MockDeilveryMasterViewController()
        presenter = DeliveryMasterPresenter()
        router = MockDeliveryMasterRouter()
        
        presenter.interactor = interactor
        presenter.viewController = viewController
        presenter.router = router
        
        interactor.presenter = presenter
    }
    
    func test_setupView() {
        XCTAssertFalse(viewController.didSetupNavigationBarTitle)
        XCTAssertFalse(viewController.didSetupTableView)
        XCTAssertNil(viewController.didToggleRequestAnimation)
        XCTAssertNotEqual(viewController.didToggleRequestAnimation, false)
        
        presenter.setupView()
        
        XCTAssertTrue(viewController.didSetupNavigationBarTitle)
        XCTAssertTrue(viewController.didSetupTableView)
        XCTAssertNotNil(viewController.didToggleRequestAnimation)
        XCTAssertEqual(viewController.didToggleRequestAnimation, false)
    }
    
    func test_presentRetryFetchAlert() {
        XCTAssertFalse(router.didRouteToRetryFetchAlert)
        presenter.presentRetryFetchAlert()
        XCTAssertTrue(router.didRouteToRetryFetchAlert)
    }
    
    func test_presentDeliveryDetails() {
        interactor.fetchDeliveries { [weak self] in
            guard let self = self else { return }
            XCTAssertFalse(self.router.didRouteToDetailPage)
            self.presenter.presentDeliveryDetails(index: Int.random(in: 0..<20))
            XCTAssertTrue(self.router.didRouteToDetailPage)
        }
    }
    
    func test_reloadTableView() {
        XCTAssertFalse(viewController.didReloadTableView)
        presenter.reloadTableView()
        XCTAssertTrue(viewController.didReloadTableView)
    }
    
    func test_updateDeliveries() {
        XCTAssertNil(viewController.didToggleRequestAnimation)
        XCTAssertNotEqual(viewController.didToggleRequestAnimation, false)
        presenter.updateDeliveries()
        XCTAssertNotNil(viewController.didToggleRequestAnimation)
        XCTAssertEqual(viewController.didToggleRequestAnimation, false)
    }
    
    func test_tryAgainButtonHandler() {
        XCTAssertNil(viewController.didToggleRequestAnimation)
        XCTAssertNotEqual(viewController.didToggleRequestAnimation, false)
        
        let mockAlertBtn = UIAlertAction()
        presenter.tryAgainButtonHandler(alertBtn: mockAlertBtn)
        
        XCTAssertNotNil(viewController.didToggleRequestAnimation)
        XCTAssertEqual(viewController.didToggleRequestAnimation, false)
    }
    
    func test_numberOfRowsInSection_empty() {
        let mockTableView = UITableView()
        mockTableView.dataSource = presenter
        let rows = presenter.tableView(mockTableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rows, 0)
        XCTAssertEqual(rows, interactor.deliveries.count)
    }
    
    func test_numberOfRowsInSection_loaded() {
        test_updateDeliveries()
        let mockTableView = UITableView()
        mockTableView.dataSource = presenter
        let rows = presenter.tableView(mockTableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rows, 20)
        XCTAssertEqual(rows, interactor.deliveries.count)
        
    }
    
    func test_cellForRowAt_false() {
        let mockTableView = UITableView()
        let mockIndexPath = IndexPath(row: 0, section: 0)
        mockTableView.dataSource = presenter
        mockTableView.register(DeliveryMasterCell.self, forCellReuseIdentifier: DeliveryMasterCell.cellIdentifier)
        let cell = presenter.tableView(mockTableView, cellForRowAt: mockIndexPath)
        XCTAssertFalse(cell is DeliveryMasterCell)
    }
    
    func test_cellForRowAt_true() {
        test_updateDeliveries()
        let mockTableView = UITableView()
        let mockIndexPath = IndexPath(row: 0, section: 0)
        mockTableView.dataSource = presenter
        mockTableView.register(DeliveryMasterCell.self, forCellReuseIdentifier: DeliveryMasterCell.cellIdentifier)
        let cell = presenter.tableView(mockTableView, cellForRowAt: mockIndexPath)
        XCTAssertTrue(cell is DeliveryMasterCell)
    }
}
