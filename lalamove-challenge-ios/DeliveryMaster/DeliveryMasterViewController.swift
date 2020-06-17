//
//  ViewController.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import SnapKit

class DeliveryMasterViewController: UIViewController {
    
    var interactor: DeliveryMasterInteractorInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.setupView()
    }
}

extension DeliveryMasterViewController: DeliveryMasterViewControllerInterface {

    func setupTableView(tableView: UIView) {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}

extension DeliveryMasterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
