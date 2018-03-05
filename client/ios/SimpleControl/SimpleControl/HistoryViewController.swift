//
//  HistoryViewController.swift
//  SimpleControl
//
//  Created by Peter Hansen on 3/5/18.
//  Copyright © 2018 Peter Hansen. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class HistoryViewController: UIViewController {
    var hist: [String: [Double]]?
    var order: [String]?
    var mostRecent: Int?
    var sensorNumber: Int?
    var labels = [UIButton]()
    
    @IBOutlet weak var display: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var x = true
        for i in 0 ..< 96 {
            if (self.mostRecent! - i >= 0) {
                let hash = self.order![self.mostRecent! - i]
                let vals = self.hist![hash]
                let label = UIButton(frame: CGRect(x: 8 + 50*(i%8), y: 100 + 50 * (i/8), width: 50, height: 50))
                label.backgroundColor = UIColor(
                    red: CGFloat(vals![self.sensorNumber!]/100),
                    green: 0,
                    blue: 0,
                    alpha: 1.0)
                label.addTarget(self, action: #selector(self.displayVal), for: .touchUpInside)
                label.tag = Int(vals![self.sensorNumber!])
                self.view.addSubview(label)
                labels.append(label);
                
                if(x) {
                    display.text = String(Int(vals![self.sensorNumber!]))
                    x = false
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let h = self.hist
        let o = self.order
        let mr = self.mostRecent
        if let destinationViewController = segue.destination as? ViewController {
            destinationViewController.rHist = h
            destinationViewController.rOrder = o
            destinationViewController.rMostRecent = mr
            destinationViewController.isR = true
        }
    }
    
    @IBAction func displayVal(_ sender: UIButton) {
        display.text = String(sender.tag)
    }
    
}
