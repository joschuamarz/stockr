//
//  WatchlistTableViewCell.swift
//  stockr
//
//  Created by Joschua Marz on 29.11.20.
//

import UIKit

class WatchlistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setStock(_ stock: Stock) {
        nameLabel.text = stock.getName()
        priceLabel.text = stock.getPrice().withTwoDecimalsString() + "€"
    }

}
