//
//  MessageCellTableViewCell.swift
//  ICLO
//
//  Created by Henit Work on 25/01/21.
//

import UIKit

class MessageCellTableViewCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var mainview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            self.mainview.clipsToBounds = true
            self.mainview.layer.cornerRadius = self.mainview.frame.width/10
            
            self.userImage.layer.cornerRadius = 10
            self.message.clipsToBounds = true
//            self.message.sizeToFit()
           
        }
    
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
