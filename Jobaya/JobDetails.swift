//
//  JobDetails.swift
//  Jobaya
//
//  Created by mohamed hisham on 12/28/18.
//  Copyright © 2018 hisham. All rights reserved.
//

import UIKit

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
