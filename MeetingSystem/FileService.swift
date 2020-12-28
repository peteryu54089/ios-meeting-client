//
//  FileService.swift
//  MeetingSystem
//
//  Created by 鐘皓廷 on 2017/11/29.
//  Copyright © 2017年 鐘皓廷. All rights reserved.
//

import Foundation
import Alamofire
import MBProgressHUD

// For downloading the file from server
class FileService {
    
    var url: URL
    let webPath: String
    let filePath: String
    
    init(webPath: String, filePath: String) {
        self.webPath = webPath
        self.filePath = filePath
        self.url = URL(string: self.webPath)!
    }

    // closure
    func downloadFile(completion: @escaping () -> Void) {
        
        //-- check local file save directory is exist --//
        var objectBool: ObjCBool = true
        let isExist = FileManager.default.fileExists(atPath: Variables.fileSavePath, isDirectory: &objectBool)
        print(Variables.fileSavePath)

        // Check whether this folder exist
        if isExist == false {
            do {
                try FileManager.default.createDirectory(atPath: Variables.fileSavePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("error")
            }
        }
        //-- check local file save directory is exist --//

        //-- progress bar --//
        //let hud = MBProgressHUD.showAdded(to: , animated: true)
        //hud.label.text = "下載中..."
        //-- progress bar --//

        
        // the local destination where to save files
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            
            let urlString = Variables.fileSavePaths?.appendingPathComponent(self.splitFilePathToGetTheFileName().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)

            print("@@", urlString ?? "")
            return (urlString!, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(url, to: destination).downloadProgress(closure: { (prog) in
           // hud.progress = Float(prog.fractionCompleted)
        }).response { response in
            print(response)
            //hud.hide(animated: true)
            if response.error == nil {
                let s = SendFileTableVIewController()
                s.fileList.append(self.splitFilePathToGetTheFileName().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            }
        }
//        do {
//            let urlData = try Data(contentsOf: self.url)
//            let urlString: String = "file://\(Variables.fileSavePath)/" + splitFilePathToGetTheFileName()
//            DispatchQueue.global().async {
//                do {
//
//                    try urlData.write(to: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
//                    let s = SendFileTableVIewController()
//                    s.fileList.append(self.splitFilePathToGetTheFileName())
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
    }
    
    func splitFilePathToGetTheFileName() -> String {
        print("filePath ", filePath)
        return  filePath.components(separatedBy: "\\").last!
    }
}

// for listing and deleteing the file in ipad
class FileOperation {
    
    func deleteFile(fileName: String) {
        
        print("Delete file: \(fileName)")
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: "\(Variables.fileSavePath)/\(fileName)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func list() -> Array<String>{
        
        var fileList:Array? = []
        let fileManager: FileManager = FileManager()
        let files = fileManager.enumerator(atPath: Variables.fileSavePath)
        while let file = files?.nextObject() {
            if ( (String(describing: file).range(of: "pdf") != nil) ) || ( String(describing: file).range(of: "doc") != nil ) {
                fileList?.append(String(describing: file))
            }
        }
        
        let sortedList = fileList?.sorted { ($0 as AnyObject).localizedCaseInsensitiveCompare(($1 as AnyObject) as! String) == ComparisonResult.orderedAscending }
        
        return sortedList as! Array<String>
    }
}
