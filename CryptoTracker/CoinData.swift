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
          UserDefaults.standard.set(price, forKey: $0.symbol)
          return $0
      }
      self.delegate?.newPrices?()
    }
  }
  
  func html() -> String {
    var html = "<h1>My Crypto Report</h1>"
    html += "<h2>Net Worth: \(netWorthAsString())</h2>"
    html += "<ul>"
    
    for coin in coins {
      if coin.amount != 0.0 {
        html += "<li>\(coin.symbol) - I own: \(coin.amount). Valued: \(doubleToMoneyString(double: coin.amount * coin.price))</li>"
      }
    }
    
    html += "</ul>"
    
    return html
  }
  
  func netWorthAsString() -> String {
    let netWorth = coins.reduce(0.0, { (result, coin) in
      result + (coin.amount * coin.price)
    })
    
    return doubleToMoneyString(double: netWorth)
  }
  
  func doubleToMoneyString(double: Double) -> String {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "fi_FI")
    formatter.numberStyle = .currency
    
    guard let price = formatter.string(from: NSNumber(floatLiteral: double)) else {
      fatalError("Could not format price")
    }
    return price
  }
}

@objc protocol CoinDataDelegate : class {
  @objc optional func newPrices()
  @objc optional func newHistory()
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
    self.price = UserDefaults.standard.double(forKey: symbol)
    self.amount = UserDefaults.standard.double(forKey: symbol + "amount")
    
    if let history = UserDefaults.standard.array(forKey: symbol + "history") as? [Double] {
      self.historicalData = history
    }
  }
  
  func priceAsString() -> String {
    if price == 0.0 {
      return "Loading..."
    } else {
      return CoinData.shared.doubleToMoneyString(double: price)
    }
  }
  
  func amountAsString() -> String {
    return CoinData.shared.doubleToMoneyString(double: amount * price)
  }
  
  func getHistoricalData() {
    Alamofire.request("https://min-api.cryptocompare.com/data/histoday?fsym=\(symbol)&tsym=EUR&limit=30").responseJSON() { response in
      guard let jsonData = response.result.value as? [String:Any] else { fatalError("Parse Error \(response.result)") }
      guard let prices = jsonData["Data"] as? [[String:Double]] else { return }
      self.historicalData = prices.map { $0["close"]! }
      
      CoinData.shared.delegate?.newHistory!()
      UserDefaults.standard.set(self.historicalData, forKey: self.symbol + "history")
    }
  }
}
