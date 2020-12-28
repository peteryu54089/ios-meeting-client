//
//  TCPStream.swift
//  MeetingSystem
//
//  Created by 鐘皓廷 on 2018/1/17.
//  Copyright © 2018年 鐘皓廷. All rights reserved.
//

import Foundation
import Alamofire
import MBProgressHUD

class TCPStream {
    
    let fileController = SendFileTableVIewController()
    var iStream: InputStream? = nil
    var oStream: OutputStream? = nil
    var scoreObject: Array<ScoreService> = []
    var voteObject: Array<VoteService> = []
    var rankObject : Array<RankService> = []
    var casesVoteObject: Array<CasesVoteService> = []
    var promotionObject: Array<PromotionService> = []
    var assessmentObject: Array<AssessmentService> = []
    
    private static var sInstance: TCPStream?
    
    private init() {
        
        let server = ServerInfo.getSingleton()
        let service = server.getServicePort()
        let ip = server.getIp()
    
        _ = Stream.getStreamsToHost(withName: ip, port: service, inputStream: &self.iStream, outputStream: &self.oStream)
        
        self.iStream?.open()
        self.oStream?.open()
    }
    
    static func getSingleton() -> TCPStream {
        if sInstance == nil {
            sInstance = TCPStream()
        }
        return sInstance!
    }
    
    func tcpConnectToServer() {
        DispatchQueue.global().async {
            self.receiveData(available: { (string) in
                //DispatchQueue.global().async {
                    if let string = string {
                        self.splitStrings(string: string)
                        print(string)
                    }
                //}
            })
        }
    }
    
    func receiveData(available: (_ string: String?) -> Void) {
        var buf = Array(repeating: UInt8(0), count: 2048)
        
        while true {
            if (iStream?.hasBytesAvailable)! {
                print("Receiveing Data")
                let n = iStream?.read(&buf, maxLength: 2048)
                print(String(describing: n))
                if String(describing: n) == "Optional(0)" {
                    print("---------- exit ----------")
                    let serverAlert = UIAlertController(title: "與伺服器失去連線", message:"\n\n\n", preferredStyle: .alert)
                    let loadingIndicator = UIActivityIndicatorView(frame: serverAlert.view.bounds)
                    loadingIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    loadingIndicator.color = UIColor.black
                    loadingIndicator.startAnimating()
                    serverAlert.view.addSubview(loadingIndicator)
                    let rootViewController:UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!
                    //if (rootViewController.presentedViewController != nil) {
                        rootViewController.present(serverAlert, animated: true, completion: nil)
                    //}
                    sleep(5)
                    exit(0)
                }
                let data = Data(bytes: buf, count: n!)
                let string = String(data: data, encoding: .utf8)
                available(string)
            }
        }
    }
    
    func intToByteArray(_ value: Int) -> [UInt8] {
        var result:[UInt8] = Array()
        var number:Int = value
        
        for _ in (0 ..< MemoryLayout<Int>.size).reversed() {
            result.insert(UInt8(number & 0xFF), at:0)
            number >>= 8
        }
        return result
    }
    
    func sendInt(_ data: [UInt8]) {
        oStream?.write(data, maxLength: data.count)
    }
    
    func send(_ datas: [UInt8], _ string: String) {
        let str = [UInt8](string.utf8)
        var s = datas
        s.append(contentsOf: str)
        print("send: ", s)
        oStream?.write(s, maxLength: s.count)
    }
    
    func splitStrings(string: String) {
        if string.contains("cmd") {
            do{
                if let data = string.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
                    let jsonArray = jsonObject["msg"]! as! [[String: Any]]
                    if (jsonObject["cmd"] as! Int == 2 ) {
                        for dict in jsonArray {
                            let webPath:String  = dict["WebPath"]! as! String
                            let filePath:String = dict["FilePath"]! as! String
                            print("webpath: \(String(describing: webPath)) filePath: \(String(describing: filePath))")
                            
                            downloadFile(webPath: webPath, filePath: filePath, completion: { () in })
                        }
                    } else if (jsonObject["cmd"] as! Int == 0 ){
                        scoreObject.removeAll()
                        for dict in jsonArray {
                            let scoreWebIp:String  = dict["ScoreWebIp"]! as! String
                            let scoreId:Int = dict["ScoreId"]! as! Int
                            var scoreTitle:String = dict["ScoreSourcePath"] as! String
                            scoreTitle = scoreTitle.components(separatedBy: "\\").last!
                            let webFileName:String = dict["WebFileName"]! as! String
                            let service = ScoreService(scoreWebIp: scoreWebIp, scoreId: scoreId,scoreTitle: scoreTitle ,webFileName: webFileName)
                            
                            if(scoreObject.isEmpty){
                                scoreObject.append(service)
                            }else if(scoreId > scoreObject[scoreObject.count-1].scoreId){
                                scoreObject.append(service)
                            }
                        }
                    } else if (jsonObject["cmd"] as! Int == 1 ){
                        voteObject.removeAll()
                        for dict in jsonArray {
                            let voteWebIp:String  = dict["VoteWebIp"]! as! String
                            let voteId:Int = dict["VoteId"]! as! Int
                            var voteTitle:String = dict["VoteSourcePath"] as! String
                            voteTitle = voteTitle.components(separatedBy: "\\").last!
                            let webFileName:String = dict["WebFileName"]! as! String
                            let orderBy:Bool = dict["OrderBy"]! as! Bool
                            let service = VoteService(voteWebIp: voteWebIp, voteId: voteId, voteTitle: voteTitle, webFileName: webFileName, orderBy: orderBy)
                            
                            if(voteObject.isEmpty){
                                voteObject.append(service)
                            }else if(voteId > voteObject[voteObject.count-1].voteId){
                                voteObject.append(service)
                            }
                        }
                    } else if (jsonObject["cmd"] as! Int == 3 ){
                        rankObject.removeAll()
                        for dict in jsonArray {
                            let rankWebIp:String  = dict["RankWebIp"]! as! String
                            let rankId:Int = dict["RankId"]! as! Int
                            var rankTitle:String = dict["RankSourcePath"] as! String
                            rankTitle = rankTitle.components(separatedBy: "\\").last!
                            let webFileName:String = dict["WebFileName"]! as! String
                            let service = RankService(rankWebIp: rankWebIp, rankId: rankId, rankTitle:rankTitle, webFileName: webFileName)
                            
                            if(rankObject.isEmpty){
                                rankObject.append(service)
                            }else if(rankId > rankObject[rankObject.count-1].rankId){
                                rankObject.append(service)
                            }
                        }
                    } else if (jsonObject["cmd"] as! Int == 5 ){
                        casesVoteObject.removeAll()
                        for dict in jsonArray {
                            let casesVoteWebIp:String  = dict["CaseVoteWebIp"]! as! String
                            let casesVoteId:Int = dict["CaseVoteId"]! as! Int
                            var casesVoteTitle:String = dict["CaseVoteSourcePath"] as! String
                            casesVoteTitle = casesVoteTitle.components(separatedBy: "\\").last!
                            let webFileName:String = dict["WebFileName"]! as! String
                            let service = CasesVoteService(voteWebIp: casesVoteWebIp, voteId: casesVoteId, voteTitle: casesVoteTitle, webFileName: webFileName)
                            
                            if(casesVoteObject.isEmpty){
                                casesVoteObject.append(service)
                            }else if(casesVoteId > casesVoteObject[casesVoteObject.count-1].casesVoteId){
                                casesVoteObject.append(service)
                            }
                        }
                    } else if (jsonObject["cmd"] as! Int == 6 ){
                        promotionObject.removeAll()
                        for dict in jsonArray {
                            let promotionWebIp:String  = dict["PromotionWebIp"]! as! String
                            let promotionId:Int = dict["PromotionId"]! as! Int
                            var promotionTitle:String = dict["PromotionSourcePath"] as! String
                            promotionTitle = promotionTitle.components(separatedBy: "\\").last!
                            let webFileName:String = dict["WebFileName"]! as! String
                            let service = PromotionService(promotionWebIp: promotionWebIp, promotionId: promotionId, promotionTitle:promotionTitle, webFileName: webFileName)
                            
                            if(promotionObject.isEmpty){
                                promotionObject.append(service)
                            }else if(promotionId > promotionObject[promotionObject.count-1].promotionId){
                                promotionObject.append(service)
                            }
                        }
                    } else if (jsonObject["cmd"] as! Int == 7 ) {
                        assessmentObject.removeAll()
                        for dict in jsonArray {
                            let assessmentWebIp:String  = dict["AssessmentWebIp"]! as! String
                            let assessmentId:Int = dict["AssessmentId"]! as! Int
                            var assessmentTitle:String = dict["AssessmentSourcePath"] as! String
                            assessmentTitle = assessmentTitle.components(separatedBy: "\\").last!
                            let webFileName:String = dict["WebFileName"]! as! String
                            let service = AssessmentService(assessmentWebIp: assessmentWebIp, assessmentId: assessmentId, assessmentTitle:assessmentTitle, webFileName: webFileName)
                            
                            if(assessmentObject.isEmpty){
                                assessmentObject.append(service)
                            }else if(assessmentId > assessmentObject[assessmentObject.count-1].assessmentId){
                                assessmentObject.append(service)
                            }
                        }
                    } else if (jsonObject["cmd"] as! Int == 4 ){
                        exit(0)
                    }
                }
            } catch  {
                print("catch string: ", string)
                print("Something went wrongs")
            }
        }
    }
    
    func downloadFile(webPath: String, filePath: String, completion: @escaping () -> Void) {
        checkDiretoryExist()
        
        // the local destination where to save files
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let urlString = Variables.fileSavePaths?.appendingPathComponent(self.splitFilePathToGetTheFileName(filePath: filePath))
            return (urlString!, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        let alert = UIAlertController(title: "檔案下載中", message: "\n", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認", style: .default, handler: {(action: UIAlertAction!) -> Void in
            print("按下確認後，閉包裡的動作")
        })
        let rect = CGRect(x:10, y:70, width: 250, height:0)
        let progressBar = UIProgressView(frame: rect)
        var progress = 0.0
        progressBar.progress = 0
        alert.view.addSubview(progressBar)
        alert.show()
        
        Alamofire.download(URL(string: webPath)!, to: destination).downloadProgress(closure: { (prog) in
            DispatchQueue.global(qos:.background).async {
                progress = prog.fractionCompleted
                DispatchQueue.main.async {
                    progressBar.progress = Float(progress)
                }
            }
            
            print(Float(prog.fractionCompleted))
            
        }).response { response in
            alert.addAction(okAction)
            print(response)
            if response.error == nil {
                //let s = SendFileTableVIewController()
                //s.fileList.append(self.splitFilePathToGetTheFileName(filePath: filePath))
            }
        }
    }
    
    func checkDiretoryExist() {
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
    }
    
    func splitFilePathToGetTheFileName(filePath: String) -> String {
        print("filePath ", filePath)
        return  filePath.components(separatedBy: "\\").last!
    }
}

extension UIAlertController {
    
    func show() {
        present(animated: true, completion: nil)
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        } else
            if let tabVC = controller as? UITabBarController,
                let selectedVC = tabVC.selectedViewController {
                presentFromController(controller: selectedVC, animated: animated, completion: completion)
            } else {
                controller.present(self, animated: animated, completion: completion);
        }
    }
}
