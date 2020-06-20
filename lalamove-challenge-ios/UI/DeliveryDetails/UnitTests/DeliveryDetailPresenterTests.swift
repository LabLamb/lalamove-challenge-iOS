//
//  DeliveryDetailPresenterTests.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 20/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

@testable import lalamove_challenge_ios
import SwiftyJSON
import XCTest

class DeliveryDetailPresenterTests: XCTestCase {
    
    var delivery: Delivery!
    var deliverStateHandler: DeliveryStateHandlerInterface!
    var interactor: DeliveryDetailInteractor!
    
    var viewController: MockDeliveryDetailViewController!
    var presenter: DeliveryDetailPresenter!
    
    override func setUp() {
        super.setUp()
        self.delivery = Delivery(sortingNumber: 0, json: loadDeliveryJSON())
        self.deliverStateHandler = DeliveryStateHandler()
        self.interactor = DeliveryDetailInteractor(delivery: delivery,
                                                   deliveryStatehandler: deliverStateHandler)
        self.viewController = MockDeliveryDetailViewController()
        self.presenter = DeliveryDetailPresenter()
        presenter.viewController = viewController
        presenter.interactor = interactor
    }
    
    fileprivate func loadDeliveryJSON() -> JSON {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: "MockDeliveryJSON", withExtension: "json")
        let data = try! Data(contentsOf: fileUrl!)
        let json = try! JSON(data: data)
        return json
    }
    
    func test_presentFavoriteButton_addFavoriteBtnText() {
        delivery.isFavorite = false
        presenter.presentFavoriteButton()
        XCTAssertEqual(presenter.addFavoriteBtnText, viewController.favButtonTitle)
    }
    
    func test_presentFavoriteButton_removeFavoriteBtnText() {
        delivery.isFavorite = true
        presenter.presentFavoriteButton()
        XCTAssertEqual(presenter.removeFavoriteBtnText, viewController.favButtonTitle)
    }
    
    func test_presentInfoView() {
        XCTAssertFalse(viewController.infoViewHasSetup)
        presenter.presentInfoView()
        XCTAssertTrue(viewController.infoViewHasSetup)
    }
    
    func test_favBtnTapped() {
        delivery.isFavorite = true
        presenter.favBtnTapped()
        XCTAssertEqual(presenter.addFavoriteBtnText, viewController.favButtonTitle)
    }
    
    func test_updateInfoView() {
        XCTAssertFalse(viewController.infoViewUpdated)
        presenter.updateInfoView()
        XCTAssertTrue(viewController.infoViewUpdated)
    }
    
    func test_setupView() {
        delivery.isFavorite = false
        XCTAssertFalse(viewController.infoViewHasSetup)
        presenter.setupView()
        XCTAssertTrue(viewController.infoViewHasSetup)
        XCTAssertEqual(presenter.addFavoriteBtnText, viewController.favButtonTitle)
        XCTAssertTrue(viewController.navBarTitleHasSetup)
    }
    
    func test_removeCADisplayLink() {
        XCTAssertNotNil(presenter.displayLink)
        presenter.removeCADisplayLink()
        XCTAssertNil(presenter.displayLink)
    }
    
}
