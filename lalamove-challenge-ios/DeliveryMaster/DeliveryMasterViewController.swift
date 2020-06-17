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
    fileprivate var isLoading = true
    var interactor: DeliveryMasterInteractorInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.initialFetch()
        interactor?.setupView()
    }
}

extension DeliveryMasterViewController: DeliveryMasterViewControllerInterface {
    
    var isRequestingMoreData: Bool {
        get {
            return isLoading
        }
        set {
            isLoading = newValue
        }
    }
    
    func setupNavigationBarTitle() {
        navigationItem.title = navTitle
    }
    

    func setupTableView(tableView: UIView) {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    func setupAPIError(alertViewController: UIViewController) {
        present(alertViewController, animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.startLoadingIfNeeded()
        })
    }
    
    fileprivate func startLoadingIfNeeded() {
        if !isLoading {
            isLoading = true
            self.interactor?.fetchDeliveries()
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let loadingView = UIActivityIndicatorView(style: .large)
        loadingView.startAnimating()
        return isLoading ? loadingView : nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return isLoading ? 100 : 0
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 0 {
            startLoadingIfNeeded()
        }
    }
}
