//
//  RankTableViewCell.swift
//  MeetingSystem
//
//  Created by 喻慶雲 on 2018/1/11.
//  Copyright © 2018年 鐘皓廷. All rights reserved.
//

import UIKit

protocol cellRankDelegate {
    func didClickViewButton(cell:UITableViewCell)
    
}

class RankTableViewCell: UITableViewCell {
    
    var delegate : cellRankDelegate?
    @IBOutlet weak var fileName: UILabel!
    
    @IBOutlet weak var viewbutton: UIButton!
    
    @IBAction func view(_ sender: Any) {
        delegate?.didClickViewButton(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
