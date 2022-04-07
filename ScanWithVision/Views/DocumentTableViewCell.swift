//
//  DocumentTableViewCell.swift
//  ScanWithVision
//
//  Created by Tarek Noubli on 07/04/2022.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    var document: Document? {
        didSet {
            titleTextField.text = document?.id.uuidString
            dateUILabel.text = document?.date.formatted()
        }
    }

    // MARK: IBOutlets and actions

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateUILabel: UILabel!
    @IBAction func actionButtonTouched(_ sender: Any) {
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
