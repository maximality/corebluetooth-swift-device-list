//
//  BTDataModel.swift
//  bluetooth-test
//
//  Created by Максим Мамедов on 02.05.16.
//  Copyright © 2016 Максим Мамедов. All rights reserved.
//

import Foundation
import CoreBluetooth
class BTDevice { //девайс
    var advertisementData: String
    var RSSI: NSNumber?
    var services: String?
    var characteristics: String?
    init (advertData: String, rssi: NSNumber) {
        advertisementData = advertData
        RSSI = rssi
    }
}

let kNewDeviceDiscovered:String = "newDeviceDiscovered"
class BTDataModel: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate { //модель данных, класс для работы с CoreBluetooth
    
    var btManager: CBCentralManager? //manager
    var btDevices = [BTDevice]()
    var btAvailable: Bool?
    
    static let sharedInstance = BTDataModel() //singleton
    
    override init () {
        super.init()
        btManager = CBCentralManager.init(delegate: self, queue: nil) //инициализация менеджера
    }
    func scanForAvailableDevices () {
        btDevices.removeAll()
        btManager?.scanForPeripheralsWithServices([CBUUID.init(string: "180A"), CBUUID.init(string: "1800"), CBUUID.init(string: "1801")], options: nil)
    }
    
    // MARK: CBCentralManagerDelegate functions
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print(advertisementData);
        //получаем параметры и формируем экземпляр класса BTDevice
        let manufacturer = String(advertisementData[CBAdvertisementDataManufacturerDataKey])
        let name = String(advertisementData[CBAdvertisementDataLocalNameKey])
        let btDeivce = BTDevice(advertData: manufacturer + " " + name, rssi: RSSI)
        btDevices.append(btDeivce)
        NSNotificationCenter.defaultCenter().postNotificationName(kNewDeviceDiscovered, object: nil)
    }
    func centralManagerDidUpdateState(central: CBCentralManager) { //обновление состояния менеджера
        print(central.state)
        switch central.state {
        case .PoweredOn:
            scanForAvailableDevices()
            btAvailable = true
            break
        default:
            btAvailable = false
            break
        }
    }
}
