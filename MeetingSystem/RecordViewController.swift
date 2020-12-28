//
//  RecordViewController.swift
//  MeetingSystem
//
//  Created by 鐘皓廷 on 2017/11/22.
//  Copyright © 2017年 鐘皓廷. All rights reserved.
//

import UIKit
import MJPEGStreamLib

// Get the syncchronize view of meetingSystem server using the broadcast port: 8080
class RecordViewController : UIViewController {

    var streamingController: MJPEGStreamLib!
    var url: URL?
    var timer: Timer?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Go to Record View")
        // Do any additional setup after loading the view, typically from a nib.
        /*streamingController = MJPEGStreamLib(imageView: imageView)
        
        let server = ServerInfo.getSingleton()
        let screenService = server.getScreenServicePort()
        let ip = server.getIp()
        
        url = URL(string: "http://" + ip + ":" + String(screenService))
        print("Get the Record ip: \(url!)")
        streamingController.contentURL = url
        streamingController.play()*/
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(downloadImage(_:)), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.timer != nil {
            self.timer?.fire()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.timer != nil {
            self.timer?.invalidate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(_ timer: Timer) {
        let str = randomString(len: 5)
        let server = ServerInfo.getSingleton()
        let ip = server.getIp()
        let url = URL(string: "http://\(ip)/streaming/image.jpg?\(str)")!
        
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func randomString(len:Int) -> String {
        let charSet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var c = Array(charSet)
        var s:String = ""
        for _ in (1...len) {
            s.append(c[Int(arc4random()) % c.count])
        }
        return s
    }
    
}
