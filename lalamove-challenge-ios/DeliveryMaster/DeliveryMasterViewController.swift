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
    weak var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchDeliveries()
        interactor?.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool){
        tableView?.reloadData()
    }
}

extension DeliveryMasterViewController: DeliveryMasterViewControllerInterface {
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView?.reloadData()
        }
    }
    
    func toggleRequestAnimation(animate: Bool) {
        isLoading = animate
        reloadTableView()
    }
    
    func setupNavigationBarTitle() {
        navigationItem.title = navTitle
    }
    

    func setupTableView(tableView: UITableView) {
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        self.tableView = tableView
    }
}

extension DeliveryMasterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 8
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
        return isLoading ? (view.frame.height / 8) : 0
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 0 {
            if !isLoading {
                interactor?.fetchDeliveries()
            }
        }
    }
}
