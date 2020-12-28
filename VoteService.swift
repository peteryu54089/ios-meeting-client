//
//  VoteService.swift
//  MeetingSystem
//
//  Created by 喻慶雲 on 2018/1/11.
//  Copyright © 2018年 鐘皓廷. All rights reserved.
//

import Foundation

// For downloading the file from server
class VoteService {
    
    let voteWebIp:String
    let voteId:Int
    let voteTitle:String
    let webFileName:String
    let orderBy:Bool
    
    init(voteWebIp: String, voteId: Int, voteTitle: String, webFileName: String, orderBy: Bool) {
        self.voteWebIp = voteWebIp
        self.voteId = voteId
        self.voteTitle = voteTitle
        self.webFileName = webFileName
        self.orderBy = orderBy
    }
}


