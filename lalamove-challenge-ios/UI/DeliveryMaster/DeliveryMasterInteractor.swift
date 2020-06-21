//
//  DeliveryMasterInteractor.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import Alamofire
import UIKit.UITableView
import SwiftyJSON

class DeliveryMasterInteractor {
    
    var deliveries: [Delivery] = []
    
    typealias GoodsImgFetchDetails = (id: String, url: String)
    
    fileprivate let retryImageFetchAsyncHint = "DeliveryImageFetchQueue"
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
    
    func deliverySuccessHandler(jsonArr: [JSON]) {
        let output = makeDeliversAndImgDetails(with: jsonArr)
        let deliveries = output.delivers
        let imgDetails = output.imgDetails
        
        let batchId = getBatchNumber()
        localStorageHandler?.storeDeliveriesJSON(batch: batchId, deliveries: deliveries)
        fetchDeliveriesGoodImage(batch: batchId, imgDetails: imgDetails)
        updateDeliveriesIfNeeded(deliveries: deliveries)
    }
    
    func deliveryErrorHandler() {
        guard let localStorageHandler = localStorageHandler else { return }
        let deliveries = localStorageHandler.fetchDeliveriesFromLocal(batch: getBatchNumber())
        
        if deliveries.isEmpty {
            presenter?.presentRetryFetchAlert()
        } else {
            updateDeliveriesIfNeeded(deliveries: deliveries)
        }
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
            fetchDeliveryGoodImage(batch: batch, imgDetail: imgDetail)
        }
    }
    
    func fetchDeliveryGoodImage(batch: Int, imgDetail: GoodsImgFetchDetails) {
        let completionHandler: ResponseImageCallback = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                guard let data = image.pngData() else { return }
                self.updateDeliveryImage(batch: batch, deliveryId: imgDetail.id, imageData: data)
                
            case .failure(let error):
                print(error.localizedDescription)
                // TODO: Add retry logic here
            }
        }
        
        apiClient?.fetchImageFromLink(imgUrl: imgDetail.url, completion: completionHandler)
    }
    
    func updateDeliveryImage(batch: Int, deliveryId: String, imageData data: Data) {
        self.deliveries.first(where: { $0.id == deliveryId })?.goodsPicData = data.base64EncodedString()
        self.localStorageHandler?.updateImageData(with: deliveryId, batch: batch, imageData: data)
        self.presenter?.reloadTableView()
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
    func fetchDeliveries(onCompletion: @escaping () -> Void) {
        let completionHandler: ResponseJSONCallback = { result in
            switch result {
            case .success(let json):
                let jsonArr = JSON(json).arrayValue
                self.deliverySuccessHandler(jsonArr: jsonArr)
            case .failure(let error):
                print(error.localizedDescription)
                self.deliveryErrorHandler()
            }
            onCompletion()
        }
        
        apiClient?.fetchDeliveriesFromServer(paging: (deliveries.count, perPageLimit),
                                             completion: completionHandler)
    }
    
    func getDelivery(at index: Int) -> Delivery {
        return deliveries[index]
    }
    
    func getNumberOfDeliveries() -> Int {
        return deliveries.count
    }
}
