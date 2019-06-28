//
//  MatchesViewController.swift
//  Jobaya
//
//  Created by mohamed hisham on 6/28/19.
//  Copyright © 2019 hisham. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MatchesViewController: UIViewController {
   
    var jobs : JSON = []
    var appliedjobs : [NSDictionary] = []
    var resume :NSDictionary=[:]
  var selectedJob: NSDictionary = [:]
    var matches = true
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getResume()
        getappliedjobs()
        tableView.delegate=self
        tableView.dataSource=self
        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewDidAppear(_ animated: Bool) {
        getResume()
        getappliedjobs()
    }
    
    func getMatches()
    {
        var request = URLRequest(url: URL(string: "https://jobayaback.herokuapp.com/matching")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 120 // 120 secs
        let values = ["education": resume["education"] ,"gender":resume["gender"]]
        print (values)
        request.httpBody = try! JSONSerialization.data(withJSONObject: values, options: [])
        Alamofire.request(request as URLRequestConvertible).responseJSON {
            response in
            // do whatever you want here
            let json = JSON(response.data!)
   
            self.jobs = json["result"]
            print(self.jobs)
            self.tableView.reloadData()
            for job in self.jobs{
                print(job.1["title"])
            }
            
        }
        
    }
    
    func getappliedjobs(){
          let email = UserDefaults.standard.string(forKey: "email")
        Alamofire.request("https://jobayaback.herokuapp.com/applications/\(email!)", method: .get, parameters: nil, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
               // print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                self.appliedjobs =  (response.result.value! as? [NSDictionary])!
                self.tableView.reloadData()
               // print(self.appliedjobs[0]["Job"])
        }

        
    }
    func getResume()
    {
        let email = UserDefaults.standard.string(forKey: "email")
        Alamofire.request("https://jobayaback.herokuapp.com/resume/email/\(email!)", method: .get, parameters: nil, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                let  responseArray = response.result.value as! NSArray
                if (responseArray.count >= 1){
                    self.resume=responseArray[0] as! NSDictionary
                    print("resume" , (self.resume))
                    self.getMatches()
                }
        }
        
    }
    
    @IBAction func genderChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            matches=true
        case 1:
            matches=false
            
        default:
            matches=true
        }
        self.tableView.reloadData()
          getappliedjobs()
        print(matches)
    }



}

extension MatchesViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        if (matches){return self.jobs.count}
        else{
            return self.appliedjobs.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(matches){
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let row = indexPath.row
            selectedJob = jobs[row].dictionaryObject as! NSDictionary
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objSecond = storyboard.instantiateViewController(withIdentifier: "detailsView") as! JobDetails
        objSecond.job = selectedJob
            navigationController?.pushViewController(objSecond, animated: true)}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(matches){
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle,
                                   reuseIdentifier:"Cell")
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha:1.0)
            cell.selectedBackgroundView = backgroundView
            let    job = self.jobs[indexPath.row].dictionaryObject
            let title = job!["title"] as? String?
            let description = job!["description"] as? String?
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
        else{
    
             print("here")
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle,
                                   reuseIdentifier:"Cell")
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha:1.0)
            cell.selectedBackgroundView = backgroundView
            let    job = self.appliedjobs[indexPath.row]["Job"]
          let   jobaya=job as! NSDictionary
            let title = jobaya["title"] as? String?
            let description = jobaya["description"] as? String?
            print(title)
        cell.textLabel?.text = "\n"+title!!
           cell.textLabel?.numberOfLines = 4
            cell.detailTextLabel?.numberOfLines=10;
            cell.detailTextLabel?.font = UIFont(name:"Hiragino Sans", size:15)
            cell.textLabel?.font = UIFont(name:"Avenir Next Medium", size: 20)
            cell.textLabel?.highlightedTextColor=UIColor.white
            cell.textLabel?.layoutMargins = UIEdgeInsets(top: 0, left: 0,bottom: 20, right: 0)
            cell.detailTextLabel?.highlightedTextColor=UIColor.white
            return cell
        }
        
        
    }
    
    
}
