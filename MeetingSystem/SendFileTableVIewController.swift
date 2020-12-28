//
//  SendFileTableVIewController.swift
//  MeetingSystem
//
//  Created by 鐘皓廷 on 2017/12/1.
//  Copyright © 2017年 鐘皓廷. All rights reserved.
//

import UIKit


class SendFileTableVIewController: UITableViewController, cellDelegate{

    let file = FileOperation()

    var docController: UIDocumentInteractionController?

    var fileList: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        fileList = file.list()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("file table count:", fileList.count)
        return fileList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FileTableViewCell
        cell.fileName.text = fileList[indexPath.row]
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            file.deleteFile(fileName: fileList[indexPath.row])
            self.fileList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    func didClickViewButton(cell: UITableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        print(indexPath?.row ?? "")
        let urlString = "\(Variables.fileSavePath)/\(fileList[(indexPath?.row)!])"
        // For open in iBook
        if (indexPath?.row) != nil {
            
            let targetURL = NSURL.fileURL(withPath: urlString)
            docController = UIDocumentInteractionController(url: targetURL)
            docController!.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
        }
        // For open in this app
//            let vc : PresentFileViewController = UIStoryboard(name: "SendFile", bundle: nil).instantiateViewController(withIdentifier: "PresentFile") as! PresentFileViewController
//            let navController = UINavigationController(rootViewController: vc)
//            let urlString = "\(Variables.fileSavePath)/\(fileList[(indexPath?.row)!])"
//            vc.url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
//            self.present(navController, animated: true, completion: nil)

        
    }
}

// Show the pdf or word view controller 
class PresentFileViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var url: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let request = URLRequest(url: url!)
        self.webView.loadRequest(request)
        self.view.addSubview(webView)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


}

