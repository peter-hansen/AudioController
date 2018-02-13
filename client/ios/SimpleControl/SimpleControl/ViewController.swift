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

    @IBOutlet weak var sliderText: UITextField!
    @IBOutlet weak var slider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func sliderChanged(_ sender: UISlider) {
        sliderText.text = String(Int(sender.value))
        let parameters: Parameters = [
            "data": sender.value,
        ]
        
        Alamofire.request("http://localhost:4000/get", method: .get, parameters: parameters, encoding: URLEncoding())
    }
    @IBAction func textChanged(_ sender: UITextField) {
        if sliderText.text != "" {
            if Int(sliderText.text!)! > 100 {
                let alert = UIAlertController(title: "Alert", message: "Selection too high", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                slider.setValue(Float(sliderText.text!)!, animated: true)
            }
            let parameters: Parameters = [
                "data": slider.value,
                ]
            
            Alamofire.request("http://localhost:4000/get", method: .get, parameters: parameters, encoding: URLEncoding())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

