//
//  FileTableViewCell.swift
//  MeetingSystem
//
//  Created by 鐘皓廷 on 2017/12/1.
//  Copyright © 2017年 鐘皓廷. All rights reserved.
//

import UIKit

protocol cellDelegate {
    func didClickViewButton(cell:UITableViewCell)

}

class FileTableViewCell: UITableViewCell {
    
    var delegate : cellDelegate?
    @IBOutlet weak var fileName: UILabel!
    
    @IBOutlet weak var viewbutton: UIButton!
    
    @IBAction func view(_ sender: Any) {
        delegate?.didClickViewButton(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
