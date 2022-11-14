//
//  TableViewCell.swift
//  Aqui
//
//  Created by Dara Adekore on 2022-11-12.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var imagView: UIImageView!
    
    @IBOutlet weak var cityName: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
