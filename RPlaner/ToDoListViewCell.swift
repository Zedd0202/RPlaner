//
//  ToDoListViewCell.swift
//  RPlaner
//
//  Created by Zedd on 2017. 2. 10..
//  Copyright © 2017년 Zedd. All rights reserved.
//

import UIKit

class ToDoListViewCell: UITableViewCell {
    @IBOutlet weak var todoListTitleLabel: UILabel?
    @IBOutlet weak var todoListSubtitleLabel: UILabel!
    //리스트뷰에서 계획 타이틀과 메모가 보이게.
    var todo: ToDo? {
        didSet {
            todoListTitleLabel?.text = todo?.planTitle
            todoListSubtitleLabel?.text = todo?.memo
            //set.
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
