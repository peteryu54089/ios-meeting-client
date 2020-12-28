//
//  PromotionTableViewCell.swift
//  MeetingSystem
//
//  Created by 喻慶雲 on 2018/10/10.
//  Copyright © 2018年 鐘皓廷. All rights reserved.
//

import UIKit

protocol cellPromotionDelegate {
    func didClickViewButton(cell:UITableViewCell)
}

class PromotionTableViewCell: UITableViewCell {
    
    var delegate : cellPromotionDelegate?
    
    @IBOutlet weak var fileName: UILabel!
    
    @IBOutlet weak var viewbutton: UIButton!
    
    @IBAction func view(_ sender: Any) {
        delegate?.didClickViewButton(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
