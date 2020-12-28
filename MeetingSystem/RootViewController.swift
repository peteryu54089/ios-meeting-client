//
//  RootViewController.swift
//  MeetingSystem
//
//  Created by 鐘皓廷 on 2017/11/22.
//  Copyright © 2017年 鐘皓廷. All rights reserved.
//

import UIKit
import SwiftSocket

class RootViewController: UIViewController {

    let s = ServerFinder()
    var viewDidAppearHasBeenDisplay: Bool = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("RootView")
        waitUntilGotServerInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if(!viewDidAppearHasBeenDisplay) {
            viewDidAppearHasBeenDisplay = true
            let serverAlert = UIAlertController(title: "等待連線中", message:"\n\n\n", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: serverAlert.view.bounds)
            loadingIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            loadingIndicator.color = UIColor.black
            loadingIndicator.startAnimating()
            serverAlert.view.addSubview(loadingIndicator)
            self.present(serverAlert, animated: true, completion: nil)
        }
    }

    func waitUntilGotServerInfo() {
        DispatchQueue.main.asyncAfter(deadline:.now() + 3, execute: {
            if(self.s.isConnected()) {
                self.dismiss(animated: true, completion: nil)
                print("Connected to Server!!")
                let s = TCPStream.getSingleton()
                s.tcpConnectToServer()
                self.openRecordViewController()
            } else {
                print("Can not find Server")
                self.waitUntilGotServerInfo()
            }
        })
    }

    func openRecordViewController() { //廣播
        let viewcontroller:RecordViewController = UIStoryboard(name: "Record", bundle: nil).instantiateViewController(withIdentifier: "Record") as! RecordViewController
        self.splitViewController?.showDetailViewController(viewcontroller, sender: self)
    }
}

