//
//  WatchlistViewController.swift
//  stockr
//
//  Created by Joschua Marz on 29.11.20.
//

import UIKit



class WatchlistViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, DetailDelegate {
    
    

    @IBOutlet weak var searchTextField: SearchTextField!
    @IBOutlet weak var stocksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        watchedStocks = stockManager.getWatchedStocks()
        filteredStocks = watchedStocks
        stocksTableView.reloadData()
    }
    
    func didDeleteStock() {
        watchedStocks = stockManager.getWatchedStocks()
        filteredStocks = watchedStocks
        stocksTableView.reloadData()
    }

    let stockManager = StocksManager()
    var watchedStocks = StocksManager().getWatchedStocks()
    var filteredStocks = [Stock]()
    var selectedStock: Stock?
    
    //MARK: -TableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stocksTableView.dequeueReusableCell(withIdentifier: "StockCell") as! WatchlistTableViewCell
        cell.setStock(filteredStocks[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedStock = filteredStocks[indexPath.row]
        performSegue(withIdentifier: "detail", sender: self)
    }
    //MARK: -TextFieldDelegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        filteredStocks = watchedStocks
        stocksTableView.reloadData()
        return true
    }
    
    @IBAction func didChange(_ sender: Any) {
        let word = searchTextField.text ?? ""
        
        guard word != "" else {
            return
        }
        
        filteredStocks.removeAll()
        for stock in watchedStocks {
            if stock.getName().lowercased().contains(word.lowercased()) {
                filteredStocks.append(stock)
            }
        }
        
        stocksTableView.reloadData()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            if let destinationVC = segue.destination as? DetailViewController {
                destinationVC.givenStock = selectedStock
                destinationVC.delegate = self
            }
        }
    }
}
