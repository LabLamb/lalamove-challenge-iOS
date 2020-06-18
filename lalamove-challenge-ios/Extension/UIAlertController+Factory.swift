//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func makeGenericAPIError(message: String) -> UIAlertController {
        let alertCtrl = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { alert in
            alertCtrl.dismiss(animated: true, completion: nil)
        })
        alertCtrl.addAction(alertAction)
        return alertCtrl
    }
}
