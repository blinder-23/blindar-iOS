//
//  File.swift
//  Blindar
//
//  Created by Suji Lee on 7/31/24.
//

import Foundation
import SwiftUI

struct DeviceInfo {
    var deviceName: String
    var osVersion: String
    var appVersion: String
}

func getDeviceInfo() -> DeviceInfo {
    let deviceName = UIDevice.current.name
    let osVersion = UIDevice.current.systemVersion
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    let deviceInfo: DeviceInfo = DeviceInfo(deviceName: deviceName, osVersion: osVersion, appVersion: appVersion)
    
    return deviceInfo
}
