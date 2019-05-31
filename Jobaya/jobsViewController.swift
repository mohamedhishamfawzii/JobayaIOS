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
    var allJobs  : [NSDictionary] = []
    var partJobs : [NSDictionary] = []
    var usherJobs : [NSDictionary] = []
    var freelanceJobs : [NSDictionary] = []
    var internships : [NSDictionary] = []
    var selectedJob: NSDictionary = [:]
    enum categoryenum
 {
        case all,part,usher,freelance,internship
    

    }
  var  categorySelected :categoryenum!
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UserDefaults.standard.string(forKey: "email")!)
        self.categorySelected = .all
        getJobs()
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        setupSearchBar()
    }
    
    func setupSearchBar() {
        self.navigationItem.title = "Jobs"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
         self.definesPresentationContext = true
        self.navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController?.searchBar.delegate = self
    }
    
    @IBOutlet weak var category: UISegmentedControl!
    
    @IBAction func categorieChanged(_ sender: Any) {
        switch category.selectedSegmentIndex
        {
        case 0:
            jobs = allJobs
            self.jobsTable.reloadData()
            categorySelected = categoryenum.all
            
            
        case 1:
            if (usherJobs.count != 0)
            { jobs = usherJobs
                self.jobsTable.reloadData()
                 categorySelected = categoryenum.usher
            }else{
                let alert = UIAlertController(title: "No jobs avaliable", message: "no ushering for now please stay tuned", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                self.category.selectedSegmentIndex = 0
                jobs = allJobs
                self.jobsTable.reloadData()
            }
            
        case 2:
            if (partJobs.count != 0){
                jobs = partJobs
                 categorySelected = categoryenum.part
                self.jobsTable.reloadData()
            }else{
                let alert = UIAlertController(title: "No jobs avaliable", message: "no part time jobs for now please stay tuned", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                self.category.selectedSegmentIndex = 0
                jobs = allJobs
                self.jobsTable.reloadData()
            }
        case 3:
            if (internships.count != 0){
                jobs = internships
                 categorySelected = categoryenum.internship
                self.jobsTable.reloadData()
            }
            else{
                let alert = UIAlertController(title: "No jobs avaliable", message: "no internships for now please stay tuned", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                self.category.selectedSegmentIndex = 0
                jobs = allJobs
                self.jobsTable.reloadData()
            }
        case 4:
            if (freelanceJobs.count != 0){
                jobs = freelanceJobs
                 categorySelected = categoryenum.freelance
                self.jobsTable.reloadData()
            }
            else{
                let alert = UIAlertController(title: "No jobs avaliable", message: "no freelance jobs for now please stay tuned", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                self.category.selectedSegmentIndex = 0
                jobs = allJobs
                self.jobsTable.reloadData()
            }
            
        default:
            jobs = allJobs
        }
    }
    
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
                self.allJobs=self.jobs
                let  name = self.jobs[2]
                print(name["title"] as! String)
                self.filterJobs()
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objSecond = storyboard.instantiateViewController(withIdentifier: "detailsView") as! JobDetails
        objSecond.job = selectedJob
        navigationController?.pushViewController(objSecond, animated: true)
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
    
  
    
    func filterJobs(){
        
        self.partJobs = allJobs.filter { $0["category"]as? String? == "parttime" }
        print (self.partJobs)
        self.freelanceJobs = allJobs.filter { $0["category"]as? String? == "freelance" }
        
        self.usherJobs = allJobs.filter { $0["category"]as? String? == "usher" }
        print (self.usherJobs)
        self.internships = allJobs.filter { $0["category"]as? String? == "internship" }
    }
}


extension jobsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let _ = searchController.searchBar.text {
            
        }
    }
}

extension jobsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if searchBar.text?.isEmpty ?? true , text == "" {
            return false
        }else {
            print("text",text)
            NSObject.cancelPreviousPerformRequests(
                withTarget: self,
                selector: #selector(self.getHintsFromTextField),
                object: searchBar)
            self.perform(
                #selector(self.getHintsFromTextField),
                with: searchBar,
                afterDelay: 0.6)
            return true
        }
    }
    
    @objc private func getHintsFromTextField(searchBar: UISearchBar) {
        let searchText = searchBar.text!
        /// if the user deleted all the text in search bar
        if searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            //            presenter.searchbarBecomeEmpty()
            //            handleResultView(emptySearchText: true)
           
        }else if searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
            
            switch categorySelected {
            case .all? :
                jobs = allJobs.filter {
                    
                    let title = $0["title"]as? String
                    return   (title!.lowercased().contains(searchBar.text!)) }
                print("match",searchBar.text ?? "")
                self.jobsTable.reloadData()
            case .part?:
                jobs = partJobs.filter { let title = $0["title"]as? String
                    return   title!.lowercased().contains( searchBar.text!) }
                print("match",searchBar.text ?? "")
                self.jobsTable.reloadData()
            case .usher?:
                jobs = usherJobs.filter { let title = $0["title"]as? String
                    return   title!.lowercased().contains( searchBar.text!)}
                print("match",searchBar.text ?? "")
                self.jobsTable.reloadData()
            case .freelance?:
                jobs = freelanceJobs.filter { let title = $0["title"]as? String
                    return   title!.lowercased().contains( searchBar.text!) }
                print("match",searchBar.text ?? "")
                self.jobsTable.reloadData()
            case .internship?:
                jobs = internships.filter { let title = $0["title"]as? String
                    return   title!.lowercased().contains( searchBar.text!) }
                print("match",searchBar.text ?? "")
                self.jobsTable.reloadData()
            case .none:
                print("none")
            }
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        jobs=allJobs
        self.jobsTable.reloadData()
        switch categorySelected {
        case .all? :
            jobs = allJobs.filter {
                
                let title = $0["title"]as? String
                return   (title!.lowercased().contains(searchBar.text!)) }
            print("match",searchBar.text ?? "")
            self.jobsTable.reloadData()
        case .part?:
            jobs = partJobs.filter { let title = $0["title"]as? String
                return   title!.lowercased().contains( searchBar.text!) }
            print("match",searchBar.text ?? "")
            self.jobsTable.reloadData()
        case .usher?:
            jobs = usherJobs.filter { let title = $0["title"]as? String
                return   title!.lowercased().contains( searchBar.text!)}
            print("match",searchBar.text ?? "")
            self.jobsTable.reloadData()
        case .freelance?:
            jobs = freelanceJobs.filter { let title = $0["title"]as? String
                return   title!.lowercased().contains( searchBar.text!) }
            print("match",searchBar.text ?? "")
            self.jobsTable.reloadData()
        case .internship?:
            jobs = internships.filter { let title = $0["title"]as? String
                return   title!.lowercased().contains( searchBar.text!) }
            print("match",searchBar.text ?? "")
            self.jobsTable.reloadData()
        case .none:
            print("none")
        }
    
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
      
      
        
        //        handleResultView(emptySearchText: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //        handleResultView(emptySearchText: true)
        jobs=allJobs
         self.jobsTable.reloadData()
    }
}
