//
//  UITableView+ReloadDelivery.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit.UITableView

protocol Refreashable {
    func refresh()
}

protocol TableViewRefreashable {
    func refresh(with image: UIImage, at index: Int)
}

extension UITableView: Refreashable, TableViewRefreashable {
    func refresh() {
        self.reloadData()
    }
    
    func refresh(with image: UIImage, at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = self.cellForRow(at: indexPath) as? DeliveryMasterCellImageUpdatable else { return }
        cell.updateImage(image: image)
    }
}
