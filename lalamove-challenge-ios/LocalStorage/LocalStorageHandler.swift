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
    func storeDeliveryRawJSONToLocal(id: String, data: Data, onError: (FileFailedToWriteError) -> ()) {
        guard let docDirURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            onError(FileFailedToWriteError())
            return
        }
        let fileURL = docDirURL.appendingPathComponent(id)
        try? data.write(to: fileURL.appendingPathExtension(".json"))
    }
    
    func fetchDeliveriesFromLocal() -> [Delivery] {
        return []
    }
}
