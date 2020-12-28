//
//  ServerFinder.swift
//  MeetingSystem
//
//  Created by 鐘皓廷 on 2017/11/27.
//  Copyright © 2017年 鐘皓廷. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

// Use socket port = 3389 to find the meetingSystem server
class ServerFinder: NSObject, GCDAsyncUdpSocketDelegate, GCDAsyncSocketDelegate {
    
    var socket: GCDAsyncUdpSocket?
    let port: UInt16 = 3389
    var socketInfo: ServerInfo?
    var isConnect: Bool = false
    var socket2 = GCDAsyncSocket()
    
    override init() {
        super.init()
        print("Server Finder")
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        onReceive()
    }
    
    func onReceive() {
        DispatchQueue.main.async {
            do {
                try self.socket?.bind(toPort: self.port)
                try self.socket?.enableBroadcast(true)
                try self.socket?.beginReceiving()
            } catch _ as NSError {
                print("Issue with setting up listener")
            }
        }
    }
    
    // Check Whethcer connect to server
    func isConnected() -> Bool {
        return isConnect
    }
    
    // When receive the server data, create a serverInfo object
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        
        do {
            let str = try JSONSerialization.jsonObject(with: data) as! [String: Any] // [key, value]
           // print("Get server info\(str)")
            let ip = str["Ip"] as! String
            let name = str["Name"] as! String
            let broadcastPort = str["BroadcastPort"] as! Int
            let servicePort = str["ServicePort"] as! Int
            let screenServicePort = str["ScreenServicePort"] as! Int
            socketInfo = ServerInfo.getSingleton(name: name, ip: ip, broadcastPort: broadcastPort, servicePort: servicePort, screenServicePort: screenServicePort)
        } catch {
            print("Can not Update server info")
        }
        isConnect = true
    }
}
