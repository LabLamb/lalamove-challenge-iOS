//
//  DeliverySummary.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit.UIImage

protocol DeliverySummary {
    var price: Double { get }
    var from: String { get }
    var to: String { get }
    var isFav: Bool { get }
    var goodsPic: UIImage { get }
}
