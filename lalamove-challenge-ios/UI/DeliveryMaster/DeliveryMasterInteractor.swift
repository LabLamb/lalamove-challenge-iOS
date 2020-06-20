//
//  DeliveryMasterInteractor.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit.UITableView
import SwiftyJSON

class DeliveryMasterInteractor {
    
    var deliveries: [Delivery] = []
    
    typealias GoodsImgFetchDetails = (id: String, url: String)
    
    fileprivate let localStorageAsyncHint = "DeliveryLocalStorageQueue"
    fileprivate let perPageLimit = 20
    
    fileprivate var deliveryStatehandler: DeliveryStateHandlerInterface?
    fileprivate var apiClient: DeliveryAPIClientInterface?
    fileprivate var localStorageHandler: DeliveryLocalStorageHandlerInterface?
    
    weak var presenter: DeliveryMasterPresenterInterface?
    
    init(apiClient: DeliveryAPIClientInterface = DeliveryAPIClient(),
         localStorageHandler: DeliveryLocalStorageHandlerInterface = DeliveryLocalStorageHandler(),
         deliveryStatehandler: DeliveryStateHandlerInterface = DeliveryStateHandler()) {
        self.apiClient = apiClient
        self.localStorageHandler = localStorageHandler
        self.deliveryStatehandler = deliveryStatehandler
    }
    
    // MARK: - Helper functions
    
    func deliveryResponseHandler(jsonArr: [JSON], onCompletion: () -> ()) {
        let output = makeDeliversAndImgDetails(with: jsonArr)
        let deliveries = output.delivers
        let imgDetails = output.imgDetails
        
        let batchId = getBatchNumber()
        localStorageHandler?.storeDeliveriesJSON(batch: batchId, deliveries: deliveries)
        fetchDeliveriesGoodImage(batch: batchId, imgDetails: imgDetails)
        updateDeliveriesIfNeeded(deliveries: deliveries)
        onCompletion()
    }
    
    func deliveryErrorHandler(error: DeliveryAPICallError, onCompletion: () -> ()) {
        guard let localStorageHandler = localStorageHandler else { return }
        let deliveries = localStorageHandler.fetchDeliveriesFromLocal(batch: getBatchNumber())
        
        if deliveries.isEmpty {
            presenter?.presentRetryFetchAlert()
        } else {
            updateDeliveriesIfNeeded(deliveries: deliveries)
        }
        
        onCompletion()
    }
    
    func updateDeliveriesIfNeeded(deliveries: [Delivery]) {
        let deliveriesIds = deliveries.compactMap({ $0.id })
        if let handler = deliveryStatehandler {
            let map = handler.readFavoritesStatus(ids: deliveriesIds)
            for (key, value) in map {
                deliveries.first(where: { $0.id == key })?.isFavorite = value
            }
        }
        self.deliveries.append(contentsOf: deliveries)
    }
    
    func fetchDeliveriesGoodImage(batch: Int, imgDetails: [GoodsImgFetchDetails]) {
        for imgDetail in imgDetails {
            let updater: (UIImage) -> () = { [weak self] image in
                guard let self = self,
                    let data = image.pngData() else { return }
                self.deliveries.first(where: { $0.id == imgDetail.id })?.goodsPicData = data.base64EncodedString()
                self.localStorageHandler?.updateImageData(with: imgDetail.id, batch: batch, imageData: data)
                self.presenter?.reloadTableView()
            }
            
            apiClient?.fetchImageFromLink(imgUrl: imgDetail.url, onResponse: updater)
        }
    }
    
    func makeDeliversAndImgDetails(with jsons: [JSON]) -> (delivers: [Delivery], imgDetails: [GoodsImgFetchDetails]) {
        var deliveries = [Delivery]()
        var imageDetails = [(GoodsImgFetchDetails)]()
        
        for i in 0..<jsons.count {
            let delivery = Delivery(sortingNumber: i, json: jsons[i])
            deliveries.append(delivery)
            
            let id = jsons[i]["id"].stringValue
            let imgUrl = jsons[i]["goodsPicture"].stringValue
            imageDetails.append((id: id, url: imgUrl))
        }
        
        return (delivers: deliveries, imgDetails: imageDetails)
    }
    
    func getBatchNumber() -> Int {
        let offset = deliveries.count
        let batchNumber = Double(offset) / Double(perPageLimit)
        return Int(ceil(batchNumber))
    }
    
}

extension DeliveryMasterInteractor: DeliveryMasterInteractorInterface {
    func fetchDeliveries(onCompletion: @escaping () -> ()) {
        apiClient?.fetchDeliveriesFromServer(paging: (deliveries.count, perPageLimit),
                                             onCompletion: onCompletion,
                                             onResponse: deliveryResponseHandler,
                                             onError: deliveryErrorHandler)
    }
    
    func getDelivery(at index: Int) -> Delivery {
        return deliveries[index]
    }

    func getNumberOfDeliveries() -> Int {
        return deliveries.count
    }
}
