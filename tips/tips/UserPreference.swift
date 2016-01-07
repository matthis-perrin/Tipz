//
//  UserPreference.swift
//  tips
//
//  Created by Matthis Perrin on 1/6/16.
//  Copyright © 2016 matthis-perrin. All rights reserved.
//

import Foundation

class UserPreferences: NSObject {

    // The settings `lastBillAmount` and `lastTipPercent` are considered invalid after `perishTime` seconds
    private let perishTime: Double = 10 * 60

    // Default values for the settings if no value is stored or if the value perished
    private let defaultBillAmount: Double = 0
    private let defaultTipPercent: Double = 0.15
    private let defaultTipPercents: [Double] = [0.1, 0.15, 0.18, 0.20]

    // Define the keys in NSUserDefaults to access the user settings
    private enum defaultKeys {
        static let LAST_BILL_AMOUNT = "lastBillAmount"
        static let LAST_BILL_AMOUNT_DATE = "lastBillAmountDate"
        static let LAST_TIP_PERCENT = "lastTipPercent"
        static let LAST_TIP_PERCENT_DATE = "lastTipPercentDate"
        static let TIP_PERCENTS = "tipPercents"
    }
    private var defaults = NSUserDefaults.standardUserDefaults()


    // Value exposed to the rest of the app to set or get the settings
    // When a value is set from the outside, we sync it in NSUserDefaults.
    // For the settings that can perish, we also store the current date
    var lastBillAmount: Double {
        didSet {
            defaults.setDouble(lastBillAmount, forKey: defaultKeys.LAST_BILL_AMOUNT)
            storeCurrentDate(defaultKeys.LAST_BILL_AMOUNT_DATE)
        }
    }
    var lastTipPercent: Double {
        didSet {
            defaults.setDouble(lastTipPercent, forKey: defaultKeys.LAST_TIP_PERCENT)
            storeCurrentDate(defaultKeys.LAST_TIP_PERCENT_DATE)
        }
    }
    var tipPercents: [Double] {
        didSet {
            defaults.setObject(tipPercents, forKey: defaultKeys.TIP_PERCENTS)
        }
    }

    
    // Store the current date in NSUserDefaults at a specific key
    private func storeCurrentDate(key: String) {
        let now = NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970
        defaults.setDouble(now, forKey: key)
    }

    // Load the data from NSUserDefaults and initialize this object with the data.
    // Use default values when their is no data in NSUserDefaults or if the data is perished
    override init() {
        // lastBillAmount
        let lastBillAmountDate = NSDate(timeIntervalSince1970: defaults.doubleForKey(defaultKeys.LAST_BILL_AMOUNT_DATE))
        if NSDate(timeIntervalSinceNow: -perishTime).timeIntervalSinceNow > lastBillAmountDate.timeIntervalSinceNow {
            lastBillAmount = defaultBillAmount
        } else {
            lastBillAmount = defaults.doubleForKey(defaultKeys.LAST_BILL_AMOUNT)
        }
        // lastTipPercent
        let lastTipPercentDate = NSDate(timeIntervalSince1970: defaults.doubleForKey(defaultKeys.LAST_TIP_PERCENT_DATE))
        if NSDate(timeIntervalSinceNow: -perishTime).timeIntervalSinceNow > lastTipPercentDate.timeIntervalSinceNow {
            lastTipPercent = defaultTipPercent
        } else {
            lastTipPercent = defaults.doubleForKey(defaultKeys.LAST_TIP_PERCENT)
        }
        // tipPercents
        if let tipPercentsFromDefaults = defaults.objectForKey(defaultKeys.TIP_PERCENTS) {
            if let tipPercentsArray = tipPercentsFromDefaults as? [Double] {
                tipPercents = tipPercentsArray
            } else {
                tipPercents = defaultTipPercents
            }
        } else {
            tipPercents = defaultTipPercents
        }
    }

}