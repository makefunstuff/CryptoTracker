//
//  CryptoTableViewController.swift
//  CryptoTracker
//
//  Created by IURII PLUGATAROV on 01/07/2018.
//  Copyright © 2018 makefunstuff. All rights reserved.
//

import UIKit

class CryptoTableViewController: UITableViewController, CoinDataDelegate {
  override func viewDidLoad() {
    CoinData.shared.getPrices()
    CoinData.shared.delegate = self
    
    super.viewDidLoad()
  }
  
  func newPrices() {
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return CoinData.shared.coins.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    let coin = CoinData.shared.coins[indexPath.row]
    
    cell.textLabel?.text = "\(coin.symbol) - \(coin.price)"
    cell.imageView?.image = coin.image
    
    return cell
  }
  
}
