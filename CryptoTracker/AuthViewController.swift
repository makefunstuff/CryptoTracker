//
//  AuthViewController.swift
//  CryptoTracker
//
//  Created by IURII PLUGATAROV on 12/07/2018.
//  Copyright © 2018 makefunstuff. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presentAuth()
  }
  
  func presentAuth() {
    LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authorize to get access to your porfolio") { success, error in
      if success {
        DispatchQueue.main.async {
          let rootViewController = CryptoTableViewController()
          let navigationController = UINavigationController(rootViewController: rootViewController)
          self.present(navigationController, animated: true, completion: nil)
        }
      } else {
        self.presentAuth()
      }
    }
  }
}
