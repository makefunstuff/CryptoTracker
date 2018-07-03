//
//  CoinData.swift
//  CryptoTracker
//
//  Created by IURII PLUGATAROV on 01/07/2018.
//  Copyright © 2018 makefunstuff. All rights reserved.
//

import UIKit
import Alamofire

class CoinData {
  static let shared = CoinData()
  var coins = [Coin]()
  weak var delegate: CoinDataDelegate?
  
  private init() {
    self.coins = ["BTC", "ETH", "LTC"].map { Coin(symbol: $0) }
  }
  
  func getPrices() {
    let symbols = coins.map { $0.symbol }.joined(separator: ",")
    
    Alamofire.request("https://min-api.cryptocompare.com/data/pricemulti?fsyms=\(symbols)&tsyms=EUR")
      .responseJSON() { response in
        guard let json = response.result.value as? [String:Any] else {
          fatalError("Parse Error")
        }
        
        self.coins = self.coins.map {
          guard let coinJSON = json[$0.symbol] as? [String:Double] else {
            fatalError("Symbol fetch Error")
          }
          guard let price = coinJSON["EUR"] else { fatalError("Could not fetch price") }
          $0.price = price
          return $0
      }
      self.delegate?.newPrices?()
    }
  }
}

@objc protocol CoinDataDelegate : class {
  @objc optional func newPrices()
}

class Coin {
  var symbol: String = ""
  var image = UIImage()
  var amount = 0.0
  var historicalData = [Double]()
  var price = 0.0
  
  init(symbol: String) {
    self.symbol = symbol
    
    if let image = UIImage(named: symbol.lowercased()) {
      self.image = image
    }
  }
  
  func priceAsString() -> String {
    if price == 0.0 {
      return "Loading..."
    } else {
      let formatter = NumberFormatter()
      formatter.locale = Locale(identifier: "fi_FI")
      formatter.numberStyle = .currency
      
      guard let price = formatter.string(from: NSNumber(floatLiteral: price)) else {
        fatalError("Could not format price")
      }
      return price
    }
  }
}
