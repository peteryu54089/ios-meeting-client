//
//  File.swift
//  MeetingSystem
//
//  Created by LAB on 2018/1/16.
//  Copyright © 2018年 鐘皓廷. All rights reserved.
//
import Foundation
import WebKit

class WebviewService:NSObject, WKNavigationDelegate, WKScriptMessageHandler{
    let tcpStream = TCPStream.getSingleton()
    var webView:WKWebView?
    var id: Int
    var webType:String
    var mainPage:String
    var userController:WKUserContentController
    var webViewConf:WKWebViewConfiguration
    var injectionScript:String
    var isVoted: Bool = false
    
    init(id: Int, mainPage:String, webType:String, injectionScript:String){
        self.webType = webType
        self.id = id
        self.mainPage = mainPage
        self.injectionScript = injectionScript
        self.userController = WKUserContentController()
        self.webViewConf = WKWebViewConfiguration()
        self.webViewConf.userContentController = self.userController
    }
    
    
    func createWebView() -> WKWebView {
        let userScript = WKUserScript(
            source: injectionScript,
            injectionTime: WKUserScriptInjectionTime.atDocumentStart,
            forMainFrameOnly: true
        )
        let screenSize = UIScreen.main.bounds

        self.userController.add(self as WKScriptMessageHandler, name: "sendLog")
        self.userController.add(self as WKScriptMessageHandler, name: "sendResultData")
        self.userController.addUserScript(userScript)
        
        webView = WKWebView(frame:CGRect(x:0, y:0, width: screenSize.width, height: screenSize.height), configuration:self.webViewConf)

        if let url = URL(string: self.mainPage){
            let request = URLRequest(url: url)
            webView?.navigationDelegate = self as WKNavigationDelegate
            webView?.load(request)
        }
        
        return webView!;
    }
 
    //接收網頁前端傳出的json訊息
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "sendResultData") {
            switch(self.webType){
            case "vote":
                let receiveData:String = message.body as! String
                let returnData = "{\"Id\":" + String(id) + ",\"CandidateList\":" + receiveData + "}\n"
                self.tcpStream.send(self.tcpStream.intToByteArray(4294967297), returnData) // Hex 100000001 to decimal 4294967297
                print("vote receive data : \(message.body)")
                break;
            case "score":
                let receiveData:String = message.body as! String
                let returnData = "{\"Id\":" + String(id) + "," + receiveData + "\n"
                self.tcpStream.send(tcpStream.intToByteArray(1), returnData) // Hex 000000001 to decimal 1
                print("score receive data : \(message.body)")
                break;
            case "rank":
                let receiveData:String = message.body as! String
                let returnData = "{\"Id\":" + String(id) + ",\"RankCandidateList\":" + receiveData + "}\n"
                self.tcpStream.send(self.tcpStream.intToByteArray(12884901889), returnData) // Hex 300000001 to decimal 12884901889
                print("rank receive data : \(message.body)")
                break;
            case "casesVote":
                //case vote unfinish,rewrite receiveData string value
                //tcpStream intToByteArray rewrite parm
                let receiveData:String = message.body as! String
                let returnData = "{\"Id\":" + String(id) + ",\"CandidateList\":" + receiveData + "}\n"
                self.tcpStream.send(self.tcpStream.intToByteArray(21474836481),returnData) // Hex 500000001 to decimal 21474836481
                print("cases vote receive data : \(message.body)")
                break;
            case "promotion":
                let receiveData:String = message.body as! String
                let returnData = "{\"Id\":" + String(id) + ",\"CandidateList\":" + receiveData + "}\n"
                self.tcpStream.send(tcpStream.intToByteArray(25769803777), returnData) // Hex 600000001 to decimal 25769803777
                print("promotion receive data : \(message.body)")
                break;
            case "assessment":
                let receiveData:String = message.body as! String
                let returnData = "{\"Id\":" + String(id) + ",\"CandidateList\":" + receiveData + "}\n"
                self.tcpStream.send(tcpStream.intToByteArray(30064771073), returnData) // Hex 700000001 to decimal 30064771073
                print("assessment receive data : \(message.body)")
                break;
            default: break;
            }
            let rootViewController:UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!
            if (rootViewController.presentedViewController != nil) {
                rootViewController.dismiss(animated: true, completion: nil)
            }
            //self.isVoted = true
        
        } else if(message.name == "sendLog"){
            print("log : \(message.body)")
        }
    }
}
