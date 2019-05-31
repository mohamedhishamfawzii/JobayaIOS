//
//  JobDetails.swift
//  Jobaya
//
//  Created by mohamed hisham on 12/28/18.
//  Copyright © 2018 hisham. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

class JobDetails: UIViewController {
  
  
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var exp: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var skills: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var header: UILabel!
    var job :NSDictionary = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.header.text = (job["title"] as? String?)!
          self.des.text = (job["description"] as? String?)!
        self.duration.text = (job["duration"] as? String?)!
              self.gender.text = (job["gender"] as? String?)!
             self.age.text = (job["age"] as? String?)!
             self.skills.text = (job["skills"] as? String?)!
             self.language.text = (job["language"] as? String?)!
             self.exp.text = (job["experience"] as? String?)!
  self.mail.text = (job["employer_email"] as? String?)!
        // Do any additional setup after loading the view.
    }
    
    @IBAction func apply(_ sender: Any) {
        print (UserDefaults.standard.string(forKey: "email")! )
                print(job["_id"] ?? "notfound")
        
        var request = URLRequest(url: URL(string: "https://jobayaback.herokuapp.com/apply")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 120 // 120 secs
        let values =  ["email":UserDefaults.standard.string(forKey: "email")!,"job_ID":job["_id"]]
        print (values)
        request.httpBody = try! JSONSerialization.data(withJSONObject: values, options: [])
        Alamofire.request(request as URLRequestConvertible).responseString {
            response in
            // do whatever you want here
            let json = JSON(response.data!)
            print(json["found"])
            if(!(json["found"].boolValue)){
                
                var request = URLRequest(url: URL(string: "https://jobayaback.herokuapp.com/applications")!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.timeoutInterval = 120 // 120 secs
                let values =  ["email":UserDefaults.standard.string(forKey: "email")!,"job_ID":self.job["_id"]]
                print (values)
                request.httpBody = try! JSONSerialization.data(withJSONObject: values, options: [])
                Alamofire.request(request as URLRequestConvertible).responseString {
                    response in
                    print(response)
                    let alert = UIAlertController(title: "Success", message: "You have applied to this Job successfuly , wait for the employer to contact you", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
         
                    
                    
                }
                
               
            }else{
                
                
                let alert = UIAlertController(title: "Can't apply", message: "you have already applied to this job", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
