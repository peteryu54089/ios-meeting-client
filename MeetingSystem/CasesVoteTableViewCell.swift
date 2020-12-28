//
//  CasesVoteTableViewCell.swift
//  MeetingSystem
//
//  Created by LAB on 2018/4/3.
//  Copyright © 2018年 鐘皓廷. All rights reserved.
//

import UIKit

protocol cellCasesVoteDelegate {
    func didClickViewButton(cell:UITableViewCell)
}

class CasesVoteTableViewCell: UITableViewCell {
    
    var delegate : cellCasesVoteDelegate?
    @IBOutlet weak var fileName: UILabel!
    
    @IBOutlet weak var viewbutton: UIButton!
    
    @IBAction func view(_ sender: Any) {
        delegate?.didClickViewButton(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
