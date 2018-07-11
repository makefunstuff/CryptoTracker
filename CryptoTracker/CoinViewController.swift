//
//  CoinViewController.swift
//  CryptoTracker
//
//  Created by IURII PLUGATAROV on 08/07/2018.
//  Copyright © 2018 makefunstuff. All rights reserved.
//

import UIKit
import SwiftChart

private let chartHeight : CGFloat = 300.00
private let imageSize   : CGFloat = 100.00
private let priceLabelHeight : CGFloat = 25.00

class CoinViewController: UIViewController, CoinDataDelegate {
  
  var chart = Chart()
  var coin: Coin?
  let priceLabel = UILabel()
  let youOwnLabel = UILabel()
  let worthLabel = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let coin = coin {
      CoinData.shared.delegate = self
      
      edgesForExtendedLayout = []
      view.backgroundColor = UIColor.white
      title = coin.symbol
      
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
      
      chart.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: chartHeight)
      
      chart.yLabelsFormatter = { CoinData.shared.doubleToMoneyString(double: $1) }
      chart.xLabels = [30, 25, 20, 15, 10, 5, 0]
      chart.xLabelsFormatter = { String(Int(round(30 - $1))) + "d" }
      view.addSubview(chart)
      
      let imageXPosition = view.frame.size.width / 2 - imageSize / 2
      let imageView = UIImageView(frame: CGRect(x: imageXPosition, y: chartHeight, width: imageSize, height: imageSize))
      imageView.image = coin.image
      view.addSubview(imageView)
      
      priceLabel.frame = CGRect(x: 0, y: chartHeight + imageSize, width: view.frame.size.width, height: priceLabelHeight)
      priceLabel.textAlignment = .center
      view.addSubview(priceLabel)
      
      youOwnLabel.frame = CGRect(x: 0, y: chartHeight + imageSize + priceLabelHeight * 2, width: view.frame.size.width, height: priceLabelHeight)
      youOwnLabel.textAlignment = .center
      youOwnLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
      view.addSubview(youOwnLabel)
      
      worthLabel.frame = CGRect(x: 0, y: chartHeight + imageSize + priceLabelHeight * 3, width: view.frame.size.width, height: priceLabelHeight)
      worthLabel.textAlignment = .center
      worthLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
      view.addSubview(worthLabel)
      
      coin.getHistoricalData()
      newPrices()
    }
  }
  
  @objc func editTapped() {
    if let coin = coin {
      let alert = UIAlertController(title: "How much \(coin.symbol)", message: nil, preferredStyle: .alert)
      alert.addTextField { textField in
        textField.placeholder = "0.5"
        textField.keyboardType = .decimalPad
        
      }
      
      alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
        if let text = alert.textFields?[0].text {
          if let amount = Double(text) {
            self.coin?.amount = amount
            self.newPrices()
          }
        }
      })
      
      self.present(alert, animated: true, completion: nil)
    }
  
  }
  
  func newHistory() {
    let series = ChartSeries(coin!.historicalData)
    series.area = true
    chart.add(series)
  }
  
  func newPrices() {
    if let coin = coin {
      priceLabel.text = coin.priceAsString()
      youOwnLabel.text = "You own \(coin.amount) \(coin.symbol) "
      worthLabel.text = coin.amountAsString()
    }
  }
}