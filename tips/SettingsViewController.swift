//
//  SettingsViewController.swift
//  tips
//
//  Created by Matthis Perrin on 1/6/16.
//  Copyright © 2016 matthis-perrin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // The 6 tip percent textfields
    @IBOutlet weak var tipPercentField1: UITextField!
    @IBOutlet weak var tipPercentField2: UITextField!
    @IBOutlet weak var tipPercentField3: UITextField!
    @IBOutlet weak var tipPercentField4: UITextField!
    @IBOutlet weak var tipPercentField5: UITextField!
    @IBOutlet weak var tipPercentField6: UITextField!

    private var tipPercentFields: [UITextField!]!

    override func viewDidLoad() {
        let userPreferences = UserPreferences()
        tipPercentFields = [tipPercentField1, tipPercentField2, tipPercentField3,
                            tipPercentField4, tipPercentField5, tipPercentField6]
        // Populate the tip percent textfields with the user preference
        for (index, tipPercentField) in tipPercentFields.enumerate() {
            if index >= userPreferences.tipPercents.count {
                tipPercentField.text = ""
            } else {
                tipPercentField.text = String(userPreferences.tipPercents[index] * 100)
            }
        }
    }

    // Called everytime something changes in any of the 6 tip percent textfields
    @IBAction func onTipFieldChanged(sender: AnyObject) {
        let userPreferences = UserPreferences()
        var tipPercents:[Double] = []
        for tipPercentField in tipPercentFields {
            if let tipPercentText = tipPercentField.text {
                let tipPercent = (tipPercentText as NSString).doubleValue / 100
                if tipPercent > 0 {
                    tipPercents.append(tipPercent)
                }
            }
        }
        tipPercents = tipPercents.sort() // In case the percents are not in the right order
        userPreferences.tipPercents = tipPercents // Update the preferences
    }

    // Called when the user tap on the view
    @IBAction func onViewTap(sender: AnyObject) {
        view.endEditing(true) // Close any opened keyboard
    }

}