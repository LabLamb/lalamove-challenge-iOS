//
//  BaseVIPERProtocols.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

protocol BaseViewController {
    func setupNavigationBarTitle()
}

protocol BaseInteractor {
    func setupView()
}

protocol BasePresenter {
    func presentNavigationTitle()
}
