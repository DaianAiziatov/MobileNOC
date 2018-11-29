//
//  MachineTableViewCell.swift
//  MobileNOCAssessment
//
//  Created by Daian Aiziatov on 29/11/2018.
//  Copyright © 2018 Daian Aiziatov. All rights reserved.
//

import UIKit

class MachineTableViewCell: UITableViewCell {

    @IBOutlet weak var serverNameLabel: UILabel!
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var ipAddressLabel: UILabel!
    @IBOutlet weak var ipSubnetMaskLabel: UILabel!
    @IBOutlet private weak var insideStatusView: UIView!
    @IBOutlet weak var statusView: UIView! {
        didSet {
            statusView.makeCircleBorders()
            insideStatusView.makeCircleBorders()
        }
    }
    
    @IBOutlet var actionButtonsCollection: [UIButton]! {
        didSet {
            actionButtonsCollection.enumerated().forEach({
                actionButtonsCollection[$0.offset].makeCircleBorders()
            })
        }
    }
    
    @IBOutlet weak var serverImageView: UIImageView! {
        didSet {
            serverImageView.makeCircleBorders()
        }
    }
    
    var status: Int! {
        didSet {
            switch status {
                case 1: statusView.backgroundColor = #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)
                case 2: statusView.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
                case 3: statusView.backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
                case 4: statusView.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            default: statusView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
