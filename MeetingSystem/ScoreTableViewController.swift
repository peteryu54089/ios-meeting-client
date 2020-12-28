//
//  ScoreTableViewController.swift
//  MeetingSystem
//
//  Created by 喻慶雲 on 2017/12/14.
//  Copyright © 2017年 鐘皓廷. All rights reserved.
//

import UIKit
import WebKit

class ScoreTableViewController: UITableViewController, cellScoreDelegate{
    var webView:WKWebView?
    var service: Array<ScoreService> = []
    var isCurrentView: Bool = true
    let tcpStream = TCPStream.getSingleton()
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isCurrentView = true
        reload()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isCurrentView = false
    }
    
    func reload() {
        print("score view: ", isCurrentView)
        if(isCurrentView) {
            self.tcpStream.sendInt(self.tcpStream.intToByteArray(0))

            self.service = self.tcpStream.scoreObject
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline:.now() + 1.5, execute: {
                self.reload()
            })
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ScoreTableViewCell
        cell.fileName.text = service[indexPath.row].scoreTitle
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
        
    func didClickViewButton(cell: UITableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        if (indexPath?.row) != nil {
            
            //放參數到webview
            let services = tcpStream.scoreObject[(indexPath?.row)!]
            let id = services.scoreId
            let injectionPage = services.webFileName //指定網頁
            let mainPage = services.scoreWebIp //server端應該將score.htm改成score.html
            
            var identity = "";
            if let ip = getWiFiAddress() {
                let arr = ip.components(separatedBy: ".")
                identity = arr[3];
            } else {
                
            }
            
            let jsCode = "class dataObj{ getRelativePath(){return \"\(injectionPage)\" }};var scoreObj = new dataObj;var identity = \"\(identity)\";"
            
            let webviewService = WebviewService(id: id, mainPage: mainPage ,webType: "score", injectionScript: jsCode)

            let vc : PresentScoreViewController = UIStoryboard(name: "Score", bundle: nil).instantiateViewController(withIdentifier: "PresentScore") as! PresentScoreViewController
            vc.webviewService = webviewService;
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            //if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {  // **ipv6 committed
            if addrFamily == UInt8(AF_INET){
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
}

// Show the pdf or word view controller
class PresentScoreViewController: UIViewController {
    var webviewService:WebviewService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //DispatchQueue.global().async {
            //self.webviewService?.finishVoting(finish: {
              //  self.dismiss(animated: true, completion: nil)
            //})
        //}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let webView = self.webviewService?.createWebView()
        view.addSubview(webView!)
    }
    
    @IBAction func back(_ sender: Any) {
        let rootViewController:UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!
        if (rootViewController.presentedViewController != nil) {
            rootViewController.dismiss(animated: true, completion: nil)
        }
    }
}
