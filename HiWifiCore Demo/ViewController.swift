//
//  ViewController.swift
//  HiWifiCore Demo
//
//  Created by Big Boss on 25.01.22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        statusLabel.text = " "
        NotificationCenter.default.addObserver(self, selector: #selector(updateHiWifiCoreStatus), name: Notification.Name("UpdateHiWifiCoreStatus"), object: nil)
    }

    @objc func updateHiWifiCoreStatus(notification: NSNotification) {
        print("updateHiWifiCoreStatus:\(notification)")
        if let userInfo = notification.userInfo, let status = userInfo["Status"] as? String {
            DispatchQueue.main.async {
                self.statusLabel.text = status
            }
        }
    }
}

