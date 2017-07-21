//
//  ViewController.swift
//  TipCalc
//
//  Created by Wuming Xie on 7/14/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {
    //@IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    private let tipPercents = [0.15, 0.18, 0.2]
    private let currencyFormatter = NumberFormatter()
    private var theme = Theme.normal
    
    private var billOrigin: CGFloat = 0
    private var resultsOrigin: CGFloat = 0
    private var tipControlOrigin: CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Update formatter currency locale
        currencyFormatter.locale = Locale.current
        currencyFormatter.numberStyle = .currency
    }
    
    override func viewDidLoad() {
        // Store original locations
        billOrigin = billTextField.frame.origin.y
        resultsOrigin = resultsView.frame.origin.x
        tipControlOrigin = tipControl.frame.origin.y
        
        // Load default tip amount
        let defaults = UserDefaults.standard
        tipControl.selectedSegmentIndex = defaults.integer(forKey: Keys.segmentIndexKey)
        
        // Determine if last bill amount should be loaded
        if let lastActive = defaults.object(forKey: Keys.lastActiveKey) as? Date {
            if Date().timeIntervalSince(lastActive) < Constants.inactiveTime {
                billTextField.text = defaults.string(forKey: Keys.billAmountKey)
            }
        }
        
        // Update values
        updateValues()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        theme = ThemeManager.getCurrentTheme()
        updateColors()
        billTextField.becomeFirstResponder()
        
        if billTextField.text == nil || billTextField.text!.isEmpty {
            showInputOnly()
        } else {
            showAll()
        }
        
        print("\(billOrigin), \(resultsOrigin)")
        updateViews(false)
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let defaults = UserDefaults.standard
        defaults.set(billTextField.text, forKey: Keys.billAmountKey)
        defaults.synchronize()
    }
    
    @IBAction func onMainViewTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        updateValues()
        updateViews(true)
    }
    
    private func updateValues() {
        let billTotal = Double(billTextField.text!) ?? 0.0
        let tip = billTotal * tipPercents[tipControl.selectedSegmentIndex]
        
        tipAmountLabel.text = currencyFormatter.string(for: tip)
        totalAmountLabel.text = currencyFormatter.string(for: billTotal + tip)
    }
    
    private func updateColors() {
        mainView.backgroundColor = theme.bgColor
        mainView.tintColor = theme.tintColor
        containerView.backgroundColor = theme.bgColor
        resultsView.backgroundColor = theme.bgColor
        billTextField.backgroundColor = theme.bgColor
        billTextField.keyboardAppearance = theme == .dark ? .dark : .light
        billTextField.tintColor = theme.tintColor
        
        //billLabel.textColor = theme.textColor
        billTextField.textColor = theme.textColor
        tipLabel.textColor = theme.textColor
        tipAmountLabel.textColor = theme.textColor
        totalLabel.textColor = theme.textColor
        totalAmountLabel.textColor = theme.textColor
    }
    
    private func showInputOnly() {
        billTextField.frame.origin.y = containerView.frame.origin.y
        resultsView.frame.origin.x -= 2000
        tipControl.frame.origin.y += 2000
    }
    
    private func showAll() {
        billTextField.frame.origin.y = billOrigin
        resultsView.frame.origin.x = resultsOrigin
        tipControl.frame.origin.y = tipControlOrigin
    }
    
    private func showInputOnly(_ animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: { 
                self.showInputOnly()
            })
        } else {
            showInputOnly()
        }
    }
    
    private func showAll(_ animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.5, animations: { self.showAll()
            })
        } else {
            showAll()
        }
    }
    
    private func updateViews(_ animated: Bool) {
        let billAmount = Double(billTextField.text!) ?? 0.0
        if billAmount == 0.0 {
            showInputOnly(animated)
        } else {
            showAll(animated)
        }
    }
}
