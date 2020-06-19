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
    
    fileprivate var apiClient: DeliveryAPIClientInterface?
    fileprivate var localStorageHandler: DeliveryLocalStorageHandlerInterface?
    
    var presenter: DeliveryMasterPresenterInterface?
    
    init(apiClient: DeliveryAPIClientInterface = DeliveryAPIClient(),
         localStorageHandler: DeliveryLocalStorageHandlerInterface = DeliveryLocalStorageHandler()) {
        self.apiClient = apiClient
        self.localStorageHandler = localStorageHandler
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
        guard let presenter = self.presenter else { return }
        
        let output = makeDeliversAndImgDetails(with: jsonArr)
        let deliveries = output.delivers
        let imgDetails = output.imgDetails
        
        let batchId = getBatchNumber()
        localStorageHandler?.storeDeliveriesJSON(batch: batchId, deliveries: deliveries)
        updateDeliveryGoodPictures(batch: batchId, imgDetails: imgDetails)
        
        presenter.updateDeliveries(incomingDeliveries: deliveries)
    }
    
    func deliveryErrorHandler(error: DeliveryAPICallError) {
        guard let presenter = self.presenter else { return }
        guard let localStorageHandler = localStorageHandler else { return }
        let deliveries = localStorageHandler.fetchDeliveriesFromLocal(batch: getBatchNumber())
        presenter.updateDeliveries(incomingDeliveries: deliveries)
        presenter.presentCompleteFetchAnimation()
    }
    
    func updateDeliveryGoodPictures(batch: Int, imgDetails: [GoodsImgFetchDetails]) {
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
    
    func getBatchNumber() -> Int {
        guard let presenter = presenter else { return 0 }
        let offset = presenter.getPagingInfo(limit: self.perPageLimit).offset
        let batchNumber = Double(offset) / Double(self.perPageLimit)
        return Int(ceil(batchNumber))
    }
}
