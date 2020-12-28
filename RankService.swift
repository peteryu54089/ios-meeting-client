//
//  RankService.swift
//  MeetingSystem
//
//  Created by 喻慶雲 on 2018/1/11.
//  Copyright © 2018年 鐘皓廷. All rights reserved.
//

import Foundation

// For downloading the file from server
class RankService {
    
    let rankWebIp:String
    let rankId:Int
    let rankTitle:String
    let webFileName:String
        
    init(rankWebIp: String, rankId: Int, rankTitle:String, webFileName: String) {
        self.rankWebIp = rankWebIp
        self.rankId = rankId
        self.rankTitle = rankTitle
        self.webFileName = webFileName
        
    }
}
