//
//  LocalStorageHandler.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import SwiftyJSON

class FileFailedToWriteError: Error {}

protocol LocalStorageHandlerInterface {
    func updateImageData(with id: String, batchNum: Int, imageData: Data)
    func storeDeliveryRawJSONToLocal(batch: Int, deliveries: [Delivery])
    func fetchDeliveriesFromLocal() -> [JSON]
}

class DeliveryLocalStorageHandler: LocalStorageHandlerInterface {
    
    private let jsonStorageFolder = "lalamove-challange-folder"
    private let jsonExtension = "json"
    private let docDirURL: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    private var folderURL: URL? {
        return docDirURL?.appendingPathComponent(jsonStorageFolder)
    }
    
    func updateImageData(with id: String, batchNum: Int, imageData: Data) {
        guard let folderURL = folderURL else { return }
        createFolderIfNeeded(folderURL: folderURL)
        let batchFolderURL = folderURL.appendingPathComponent(String(batchNum))
        createFolderIfNeeded(folderURL: batchFolderURL)
        
        let fileURL = getFileURL(folderURL: folderURL, batch: String(batchNum), id: id, ext: jsonExtension)
        let data = try! Data(contentsOf: fileURL)
        let delivery = try! JSONDecoder().decode(Delivery.self, from: data)
        delivery.goodsPicData = imageData
        
        encodeAndWriteToFile(fileURL: fileURL, delivery: delivery)
    }
    
    func storeDeliveryRawJSONToLocal(batch: Int, deliveries: [Delivery]) {
        guard let folderURL = folderURL else { return }
        createFolderIfNeeded(folderURL: folderURL)
        let batchFolderURL = folderURL.appendingPathComponent(String(batch))
        createFolderIfNeeded(folderURL: batchFolderURL)
        
        for delivery in deliveries {
            let fileURL = getFileURL(folderURL: folderURL, batch: String(batch), id: delivery.id, ext: jsonExtension)
            encodeAndWriteToFile(fileURL: fileURL, delivery: delivery)
        }
    }
    
    fileprivate func encodeAndWriteToFile(fileURL: URL, delivery: Delivery) {
        let data = try! JSONEncoder().encode(delivery)
        try! data.write(to: fileURL, options: .atomic)
    }
    
    fileprivate func createFolderIfNeeded(folderURL: URL) {
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            try? FileManager.default.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    fileprivate func getFileURL(folderURL: URL, batch: String, id: String, ext: String) -> URL {
        return folderURL.appendingPathComponent(batch).appendingPathComponent(id).appendingPathExtension(ext)
    }
    
    func fetchDeliveriesFromLocal() -> [JSON] {
        var result: [JSON] = []
//        let fileManager = FileManager.default
//        guard let documentsURL = docDirURL?.appendingPathComponent(jsonStorageFolder) else { return [] }
//        do {
//            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
//            if fileURLs != nil {
//                for i in 0..<fileURLs.count {
//                    let data = try! Data(contentsOf: documentsURL.appendingPathComponent(String(i)).appendingPathExtension(jsonExtension))
//                    let json = try! JSON(data: data)
//                    result.append(json)
//                }
//            }
//        } catch {
//            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
//        }
        return result
    }
}
