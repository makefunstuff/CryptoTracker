//
//  CryptoTableViewController.swift
//  CryptoTracker
//
//  Created by IURII PLUGATAROV on 01/07/2018.
//  Copyright © 2018 makefunstuff. All rights reserved.
//

import UIKit

private let headerHeight : CGFloat = 100.0
private let netWorthHeight: CGFloat = 45.0

class CryptoTableViewController: UITableViewController, CoinDataDelegate {
  var amountLabel = UILabel()
  
  override func viewDidLoad() {
    CoinData.shared.delegate = self
    CoinData.shared.getPrices()
    
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    CoinData.shared.delegate = self
    tableView.reloadData()
    displayNetWorth()
  }
  
  func newPrices() {
    displayNetWorth()
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return headerHeight
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return CoinData.shared.coins.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    let coin = CoinData.shared.coins[indexPath.row]
    
    if coin.amount != 0 {
      cell.textLabel?.text = "\(coin.symbol) - \(coin.priceAsString()) - \(coin.amount)"
    } else {
      cell.textLabel?.text = "\(coin.symbol) - \(coin.priceAsString())"
    }
    cell.imageView?.image = coin.image
    
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return createHeaderView()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let viewController = CoinViewController()
    viewController.coin = CoinData.shared.coins[indexPath.row]
  
    navigationController?.pushViewController(viewController, animated: true)
  }
  
  func createHeaderView() -> UIView {
    let headerViewFrame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: headerHeight)
    let headerView = UIView(frame: headerViewFrame)
    let netWorthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: netWorthHeight))
    
    amountLabel.frame = CGRect(x: 0, y: netWorthHeight, width: view.frame.size.width, height: headerHeight - netWorthHeight)
    amountLabel.textAlignment = .center
    amountLabel.font = UIFont.boldSystemFont(ofSize: 60.0)
    
    netWorthLabel.text = "My Crypto Net Worth"
    netWorthLabel.textAlignment = .center
    
    headerView.backgroundColor = UIColor.white
    
    headerView.addSubview(netWorthLabel)
    headerView.addSubview(amountLabel)
    
    return headerView
  }
  
  func displayNetWorth() {
    amountLabel.text = CoinData.shared.netWorthAsString()
  }
}
