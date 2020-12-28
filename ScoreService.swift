//
//  ScoreService.swift
//  MeetingSystem
//
//  Created by 喻慶雲 on 2018/1/4.
//  Copyright © 2018年 鐘皓廷. All rights reserved.
//

import Foundation

// For downloading the file from server
class ScoreService {
    
    let scoreWebIp:String
    let scoreId:Int
    let scoreTitle:String
    let webFileName:String
    
    init(scoreWebIp: String, scoreId: Int ,scoreTitle:String, webFileName: String) {
        self.scoreWebIp = scoreWebIp
        self.scoreId = scoreId
        self.scoreTitle = scoreTitle
        self.webFileName = webFileName
    }
}

//// for listing and deleteing the file in ipad
//class ScoreOperation {
//
//    func deleteFile(fileName: String) {
//
//        print("Delete file: \(fileName)")
//        let fileManager = FileManager.default
//        do {
//            try fileManager.removeItem(atPath: "\(Variables.scoreSavePath)/\(fileName)")
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
//    func list() -> Array<String>{
//
//        var fileList:Array? = []
//        let fileManager: FileManager = FileManager()
//        let files = fileManager.enumerator(atPath: Variables.scoreSavePath)
//        while let file = files?.nextObject() {
//            if ( (String(describing: file).range(of: "pdf") != nil) ) || ( String(describing: file).range(of: "doc") != nil ) {
//                fileList?.append(String(describing: file))
//            }
//        }
//
//        return fileList as! Array<String>
//    }
//
//}

