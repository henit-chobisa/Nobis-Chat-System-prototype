//
//  senderTableViewCell.swift
//  ICLO
//
//  Created by Henit Work on 26/01/21.
//

import UIKit

class senderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var senderImage: UIImageView!
    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var additional: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            self.mainview.layer.cornerRadius = self.mainview.frame.width/10
           
            self.message.clipsToBounds = true
//            self.message.sizeToFit()
            self.senderImage.layer.cornerRadius = 10
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
