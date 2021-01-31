//
//  ChatterRows.swift
//  ICLO
//
//  Created by Henit Work on 24/01/21.
//

import UIKit
import Canvas

class ChatterRows: UITableViewCell {
    @IBOutlet weak var mainView: CSAnimationView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.mainView.layer.cornerRadius = 15
            self.mainView.layer.borderWidth = 2
            self.mainView.layer.borderColor = #colorLiteral(red: 0, green: 1, blue: 0.9991329312, alpha: 1)
            self.profileImage.layer.cornerRadius = 10
            self.profileImage.layer.borderWidth = 0.5
            self.profileImage.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
