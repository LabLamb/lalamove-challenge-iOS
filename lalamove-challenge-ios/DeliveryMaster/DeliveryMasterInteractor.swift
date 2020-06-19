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
    
    typealias GoodsImgFetchDetails = (id: String, url: String)
    
    fileprivate let localStorageAsyncHint = "DeliveryLocalStorageQueue"
    fileprivate let perPageLimit = 20
    
    fileprivate var deliveryStatehandler: DeliveryStateHandlerInterface?
    fileprivate var apiClient: DeliveryAPIClientInterface?
    fileprivate var localStorageHandler: DeliveryLocalStorageHandlerInterface?
    
    var presenter: DeliveryMasterPresenterInterface?
    
    init(apiClient: DeliveryAPIClientInterface = DeliveryAPIClient(),
         localStorageHandler: DeliveryLocalStorageHandlerInterface = DeliveryLocalStorageHandler(),
         deliveryStatehandler: DeliveryStateHandlerInterface = DeliveryStateHandler()) {
        self.apiClient = apiClient
        self.localStorageHandler = localStorageHandler
        self.deliveryStatehandler = deliveryStatehandler
    }
}

extension DeliveryMasterInteractor: DeliveryMasterInteractorInterface {
    
    func setupView() {
        presenter?.presentTableView()
        presenter?.presentNavigationTitle()
    }
    
    func showDeliveryDetails(index: Int) {
        presenter?.presentDeliveryDetails(index: index)
    }
    
    func fetchDeliveries() {
        presenter?.presentStartingFetchAnimation()
        let pagingInfo = presenter?.getPagingInfo(limit: perPageLimit)
        apiClient?.fetchDeliveriesFromServer(paging: pagingInfo,
                                             onResponse: deliveryResponseHandler,
                                             onError: deliveryErrorHandler)
    }
    
    func deliveryResponseHandler(jsonArr: [JSON]) {
        let output = makeDeliversAndImgDetails(with: jsonArr)
        let deliveries = output.delivers
        let imgDetails = output.imgDetails
        
        let batchId = getBatchNumber()
        localStorageHandler?.storeDeliveriesJSON(batch: batchId, deliveries: deliveries)
        fetchDeliveriesGoodImage(batch: batchId, imgDetails: imgDetails)
        updateDeliveriesIfNeeded(deliveries: deliveries)
    }
    
    func deliveryErrorHandler(error: DeliveryAPICallError) {
        guard let localStorageHandler = localStorageHandler else { return }
        let deliveries = localStorageHandler.fetchDeliveriesFromLocal(batch: getBatchNumber())
        updateDeliveriesIfNeeded(deliveries: deliveries)
        
        if deliveries.isEmpty {
            
        }
    }
    
    func updateDeliveriesIfNeeded(deliveries: [Delivery]) {
        guard let presenter = self.presenter else { return }
        
        let deliveriesIds = deliveries.compactMap({ $0.id })
        if let handler = deliveryStatehandler {
            let map = handler.readFavoritesStatus(ids: deliveriesIds)
            updateIsFavForDelivery(deliveries: deliveries, with: map)
        }
        
        presenter.updateDeliveries(incomingDeliveries: deliveries)
    }
    
    func fetchDeliveriesGoodImage(batch: Int, imgDetails: [GoodsImgFetchDetails]) {
        for imgDetail in imgDetails {
            
            let updater: (UIImage) -> () = { image in
                guard let data = image.pngData() else { return }
                self.presenter?.updateDeliveryImage(with: imgDetail.id, image: image)
                self.localStorageHandler?.updateImageData(with: imgDetail.id, batch: batch, imageData: data)
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
    
    func updateIsFavForDelivery(deliveries: [Delivery], with map: [String: Bool]) {
        for (key, value) in map {
            deliveries.first(where: { $0.id == key })?.isFavorite = value
        }
    }
    
    func getBatchNumber() -> Int {
        guard let presenter = presenter else { return 0 }
        let offset = presenter.getPagingInfo(limit: self.perPageLimit).offset
        let batchNumber = Double(offset) / Double(self.perPageLimit)
        return Int(ceil(batchNumber))
    }
}
