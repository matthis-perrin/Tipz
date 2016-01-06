//
//  UIViewController.swift
//  tips
//
//  Created by Matthis Perrin on 1/6/16.
//  Copyright © 2016 matthis-perrin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // Hidden textfield for the bill amount
    @IBOutlet weak var billAmountField: UITextField!
    // Format and display the content of billAmountField
    @IBOutlet weak var billAmountLabel: UILabel!

    private var currencyFormatter: NSNumberFormatter!

    
    override func viewDidLoad() {
        // Initialise the currency formatter
        currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle

        super.viewDidLoad()

        billAmountField.text = ""
        billAmountLabel.text = ""
        recompute()

        // On load the bill amount textfield will grab the focus and automatically open the keyboard
        billAmountField.becomeFirstResponder()
    }

    private func recompute() {
        // Parse the content of the hidden bill amount textfield and display it
        // using the bill amount label
        if let billAmountFieldText = billAmountField.text {
            let billAmount = (billAmountFieldText as NSString).doubleValue
            if let billAmountFormatted = currencyFormatter.stringFromNumber(billAmount) {
                billAmountLabel.text = billAmountFormatted
            } else {
                billAmountLabel.text = ""
            }
        }
    }

    @IBAction func billAmountFieldEditingChanged(sender: AnyObject) {
        recompute()
    }


}