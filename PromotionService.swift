//
//  PromotionService.swift
//  MeetingSystem
//
//  Created by 喻慶雲 on 2018/10/10.
//  Copyright © 2018年 鐘皓廷. All rights reserved.
//

import Foundation

// For downloading the file from server
class PromotionService {
    
    let promotionWebIp:String
    let promotionId:Int
    let promotionTitle:String
    let webFileName:String
    
    init(promotionWebIp: String, promotionId: Int, promotionTitle:String, webFileName: String) {
        self.promotionWebIp = promotionWebIp
        self.promotionId = promotionId
        self.promotionTitle = promotionTitle
        self.webFileName = webFileName
    }
}
