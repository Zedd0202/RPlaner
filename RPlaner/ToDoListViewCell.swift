//
//  ToDoListViewCell.swift
//  RPlaner
//
//  Created by Zedd on 2017. 2. 10..
//  Copyright © 2017년 Zedd. All rights reserved.
//

import UIKit

class ToDoListViewCell: UITableViewCell {
    @IBOutlet weak var todoListTitleLabel: UILabel!
    var todo: ToDo? {
        didSet {
            
            todoListTitleLabel.text = todo?.planTitle
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
