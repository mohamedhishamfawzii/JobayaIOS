//
//  MyTabBar.swift
//  Jobaya
//
//  Created by mohamed hisham on 12/28/18.
//  Copyright © 2018 hisham. All rights reserved.
//

import UIKit

class MyTabBar: UITabBarController {

      var email:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print(email)

        // Do any additional setup after loading the view.
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
