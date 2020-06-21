//
//  MockDeilveryMasterViewController.swift
//  UITests
//
//  Created by LabLamb on 21/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

@testable import lalamove_challenge_ios
import UIKit.UITableView

class MockDeilveryMasterViewController: DeliveryMasterViewControllerInterface {
    
    private(set) var didSetupTableView = false
    private(set) var didReloadTableView = false
    private(set) var didToggleRequestAnimation: Bool? = nil
    private(set) var didSetupNavigationBarTitle = false
    
    func setupTableView(tableView: UITableView) {
        didSetupTableView = true
    }
    
    func reloadTableView() {
        didReloadTableView = true
    }
    
    func toggleRequestAnimation(animate: Bool) {
        didToggleRequestAnimation = animate
    }
    
    func setupNavigationBarTitle() {
        didSetupNavigationBarTitle = true
    }
}
