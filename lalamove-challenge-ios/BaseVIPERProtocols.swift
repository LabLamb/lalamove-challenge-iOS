//
//  BaseVIPERProtocols.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import Foundation
import UIKit.UIViewController

protocol Configurator {
    func configViewController() -> UIViewController
}

protocol BaseViewController: class {
    func setupNavigationBarTitle()
}

protocol BaseInteractor {
    func setupView()
}

protocol BasePresenter {
    func presentNavigationTitle()
}
