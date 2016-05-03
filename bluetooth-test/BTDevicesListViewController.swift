//
//  BTDevicesListViewController
//  bluetooth-test
//
//  Created by Максим Мамедов on 02.05.16.
//  Copyright © 2016 Максим Мамедов. All rights reserved.
//

import UIKit

class BTDevicesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var btDataModel = BTDataModel.sharedInstance;
    var updateTimer: NSTimer?
    var devices = [BTDevice]()
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BTDevicesListViewController.receivedNewBluetoothDevice), name: kNewDeviceDiscovered, object: nil)
    }

    @IBAction func refreshButtonTap(sender: AnyObject) { //нажатие на кнопку "Обновить"
        if btDataModel.btAvailable == true {
            btDataModel.scanForAvailableDevices()
            refreshButton.setTitle("Обновление...", forState: UIControlState.Normal)
            refreshButton.enabled = false
            updateTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(BTDevicesListViewController.timerFire), userInfo: nil, repeats: true);
        }
        
    }
    
    //MARK : NotificationsHandler
    func receivedNewBluetoothDevice () { //обработка оповещения о получении информации и новом устройстве
        devices = btDataModel.btDevices
        tableView.reloadData()
    }
    func timerFire () {
        refreshButton.setTitle("Обновить", forState: UIControlState.Normal)
        refreshButton.enabled = true
    }
    
    //MARK : TableView DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        let device = devices[indexPath.row]
        cell.textLabel?.text = device.advertisementData
        cell.detailTextLabel?.text = "RSSI: " + String(device.RSSI)
        return cell
    }
}

