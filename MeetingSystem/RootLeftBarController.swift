//
//  RootLeftBarController.swift
//  MeetingSystem
//
//  Created by 鐘皓廷 on 2018/1/18.
//  Copyright © 2018年 鐘皓廷. All rights reserved.
//

import UIKit

class RootLeftBarController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openRecordViewController() { //廣播
        let viewcontroller:RecordViewController = UIStoryboard(name: "Record", bundle: nil).instantiateViewController(withIdentifier: "Record") as! RecordViewController
        self.splitViewController?.showDetailViewController(viewcontroller, sender: self)
    }
    
    func openSendFileViewController() {
        let viewcontroller:SendFileViewController = UIStoryboard(name: "SendFile", bundle: nil).instantiateViewController(withIdentifier: "SendFile") as! SendFileViewController
        self.splitViewController?.showDetailViewController(viewcontroller, sender: self)
    }
    
    func openSendFileTableViewController() { //檔案
        let viewcontroller:SendFileTableVIewController = UIStoryboard(name: "SendFile", bundle: nil).instantiateViewController(withIdentifier: "SendFileTableView") as! SendFileTableVIewController
        self.splitViewController?.showDetailViewController(viewcontroller, sender: self)
    }
    
    func openScoreTableViewController() { // 評分
        let viewcontroller:ScoreTableViewController = UIStoryboard(name: "Score", bundle: nil).instantiateViewController(withIdentifier: "ScoreTableView") as! ScoreTableViewController
        self.splitViewController?.showDetailViewController(viewcontroller, sender: self)
    }
    
    func openVoteTableViewController() { //複選排序
        let viewcontroller:VoteTableViewController = UIStoryboard(name: "Vote", bundle: nil).instantiateViewController(withIdentifier: "VoteTableView") as! VoteTableViewController
        self.splitViewController?.showDetailViewController(viewcontroller, sender: self)
    }
    
    func openRankTableViewController() { //序位
        let viewcontroller:RankTableViewController = UIStoryboard(name: "Rank", bundle: nil).instantiateViewController(withIdentifier: "RankTableView") as! RankTableViewController
        self.splitViewController?.showDetailViewController(viewcontroller, sender: self)
    }
    
    func openCasesVoteTableViewController() { //單記投票
        let viewcontroller:CasesVoteTableViewController = UIStoryboard(name: "CasesVote", bundle: nil).instantiateViewController(withIdentifier: "CasesVoteTableView") as! CasesVoteTableViewController
        self.splitViewController?.showDetailViewController(viewcontroller, sender: self)
    }
    
    func openPromotionTableViewController() { //陞任
        let viewcontroller:PromotionTableViewController = UIStoryboard(name: "Promotion", bundle: nil).instantiateViewController(withIdentifier: "PromotionTableView") as! PromotionTableViewController
        self.splitViewController?.showDetailViewController(viewcontroller, sender: self)
    }
    
    func openAssessmentTableViewController() { //陞遷評分
        let viewcontroller:AssessmentTableViewController = UIStoryboard(name: "Assessment", bundle: nil).instantiateViewController(withIdentifier: "AssessmentTableView") as! AssessmentTableViewController
        self.splitViewController?.showDetailViewController(viewcontroller, sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        var label = ["評分", "複選排序", "序位", "檔案", "單記投票", "陞任", "陞遷評分"]
        
        /*if let ip = getWiFiAddress() {
            label.insert("廣播 \(ip)", at: 0)
        } else {
            label.insert("廣播", at: 0)
        }*/
        
        label.insert("廣播", at: 0) // 目前需求改不顯示 ip
        
        cell?.textLabel?.text = label[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.openRecordViewController()
        }
            
        else if indexPath.row == 1 {
            self.openScoreTableViewController()
        }
            
        else if indexPath.row == 2 {
            self.openVoteTableViewController()
        }
            
        else if indexPath.row == 3 {
            self.openRankTableViewController()
        }
            
        else if indexPath.row == 4 {
            self.openSendFileTableViewController()
        }
        
        else if indexPath.row == 5 {
            self.openCasesVoteTableViewController()
        }
        
        else if indexPath.row == 6 {
            self.openPromotionTableViewController()
        }
        
        else if indexPath.row == 7 {
            self.openAssessmentTableViewController()
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
