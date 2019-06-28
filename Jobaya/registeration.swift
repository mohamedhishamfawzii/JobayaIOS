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
    
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var backButton: UIButton!
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
     
       
      
        var request = URLRequest(url: URL(string: "https://jobayaback.herokuapp.com/register")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 120 // 120 secs
        let values =  ["username":usernames!,"email":emails!,"password":passwords!,"gender":gender,"age":ages!,"name":names! ]
        print (values)
        request.httpBody = try! JSONSerialization.data(withJSONObject: values, options: [])
        Alamofire.request(request as URLRequestConvertible).responseString {
            response in
            let alert = UIAlertController(title: "Success", message: "You have created your account , go get hired", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            print(response)
        }
      
        
        
     }
    
  

    override func viewDidLoad() {
                super.viewDidLoad()
        signup.layer.cornerRadius=5
        backButton.layer.cornerRadius=5
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
