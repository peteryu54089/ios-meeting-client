//
//  SendFileViewController.swift
//  MeetingSystem
//
//  Created by 鐘皓廷 on 2017/11/22.
//  Copyright © 2017年 鐘皓廷. All rights reserved.
//

import UIKit

// ******** you don't need to watch this page, it's for testing
class SendFileViewController : UIViewController {
    var docController: UIDocumentInteractionController?
    
    @IBOutlet weak var button1: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
//    @IBAction func press(_ sender: Any) {
//        print("button pressed")
//
//
//        if let path = Bundle.main.path(forResource: "12-December", ofType: "pdf") {
//            let targetURL = NSURL.fileURL(withPath: path)
//
//            docController = UIDocumentInteractionController(url: targetURL)
//
//            //let url = NSURL(string:"itms-books:")
//
//            //if UIApplication.shared.canOpenURL(url! as URL) {
//
//                docController!.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
//            //}
//        }
//    }
    func buttonPressed(sender: UIButton){
       
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


    
    @IBAction func button(_ sender: Any) {
                //print(documentDirectorPath)

       // doc = UIDocumentInteractionController(url: URL(string: documentDirectorPath)!)

       // if UIApplication.shared.canOpenURL(URL(string: documentDirectorPath)!) {
         //   doc?.presentOpenInMenu(from: CGRect(origin: CGPoint(x: 0, y: 0), size: UIScreen.main.bounds.size), in: self.view, animated: true)
        //}

        let file = FileService(webPath: "https://www.adobe.com/content/dam/acom/en/devnet/acrobat/pdfs/pdf_open_parameters.pdf", filePath: "檔案su3cl3a8.pdf")
        file.downloadFile(completion: { () in
        })

    }

}


