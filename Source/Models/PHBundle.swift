//
//  PHHardware.swift
//  ProductHunt
//
//  Created by Vlado on 3/28/16.
//  Copyright © 2016 ProductHunt. All rights reserved.
//

import Foundation

class PHBundle {

    class func shortVersion() -> String {
        return getValueFromInfoDictionary("CFBundleShortVersionString", subjectType: String()) ?? ""
    }

    class func version() -> String {
        return getValueFromInfoDictionary("CFBundleVersion", subjectType: String()) ?? ""
    }

    // Referenced from https://developer.apple.com/library/mac/technotes/tn1103/_index.html
    class func systemUUID() -> String {
        let dev = IOServiceMatching("IOPlatformExpertDevice")

        let platformExpert: io_service_t = IOServiceGetMatchingService(kIOMasterPortDefault, dev)

        let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformUUIDKey, kCFAllocatorDefault, 0)

        IOObjectRelease(platformExpert)

        let serialNumber: CFTypeRef = serialNumberAsCFString.takeUnretainedValue()

        return serialNumber as? String ?? ""
    }

    class func ipAddress() -> String {
        let address = NSHost.currentHost().addresses.filter{  $0.containsString(".") && ($0 != "127.0.0.1") }
        return address.isEmpty ? "" : address.first!
    }

    private class func getValueFromInfoDictionary<T>(key: String, subjectType: T) -> T? {
        guard let infoDictionary = NSBundle.mainBundle().infoDictionary else {
            return nil
        }

        return infoDictionary[key] as? T
    }
}