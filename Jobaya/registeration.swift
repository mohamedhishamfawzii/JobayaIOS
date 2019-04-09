//
//  registeration.swift
//  Jobaya
//
//  Created by mohamed hisham on 3/2/19.
//  Copyright © 2019 hisham. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON
class RegViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var gender : String = "male"
    @IBAction func genderChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            gender = "male"
        case 1:
            gender = "female"
        default:
            gender = "male"
        }
    }
    
    
   
    @IBAction func register(_ sender: Any) {
    print(username.text!,password.text!,email.text!,ageLabel.text!,gender)
        let usernames = username.text
         let names = name.text
        let emails = email.text
        let ages = ageLabel.text
        let passwords = password.text
     
       
        let json = ["job":usernames!,"email":emails!,"password":passwords!,"gender":gender,"age":ages!,"name":names! ]
      
        var request = URLRequest(url: URL(string: "https://reqres.in/api/users")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 120 // 120 secs
       
        print (json)
        request.httpBody = try! JSONSerialization.data(withJSONObject: json, options: [])
        Alamofire.request(request as URLRequestConvertible).responseString {
            response in
            // do whatever you want here
           
            print(response) }
        
        
     }
    
  

    override func viewDidLoad() {
                super.viewDidLoad()
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKey))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKey(){
        
        
        view.endEditing(true)
    }

    @IBAction func stepperClicked(_ sender: UIStepper) {
       ageLabel.text = Int(sender.value).description
    }
}
