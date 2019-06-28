//
//  ViewController.swift
//  Jobaya
//
//  Created by mohamed hisham on 12/12/18.
//  Copyright © 2018 hisham. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!

    @IBOutlet weak var loginButton: UIButton!
    
    func login () {
        
        var request = URLRequest(url: URL(string: "https://jobayaback.herokuapp.com/login")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 120 // 120 secs
        let values = ["email": email.text ,"password":password.text ]
        print (values)
        request.httpBody = try! JSONSerialization.data(withJSONObject: values, options: [])
        Alamofire.request(request as URLRequestConvertible).responseJSON {
            response in
            // do whatever you want here
            let json = JSON(response.data!)
            print(json["found"])
            if(json["found"].boolValue){
                self.performSegue(withIdentifier: "logged", sender: self)
                let defaults = UserDefaults.standard
                defaults.set(self.email.text, forKey: "email")
              defaults.set(true,forKey: "logged")
            }else{
                
                
                let alert = UIAlertController(title: "Can't login", message: "Wrong email or password , please try again", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            }
            print(response)
        }
    }
    @IBAction func loginPressed(_ sender: Any) {
        print("entered")
       
        login()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         let defaults = UserDefaults.standard
        
        print(defaults.bool(forKey:"logged"))
       
        loginButton.layer.cornerRadius=5
        register.layer.cornerRadius=5
        loginButton.setTitleColor(UIColor(red:  0/255, green: 122/255, blue: 255/255, alpha:1.0), for: .highlighted)
        password.delegate=self
        email.delegate=self
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKey))
        view.addGestureRecognizer(tap)
        
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    @objc func dismissKey(){
        
        
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        email.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    override func prepare (for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "logged") {
             let svc = segue.destination as! MyTabBar
            svc.email = email.text!
     
        }
    }


}

