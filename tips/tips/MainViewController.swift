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
    // Segmented control where the user choose the tip they want to pay
    @IBOutlet weak var tipControl: UISegmentedControl!

    // 5 views at the bottom displaying different tip adjustments
    @IBOutlet weak var mainTipView: UIView!
    @IBOutlet weak var roundTipDownView: UIView!
    @IBOutlet weak var roundTipUpView: UIView!
    @IBOutlet weak var roundTotalDownView: UIView!
    @IBOutlet weak var roundTotalUpView: UIView!
    private var allTipViews: [UIView!]!

    // Percent labels of the 5 tip views
    @IBOutlet weak var mainTipPercentLabel: UILabel!
    @IBOutlet weak var roundTipDownPercentLabel: UILabel!
    @IBOutlet weak var roundTipUpPercentLabel: UILabel!
    @IBOutlet weak var roundTotalDownPercentLabel: UILabel!
    @IBOutlet weak var roundTotalUpPercentLabel: UILabel!

    // Tip labels of the 5 tip views
    @IBOutlet weak var mainTipTipLabel: UILabel!
    @IBOutlet weak var roundTipDownTipLabel: UILabel!
    @IBOutlet weak var roundTipUpTipLabel: UILabel!
    @IBOutlet weak var roundTotalDownTipLabel: UILabel!
    @IBOutlet weak var roundTotalUpTipLabel: UILabel!

    // Total labels of the 5 tip views
    @IBOutlet weak var mainTipTotalLabel: UILabel!
    @IBOutlet weak var roundTipDownTotalLabel: UILabel!
    @IBOutlet weak var roundTipUpTotalLabel: UILabel!
    @IBOutlet weak var roundTotalDownTotalLabel: UILabel!
    @IBOutlet weak var roundTotalUpTotalLabel: UILabel!

    private var currencyFormatter: NSNumberFormatter!
    private var userPreferences = UserPreferences()

    
    override func viewDidLoad() {

        super.viewDidLoad()

        // Initialise the currency formatter
        currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle

        allTipViews = [mainTipView, roundTipDownView, roundTipUpView, roundTotalDownView, roundTotalUpView]
        for tipView in allTipViews {
            tipView.layer.shadowOffset = CGSizeMake(0, 1)
            tipView.layer.shadowRadius = 1
            tipView.layer.shadowOpacity = 0.85
        }

        // Set the last bill amount from the preferences
        billAmountField.text = String(userPreferences.lastBillAmount)
        billAmountLabel.text = "" // Will be computed later

        // Set the tip segmented control data form the preferences
        let tipPercents = userPreferences.tipPercents // List of available tip percents
        var currentTipIndex = 0 // By default select the first one
        for (index, tipPercent) in tipPercents.enumerate() {
            // If the last tip percent is in the list, we use that
            if tipPercent == userPreferences.lastTipPercent {
                currentTipIndex = index
            }
        }
        updateTipValues(tipPercents, selectedIndex: currentTipIndex)

        // Recompute the UI
        recompute()

        // On load the bill amount textfield will grab the focus and automatically open the keyboard
        billAmountField.becomeFirstResponder()
    }

    // Update the tip segmented controll with the values in params
    internal func updateTipValues(tipValues: [Double], selectedIndex: Int) {
        tipControl.removeAllSegments()
        for (segmentIndex, tipValue) in tipValues.enumerate() {
            tipControl.insertSegmentWithTitle(String(format: "%.0f%%", tipValue * 100), atIndex: segmentIndex, animated: false)
        }
        tipControl.selectedSegmentIndex = selectedIndex
    }

    // Recompute the UI
    private func recompute() {
        // Parse the content of the hidden bill amount textfield
        if let billAmountFieldText = billAmountField.text {
            let billAmount = (billAmountFieldText as NSString).doubleValue
            userPreferences.lastBillAmount = billAmount

            // Update the bill amount label with the formatted value
            if let billAmountFormatted = currencyFormatter.stringFromNumber(billAmount) {
                billAmountLabel.text = billAmountFormatted
            } else {
                billAmountLabel.text = ""
            }

            if billAmount > 0 {
                // Show the tip views
                for tipView in allTipViews {
                    tipView.hidden = false
                }
                // Get the selected tip percentage
                if let tipPercentText = tipControl.titleForSegmentAtIndex(tipControl.selectedSegmentIndex) {
                    // Calculate the different version of the tip percentage
                    let tipPercent = (tipPercentText.substringToIndex(tipPercentText.endIndex.predecessor()) as NSString).doubleValue / 100
                    userPreferences.lastTipPercent = tipPercent
                    let tipPercent_TipRoundDown = floor(tipPercent * billAmount) / billAmount
                    let tipPercent_TipRoundUp = ceil(tipPercent * billAmount) / billAmount
                    let tipPercent_TotalRoundDown = (floor(billAmount + tipPercent * billAmount) / billAmount) - 1
                    let tipPercent_TotalRoundUp = (ceil(billAmount + tipPercent * billAmount) / billAmount) - 1

                    // Update the tip view labels
                    mainTipPercentLabel.text = String(format: "%.2f%%", tipPercent * 100)
                    roundTipDownPercentLabel.text = String(format: "%.2f%%", tipPercent_TipRoundDown * 100)
                    roundTipUpPercentLabel.text = String(format: "%.2f%%", tipPercent_TipRoundUp * 100)
                    roundTotalDownPercentLabel.text = String(format: "%.2f%%", tipPercent_TotalRoundDown * 100)
                    roundTotalUpPercentLabel.text = String(format: "%.2f%%", tipPercent_TotalRoundUp * 100)

                    mainTipTipLabel.text = currencyFormatter.stringFromNumber(tipPercent * billAmount)
                    roundTipDownTipLabel.text = currencyFormatter.stringFromNumber(tipPercent_TipRoundDown * billAmount)
                    roundTipUpTipLabel.text = currencyFormatter.stringFromNumber(tipPercent_TipRoundUp * billAmount)
                    roundTotalDownTipLabel.text = currencyFormatter.stringFromNumber(tipPercent_TotalRoundDown * billAmount)
                    roundTotalUpTipLabel.text = currencyFormatter.stringFromNumber(tipPercent_TotalRoundUp * billAmount)

                    mainTipTotalLabel.text = currencyFormatter.stringFromNumber(billAmount + tipPercent * billAmount)
                    roundTipDownTotalLabel.text = currencyFormatter.stringFromNumber(billAmount + tipPercent_TipRoundDown * billAmount)
                    roundTipUpTotalLabel.text = currencyFormatter.stringFromNumber(billAmount + tipPercent_TipRoundUp * billAmount)
                    roundTotalDownTotalLabel.text = currencyFormatter.stringFromNumber(billAmount + tipPercent_TotalRoundDown * billAmount)
                    roundTotalUpTotalLabel.text = currencyFormatter.stringFromNumber(billAmount + tipPercent_TotalRoundUp * billAmount)
                }
            } else {
                // Hide the tip views
                for tipView in allTipViews {
                    tipView.hidden = true
                }
            }
        }
    }

    @IBAction func billAmountFieldEditingChanged(sender: AnyObject) {
        recompute()
    }
    @IBAction func tipControlValueChanged(sender: AnyObject) {
        recompute()
    }


    // Called when the user tap on the view
    @IBAction func onViewTap(sender: AnyObject) {
        view.endEditing(true) // Close any opened keyboard
    }

}