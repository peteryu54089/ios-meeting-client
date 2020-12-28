//
//  CasesVoteService.swift
//  MeetingSystem
//
//  Created by LAB on 2018/4/3.
//  Copyright © 2018年 鐘皓廷. All rights reserved.
//

import Foundation

class CasesVoteService {
    
    let casesVoteWebIp:String
    let casesVoteId:Int
    let casesVoteTitle:String
    let webFileName:String
    
    init(voteWebIp: String, voteId: Int, voteTitle:String, webFileName: String) {
        self.casesVoteWebIp = voteWebIp
        self.casesVoteId = voteId
        self.casesVoteTitle = voteTitle
        self.webFileName = webFileName
    }
}
