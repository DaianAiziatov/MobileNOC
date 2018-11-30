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
    @IBOutlet weak var statusView: UIView!
    @IBOutlet var actionButtonsCollection: [UIButton]!
    @IBOutlet weak var serverImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    var statusId: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStatusView()
        setupActionsButtons()
        serverImageView.makeCircleBorders()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        containerView.backgroundColor = selected ? #colorLiteral(red: 0.8920308948, green: 0.9604279399, blue: 0.998091042, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupActionsButtons()
        setupStatusView()
        setStatusIndiacator()
    }
    
    // MARK: Set Status Indicator
    
    func setStatusIndiacator() {
        switch self.statusId {
            case 1: statusView.backgroundColor = #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)
            case 2: statusView.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            case 3: statusView.backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
            case 4: statusView.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            default: statusView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
        insideStatusView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    // MARK: UI Setup
    private func setupStatusView() {
        statusView.makeCircleBorders()
        insideStatusView.makeCircleBorders()
    }
    
    private func setupActionsButtons() {
        actionButtonsCollection.enumerated().forEach({
            actionButtonsCollection[$0.offset].makeCircleBorders()
            actionButtonsCollection[$0.offset].backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        })
    }
    
}
