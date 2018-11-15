//
//  ViewController.swift
//  GXUIDownloadButton
//
//  Created by Majid Hatami Aghdam on 11/14/18.
//  Copyright © 2018 Majid Hatami Aghdam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onBtnPressed(_ sender: GXUIDownloadButon) {
        if sender.GXState == .normal {
            sender.GXState = .download
        }else if sender.GXState == .download {
            sender.GXState = .prepareForDownload
        }else if sender.GXState == .prepareForDownload {
            sender.GXState = .downloading
        }else  if(sender.progress < 1){
            sender.GXState = .downloading
            sender.progress += 0.1
        }else{
            sender.GXState = .normal
            sender.progress = 0
        }
        
    }
    
}

