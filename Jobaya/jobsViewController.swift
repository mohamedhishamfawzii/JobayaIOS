//
//  jobsViewController.swift
//  Jobaya
//
//  Created by mohamed hisham on 12/14/18.
//  Copyright © 2018 hisham. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class jobsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var jobsTable: UITableView!
    var jobs : [NSDictionary] = []
   
    var selectedJob: NSDictionary = [:]
    
   
    func getJobs(){
        
        Alamofire.request("https://jobayaback.herokuapp.com/jobs/all", method: .get, parameters: nil, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                self.jobs =  (response.result.value! as? [NSDictionary])!
                let  name = self.jobs[2]
                print(name["title"] as! String)
              self.jobsTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    private func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) {
      print(indexPath)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let row = indexPath.row
               selectedJob = jobs[row]
        self.performSegue(withIdentifier: "select", sender: self)


    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell = UITableViewCell(style: UITableViewCellStyle.subtitle,
                               reuseIdentifier:"Cell")
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha:1.0)
        cell.selectedBackgroundView = backgroundView
        let    job = jobs[indexPath.row]
        let title = job["title"] as? String?
        let description = job["description"] as? String?
        cell.textLabel?.text = "\n"+title!! 
        cell.textLabel?.numberOfLines = 4
        cell.detailTextLabel?.text = description!!  + "\n"
        cell.detailTextLabel?.numberOfLines=10;
        cell.detailTextLabel?.font = UIFont(name:"Hiragino Sans", size:15)
        cell.textLabel?.font = UIFont(name:"Avenir Next Medium", size: 20)
        cell.textLabel?.highlightedTextColor=UIColor.white
        cell.textLabel?.layoutMargins = UIEdgeInsets(top: 0, left: 0,bottom: 20, right: 0)
        cell.detailTextLabel?.highlightedTextColor=UIColor.white
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     print(UserDefaults.standard.string(forKey: "email")!)
        getJobs()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "select") {
            let svc = segue.destination as! JobDetails
            svc.job = self.selectedJob
            
        }
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
