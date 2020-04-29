//
//  tableCell.swift
//  Personel
//
//  Created by Alper Altınkaynak on 28.04.2020.
//  Copyright © 2020 Alper Altınkaynak. All rights reserved.
//

import UIKit

class tableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
