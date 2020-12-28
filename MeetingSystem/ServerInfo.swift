//
//  ServerInfo.swift
//  MeetingSystem
//
//  Created by 鐘皓廷 on 2017/11/27.
//  Copyright © 2017年 鐘皓廷. All rights reserved.
//

import Foundation

// Server information object 
class ServerInfo {
    
    var name: String? = nil
    var ip: String
    var broadcastPort: Int
    var servicePort: Int? = nil
    var screenServicePort: Int? = nil
    private static var mInstance: ServerInfo?
    
    static func getSingleton(name:String, ip:String, broadcastPort:Int, servicePort:Int, screenServicePort:Int) -> ServerInfo {
        if mInstance == nil {
            mInstance = ServerInfo(name: name, ip: ip, broadcastPort: broadcastPort, servicePort: servicePort, screenServicePort: screenServicePort)
        }
        
        return mInstance!
    }
    
    static func getSingleton() -> ServerInfo {
        if let mInstance = mInstance {
            return mInstance
        }
        
        else {
            return ServerInfo(name: "None", ip: "0", broadcastPort: 0, servicePort: 0, screenServicePort: 0)
        }
    }
    
    private init(name:String, ip:String, broadcastPort:Int, servicePort:Int, screenServicePort:Int) {
        self.name = name
        self.ip = ip
        self.broadcastPort = broadcastPort
        self.servicePort = servicePort
        self.screenServicePort = screenServicePort
    }
    
    func getName() -> String{
        return name!
    }
    
    func getIp() -> String{
        return ip
    }
    
    func getBroadcastPort() -> Int {
        return broadcastPort
    }
    
    func getServicePort() -> Int {
        return servicePort!
    }
    
    func getScreenServicePort() -> Int {
        return screenServicePort!
    }

    
}
