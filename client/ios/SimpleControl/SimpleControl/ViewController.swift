//
//  ViewController.swift
//  SimpleControl
//
//  Created by Peter Hansen on 2/13/18.
//  Copyright © 2018 Peter Hansen. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    private var labels = [UIButton]()
    private var hist: [String: [Double]] = [:]
    private var order = [String]()
    private var mostRecent = 0
    var rHist: [String: [Double]]?
    var rOrder: [String]?
    var rMostRecent: Int?
    var isR: Bool?
//    @IBOutlet weak var sliderText: UITextField!
//    @IBOutlet weak var slider: UISlider!
    override func viewDidLoad() {
        self.scheduledTimerWithTimeInterval()
        var vals = [Double]()
        for i in 0 ..< 16 {
            let label = UIButton(frame: CGRect(x: 16 + 75*(i%4), y: 100 + 75 * (i/4), width: 50, height: 50))
            label.backgroundColor = UIColor(
                red: 0,
                green: 0,
                blue: 0,
                alpha: 1.0)
            label.addTarget(self, action: #selector(self.loadHistory), for: .touchUpInside)
            label.tag = i
            self.view.addSubview(label)
            labels.append(label)
            vals.append(0)
        }
        
        if self.isR != nil {
            print(1)
            self.hist = self.rHist!
            self.order = self.rOrder!
            self.mostRecent = self.rMostRecent!
        } else {
            self.hist[" "] = vals
            self.order.append(" ")
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let h = self.hist
        let o = self.order
        let mr = self.mostRecent
        let id = sender as! Int
        if let destinationViewController = segue.destination as? HistoryViewController {
            destinationViewController.hist = h
            destinationViewController.order = o
            destinationViewController.mostRecent = mr
            destinationViewController.sensorNumber = id
        }
    }

//    @IBAction func sliderChanged(_ sender: UISlider) {
//        sliderText.text = String(Int(sender.value))
//        let parameters: Parameters = [
//            "data": sender.value,
//        ]
//        
//        Alamofire.request("http://localhost:4000/get", method: .get, parameters: parameters, encoding: URLEncoding()).responseJSON {response in
//            print("Response: \(String(describing: response.result.value))")
//            
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//                
////                for data in utf8Text.components(separatedBy: "&") {
////                    
////                }
//                let val = Double(utf8Text.components(separatedBy: "&")[1].components(separatedBy: "=")[1])!
//                let newval = val*0.0255
//                print("\(newval)")
//                self.label1.backgroundColor = UIColor(
//                    red: CGFloat(newval),
//                    green: 0,
//                    blue: 0,
//                    alpha: 1.0)
//            }
//        }
//    }
//    @IBAction func textChanged(_ sender: UITextField) {
//        if sliderText.text != "" {
//            if Int(sliderText.text!)! > 100 {
//                let alert = UIAlertController(title: "Alert", message: "Selection too high", preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            } else {
//                slider.setValue(Float(sliderText.text!)!, animated: true)
//            }
//            let parameters: Parameters = [
//                "data": slider.value,
//                ]
//            
//            Alamofire.request("http://localhost:4000/get", method: .get, parameters: parameters, encoding: URLEncoding())
//        }
//    }
    
    @IBAction func loadHistory(_ sender: UIButton) {
        self.performSegue(withIdentifier: "histSegue", sender: sender.tag)
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        let _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    func updateCounting(){
        var parameters: Parameters = [:]
        
        if (self.mostRecent > 0) {
            parameters["hash"] = order[self.mostRecent]
        } else {
            parameters["hash"] = ""
        }
        var vals = self.hist[self.order[self.mostRecent]]!
        Alamofire.request("http://localhost:4000/get", method: .get, parameters: parameters, encoding: URLEncoding()).responseJSON {response in
//            print("Response: \(String(describing: response.result.value))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
                
                //                for data in utf8Text.components(separatedBy: "&") {
                //
                //                }
                let data = utf8Text.components(separatedBy: "&")
                
                
                for keyval in 1 ..< (data.count-1) {
                    let key = Int(data[keyval].components(separatedBy: "=")[0])!
                    let val = Double(data[keyval].components(separatedBy: "=")[1])!
                    let newval = val*0.01
                    self.labels[key].backgroundColor = UIColor(
                        red: CGFloat(newval),
                        green: 0,
                        blue: 0,
                        alpha: 1.0)
                    vals[key] = val
                    
                }
                let hash = data[data.count-1]
                self.hist[hash] = vals
                self.mostRecent += 1
                self.order.append(hash)
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

