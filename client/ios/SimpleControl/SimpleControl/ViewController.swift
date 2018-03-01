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
    private var labels = [UILabel]()
//    @IBOutlet weak var sliderText: UITextField!
//    @IBOutlet weak var slider: UISlider!
    override func viewDidLoad() {
        self.scheduledTimerWithTimeInterval()
        for i in 0 ..< 16 {
            let label = UILabel(frame: CGRect(x: 16 + 75*(i%4), y: 100 + 75 * (i/4), width: 50, height: 50))
            label.backgroundColor = UIColor(
                red: 0,
                green: 0,
                blue: 0,
                alpha: 1.0)
            self.view.addSubview(label)
            labels.append(label);
        }
        // Do any additional setup after loading the view, typically from a nib.
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
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        let _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    func updateCounting(){
        let parameters: Parameters = [
            "data": 50,
            ]
        
        Alamofire.request("http://localhost:4000/get", method: .get, parameters: parameters, encoding: URLEncoding()).responseJSON {response in
            print("Response: \(String(describing: response.result.value))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                
                //                for data in utf8Text.components(separatedBy: "&") {
                //
                //                }
                let data = utf8Text.components(separatedBy: "&")
                
                for keyval in 1 ..< (data.count-1) {
                    let key = Int(data[keyval].components(separatedBy: "=")[0])!
                    let val = Double(data[keyval].components(separatedBy: "=")[1])!
                    let newval = val*0.01
                    print("\(newval)")
                    self.labels[key].backgroundColor = UIColor(
                        red: CGFloat(newval),
                        green: 0,
                        blue: 0,
                        alpha: 1.0)
                    
                    
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

