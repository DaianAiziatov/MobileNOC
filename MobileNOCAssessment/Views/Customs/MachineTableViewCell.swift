//
//  MachineTableViewCell.swift
//  MobileNOCAssessment
//
//  Created by Daian Aiziatov on 29/11/2018.
//  Copyright © 2018 Daian Aiziatov. All rights reserved.
//

import UIKit

class MachineTableViewCell: UITableViewCell {

    @IBOutlet private weak var serverNameLabel: UILabel!
    @IBOutlet private weak var serialNumberLabel: UILabel!
    @IBOutlet private weak var ipAddressLabel: UILabel!
    @IBOutlet private weak var ipSubnetMaskLabel: UILabel!
    @IBOutlet private weak var insideStatusView: UIView!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private var actionButtonsCollection: [UIButton]!
    @IBOutlet private weak var serverImageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupActionsButtons()
        setupStatusView()
        indicatorView.hidesWhenStopped = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
    }
    
    func configure(with machine: Machine?) {
        if let machine = machine {
            containerView.isHidden = false
            serverNameLabel?.text = machine.name
            serialNumberLabel?.text = machine.serialNumber ?? "unknown"
            ipAddressLabel?.text = machine.ipAddress ?? "unknown"
            ipSubnetMaskLabel?.text = machine.ipSubnetMask ?? "unknown"
            setStatusIndiacator(with: machine.statusId)
            indicatorView.stopAnimating()
        } else {
            containerView.isHidden = true
            indicatorView.startAnimating()
        }
    }
    
    // MARK: Set Status Indicator
    private func setStatusIndiacator(with statusId: Int) {
        switch statusId {
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
