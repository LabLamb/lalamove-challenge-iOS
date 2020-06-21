//
//  LocalStorageHandler.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import SwiftyJSON

protocol DeliveryLocalStorageHandlerInterface {
    func updateImageData(with id: String, batch: Int, imageData: Data)
    func storeDeliveriesJSON(batch: Int, deliveries: [Delivery])
    func fetchDeliveriesFromLocal(batch: Int) -> [Delivery]
}

class DeliveryLocalStorageHandler {
    private let storeDeliveriesAsyncQueueHint = "DeliveryLocalStoringQueue"
    private let updatImageAsyncQueueHint = "ImageUpdateLocalStoringQueue"
    private let jsonStorageFolder = "lalamove-challange-folder"
    private let jsonExtension = "json"
    
    private let docDirURL: URL? = try? FileManager.default.url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    private var folderURL: URL? {
        return docDirURL?.appendingPathComponent(jsonStorageFolder)
    }
    
    fileprivate func getFileURL(folderURL: URL, batch: String, id: String, ext: String) -> URL {
        return folderURL.appendingPathComponent(batch).appendingPathComponent(id).appendingPathExtension(ext)
    }
}

extension DeliveryLocalStorageHandler: DeliveryLocalStorageHandlerInterface {
    
    func storeDeliveriesJSON(batch: Int, deliveries: [Delivery]) {
        DispatchQueue(label: storeDeliveriesAsyncQueueHint).async { [weak self] in
            guard let self = self,
                let folderURL = self.folderURL else { return }
            folderURL.createFolderIfNeeded()
            let batchFolderURL = folderURL.appendingPathComponent(String(batch))
            batchFolderURL.createFolderIfNeeded()
            
            for delivery in deliveries {
                let fileURL = self.getFileURL(folderURL: folderURL, batch: String(batch), id: delivery.id, ext: self.jsonExtension)
                fileURL.encodeAndWriteToFile(delivery: delivery)
            }
        }
    }
    
    func updateImageData(with id: String, batch: Int, imageData: Data) {
        DispatchQueue(label: updatImageAsyncQueueHint).async { [weak self] in
            guard let self = self,
                let folderURL = self.folderURL else { return }
            folderURL.createFolderIfNeeded()
            let batchFolderURL = folderURL.appendingPathComponent(String(batch))
            batchFolderURL.createFolderIfNeeded()
            
            let fileURL = self.getFileURL(folderURL: folderURL, batch: String(batch), id: id, ext: self.jsonExtension)
            if let data = try? Data(contentsOf: fileURL),
                let delivery = try? JSONDecoder().decode(Delivery.self, from: data) {
                delivery.goodsPicData = imageData.base64EncodedString()
                fileURL.encodeAndWriteToFile(delivery: delivery)
            }
        }
    }
    
    func fetchDeliveriesFromLocal(batch: Int) -> [Delivery] {
        var result = [Delivery]()
        
        guard let folderURL = folderURL?.appendingPathComponent(String(batch)),
            let fileURLs = try? FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil) else {
                return result
        }
        
        for url in fileURLs {
            if let data = try? Data(contentsOf: url),
                let delivery = try? JSONDecoder().decode(Delivery.self, from: data) {
                result.append(delivery)
            }
        }
        
        return result.sorted(by: { $0.sortingNumber < $1.sortingNumber })
    }
}

fileprivate extension URL {
    
    func encodeAndWriteToFile(delivery: Delivery) {
        if FileManager.default.fileExists(atPath: self.path) {
            try? FileManager.default.removeItem(at: self)
        }
        let data = try? JSONEncoder().encode(delivery)
        try? data?.write(to: self, options: .atomicWrite)
    }
    
    func createFolderIfNeeded() {
        if !FileManager.default.fileExists(atPath: self.path) {
            try? FileManager.default.createDirectory(atPath: self.path, withIntermediateDirectories: true)
        }
    }
}
