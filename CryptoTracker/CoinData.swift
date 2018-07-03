//
//  CoinData.swift
//  CryptoTracker
//
//  Created by IURII PLUGATAROV on 01/07/2018.
//  Copyright © 2018 makefunstuff. All rights reserved.
//

import UIKit

class CoinData {
  static let shared = CoinData()
  var coins = [Coin]()
  
  private init() {
    self.coins = ["BTC", "ETH", "LTC"].map { Coin(symbol: $0) }
  }
}

class Coin {
  var symbol: String = ""
  var image = UIImage()
  var amount = 0.0
  var historicalData = [Double]()
  
  init(symbol: String) {
    self.symbol = symbol
  }
}
