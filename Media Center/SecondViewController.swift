//
//  SecondViewController.swift
//  Media Center
//
//  Created by Timothy Barnard on 05/12/2015.
//  Copyright © 2015 Timothy Barnard. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GenericConnctionDelgeate {
    
    
    @IBOutlet weak var showName: UITextField!
    @IBOutlet weak var showSeason: UITextField!
    @IBOutlet weak var showEpisode: UITextField!
    
    var data = [String : String]()
    var showArray = [Show]()
    var connection: Connection?
    
     lazy var apiController : GenericConnection = GenericConnection(delegate: self)
    
    enum Connection {
        case upload
        case download
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        
        self.data["action"] = "tv"
        self.data["tv"] = "bla"
        self.data["season"] = "1"
        self.data["episode"] = "1"
        self.data["avail"] = "1"
        self.data["db"] = "show"
        
        self.connection = Connection.download
        
        ///http://192.168.1.14/?action=tv&tv=%22The%20Flash%22&season=2&episode=8&avail=1&db=show
        self.apiController.delegate = self
        self.apiController.urlRequest(self.data, URL: "?", view: self.view)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didFinishUpload(result: NSData) {
        
        do {
            
            if self.connection == Connection.download {
                
                let json = try NSJSONSerialization.JSONObjectWithData(result, options: .MutableLeaves) as! NSArray
                
                for feeds in json {
                    
                    let newShow = Show()
                    newShow.setID(String(feeds["ID"] as! Int))
                    newShow.setName(feeds["Name"] as! String)
                    newShow.setSeason(String(feeds["Season"] as! Int))
                    newShow.setEpisode(String(feeds["Episode"] as! Int))
                    newShow.setAvail(feeds["Avail"] as! Int)
                    self.showArray.append(newShow)
                    
                }
                
                self.tableView.reloadData()
                
                
            } else {
                
                let json = try NSJSONSerialization.JSONObjectWithData(result, options: .MutableLeaves) as! NSDictionary
                
                let alert = UIAlertController(title: "", message:"", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default) { _ in
                    
                }
                
                if (json["success"] as? Bool == true) {
                    alert.title = "Added Succesfull"
                    self.tableView.reloadData()
                } else  {
                    alert.title = "Error in adding"
                }
                
                alert.addAction(action)
                self.presentViewController(alert, animated: true){}

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


    @IBAction func addShow(sender: AnyObject) {
        
        
        let newShow = Show()
        newShow.setName(self.showName.text!)
        newShow.setSeason(self.showSeason.text!)
        newShow.setEpisode(self.showEpisode.text!)
        newShow.setAvail(1)
        self.showArray.append(newShow)
        
        self.data["action"] = "addTV"
        self.data["tv"] = self.showName.text!
        self.data["season"] = self.showSeason.text!
        self.data["episode"] = self.showEpisode.text!
        self.data["avail"] = "1"
        self.data["db"] = "add"
        
        self.connection = Connection.upload
        
        ///http://192.168.1.14/?action=tv&tv=%22The%20Flash%22&season=2&episode=8&avail=1&db=show
        self.apiController.delegate = self
        self.apiController.urlRequest(self.data, URL: "?", view: self.view)

    }

    
    //MARK: TableView Delgates and DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("showsCell", forIndexPath: indexPath) as! ShowTableViewCell
        
        cell.showName.text = self.showArray[indexPath.row].getName()
        cell.showSeason.text = "S"+self.showArray[indexPath.row].getSeason()
        cell.showEpisode.text = "E"+self.showArray[indexPath.row].getEpisde()
        
        if (self.showArray[indexPath.row].getAvail() == 1) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ShowTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.None
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ShowTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        //let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ShowTableViewCell
        
        return indexPath
        
    }

}

