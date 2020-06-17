//
//  LocalStorageHandler.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import SwiftyJSON

class FileFailedToWriteError: Error {}

class LocalStorageHandler {
    
    private let jsonStorageFolder = "lalamove-challange-folder"
    private let jsonExtension = "json"
    
    func storeDeliveryRawJSONToLocal(id: String, data: Data, onError: (FileFailedToWriteError) -> ()) {
        guard let docDirURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            onError(FileFailedToWriteError())
            return
        }
        
        let folderPath = docDirURL.appendingPathComponent(jsonStorageFolder)
        if !FileManager.default.fileExists(atPath: folderPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription);
            }
        }
        
        let fileURL = folderPath.appendingPathComponent("\(id)").appendingPathExtension(jsonExtension)
        try! data.write(to: fileURL, options: .atomic)
    }
    
    func fetchDeliveriesFromLocal() -> [Delivery] {
        var result: [Delivery] = []
        let fileManager = FileManager.default
        let documentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(jsonStorageFolder)
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            if fileURLs != nil {
                for i in 0..<fileURLs.count {
                    let data = try! Data(contentsOf: documentsURL.appendingPathComponent(String(i)).appendingPathExtension(jsonExtension))
                    let json = try! JSON(data: data)
                    result.append(Delivery(json: json))
                }
            }
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        return result
    }
}
