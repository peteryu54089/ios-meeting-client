//
//  Variables.swift
//  MeetingSystem
//
//  Created by 鐘皓廷 on 2017/12/3.
//  Copyright © 2017年 鐘皓廷. All rights reserved.
//

import UIKit

// List usually used variable
class Variables: NSObject {
    
    static let mainPath =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    static let fileSavePath = mainPath + "/folder"
    
    static let mainPaths =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
    static let fileSavePaths = mainPaths.appendingPathComponent("folder", isDirectory: true)
    static let scoreSavePath = mainPath + "/scoreFolder"
    static let rankSavePath = mainPath + "/rankFolder"
    static let voteSavePath = mainPath + "/voteFolder"

}
