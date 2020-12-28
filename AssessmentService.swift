//
//  AssessmentService.swift
//  MeetingSystem
//
//  Created by 喻慶雲 on 2019/06/28.
//  Copyright © 2018年 鐘皓廷. All rights reserved.
//

import Foundation

// For downloading the file from server
class AssessmentService {
    
    let assessmentWebIp:String
    let assessmentId:Int
    let assessmentTitle:String
    let webFileName:String
    
    init(assessmentWebIp: String, assessmentId: Int, assessmentTitle:String, webFileName: String) {
        self.assessmentWebIp = assessmentWebIp
        self.assessmentId = assessmentId
        self.assessmentTitle = assessmentTitle
        self.webFileName = webFileName
    }
}
