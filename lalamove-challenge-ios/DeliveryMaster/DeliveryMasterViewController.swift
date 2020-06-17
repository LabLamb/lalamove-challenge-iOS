//
//  ViewController.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import SnapKit

class DeliveryMasterViewController: UIViewController {
    
    fileprivate let navTitle = "My Deliveries"
    var interactor: DeliveryMasterInteractorInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.setupView()
    }
}

extension DeliveryMasterViewController: DeliveryMasterViewControllerInterface {
    func setupNavigationBarTitle() {
        self.navigationItem.title = navTitle
    }
    

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.showDeliveryDetails(index: indexPath.row)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            self.interactor?.fetchDeliveries()
        }
    }
}
