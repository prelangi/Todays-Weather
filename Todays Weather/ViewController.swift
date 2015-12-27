//
//  ViewController.swift
//  Todays Weather
//
//  Created by Prasanthi Relangi on 12/26/15.
//  Copyright © 2015 prasanthi. All rights reserved.
//

//Image for the app from here: https://www.flickr.com/photos/greenmi/8535026079/

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var cityTextField: UITextField!
    
    @IBAction func getWeather(sender: AnyObject) {
        
        cityTextField.resignFirstResponder()
        var cityLocation = cityTextField.text
        cityLocation = cityLocation?.stringByReplacingOccurrencesOfString(" ", withString: "-")
        
        
        var city = "http://www.weather-forecast.com/locations/"+cityLocation!+"/forecasts/latest"
        
        let url = NSURL(string:city)
        print("city: \(city) URL:\(url)")
        
        
        if url != nil {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                
                var urlError = false
                var weather  = ""
                if(error==nil) {
                    let urlContent = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    var urlContentArray = urlContent?.componentsSeparatedByString("<span class=\"phrase\">")
                    
                    if urlContentArray!.count > 0 {
                        
                        //print("URL Content: \(urlContentArray![1])")
                        var weatherArray = urlContentArray![1].componentsSeparatedByString("</span>")
                        weather = weatherArray[0] as String
                        
                        //Option+shift+8 gives the degree symbol
                        //Use that instead of the &deg; to make the text more pleasing
                        weather = weather.stringByReplacingOccurrencesOfString("&deg;", withString:"°")
                        //print("Current weather conditions: \(weather)")
                    }
                    else {
                        self.showError()
                    }
                    
                }
                else {
                    urlError = true
                }
                
                //Display without waiting
                dispatch_async(dispatch_get_main_queue()) {
                    if urlError == true {
                        //print("URL Error")
                        self.showError()
                    }
                    else {
                        self.weatherDetails.text = weather;
                    }
                    
                }
                
                
            })
            
            task.resume()
        }
        else {
            print("URL is nil")
            self.showError()
        }

    }
    
    @IBOutlet weak var weatherDetails: UILabel!
    
    func showError() {
        weatherDetails.text = "Cannot find weather forecast for city \(cityTextField!.text). Please try again!"
        
        //print("Cannot find weather forecast for city \(cityTextField!.text)")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.cityTextField.delegate = self;
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    //This function will work
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        cityTextField.resignFirstResponder()
        return true
    }

}

