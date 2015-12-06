//
//  FirstViewController.swift
//  Media Center
//
//  Created by Timothy Barnard on 05/12/2015.
//  Copyright © 2015 Timothy Barnard. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, GenericConnctionDelgeate {

    
    var data = [String : String]()
    
    @IBOutlet weak var movieTextField: UITextField!
    
    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var yearLabel: UILabel!
    
    
    lazy var apiController : GenericConnection = GenericConnection(delegate: self)

    var years = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.populatePickerView()
        yearPickerView.dataSource = self
        yearPickerView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchButton(sender: AnyObject) {
        
        if self.movieTextField.text!.isEmpty && self.yearLabel.text != "Year" {
            
        }
        
        self.data["action"] = "movie"
        self.data["movieName"] = self.movieTextField.text
        self.data["year"] = self.yearLabel.text
        
        ///http://192.168.1.14/?action=tv&tv=%22The%20Flash%22&season=2&episode=8&avail=1&db=show
        self.apiController.delegate = self
        self.apiController.urlRequest(self.data, URL: "?", view: self.view)
        
    }

    //GenericConnectionDelegate
    
    func didFinishUpload(result: NSData) {
     
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(result, options: .MutableLeaves) as! NSDictionary
            
            if (json["success"] as? Bool == true) {
                
                if let auth = json["type"] as? String {
                    if auth == "1" {
                        
                    } else if auth == "0" {
                        
                    }
                }
               
                
            } else  {
               
            }
            
        }  catch let parseError {
            print(parseError)
            
            
        }


    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.DismissKeyboard()
    }
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    // UIPickerController Methods
    
    //MARK: - Delegates and data sources
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.years.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //MARK: - Delegate
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.yearLabel.textColor = UIColor.blueColor()
        self.yearLabel.text = self.years[row]
        
    }
   
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return years[row]
    }
    
    
    func populatePickerView() {
        
        for(var i = 2016; i > 1940; i-- ) {
            let string = String(i)
             years.append(string)
        }
    }
}
