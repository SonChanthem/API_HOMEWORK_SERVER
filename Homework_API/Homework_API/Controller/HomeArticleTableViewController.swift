//
//  HomeArticleTableViewController.swift
//  Homework_API
//
//  Created by son chanthem on 12/14/16
//  Copyright © 2016 son chanthem. All rights reserved.
//

import UIKit
import PKHUD

class HomeArticleTableViewController: UITableViewController {

    @IBOutlet var myTableView: UITableView!

    var homeArticlePresenter : HomeArticlePresenter?
    
   // var request = ConnectionManager()
    
    var articleModel = [ArticleModel]()
    var pagination:Pagination!
    var whichLoading = false
    
    var shouldShowSearchResults = false
    
    var paggingView : UIActivityIndicatorView?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: Pull to refresh
    func pullData(sender:AnyObject)
    {
        //print("======== pull to refresh =========")
        self.articleModel = [ArticleModel]()
        myTableView.refreshControl?.beginRefreshing()
        homeArticlePresenter?.fetchData(search: "", page: 1, limit: 15)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeArticlePresenter = HomeArticlePresenter()
        homeArticlePresenter?.homeArticleProtocol = self
        //homeArticlePresenter?.fetchData(search: "", page: 1, limit: 15)
        
        // Search Bar ====================
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        //=========== refresh data=============
        myTableView.refreshControl?.addTarget(self, action: #selector(self.pullData(sender:)), for: .valueChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        HUD.hide()
        homeArticlePresenter?.fetchData(search: "", page: 1, limit: 15)
    
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return articleModel.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleTableViewCell
        
        
        if articleModel.count > 0 {
            
            let articles = articleModel[indexPath.section]
            
            cell.configCell(article: articles)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: { (rowAction: UITableViewRowAction, indexPath: IndexPath) in
            
            self.performSegue(withIdentifier: "editSegue", sender: self.articleModel[indexPath.section])
 
        })
        editAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete", handler: { (rowAction: UITableViewRowAction, indexPath: IndexPath) in
            
            self.homeArticlePresenter?.deleteData(articleID: self.articleModel[indexPath.section].id!)
            
            self.articleModel.remove(at: indexPath.section)
            self.myTableView.beginUpdates()
            let indexSet = NSMutableIndexSet()
            indexSet.add(indexPath.section)
            
            self.myTableView.deleteSections(indexSet as IndexSet, with: .fade)
            self.myTableView.endUpdates()
        
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction, editAction]
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == tableView {
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                
                calCulatePage()
            }
        }
    }
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
        return true
     }
    

    //MARK: - Send Data to Detail Table View Controllers ===================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "detailSegue" {
            
            let indexPath = tableView.indexPathForSelectedRow
            let destView = segue.destination as! DetialArticleTableViewController
            
            if searchController.isActive && searchController.searchBar.text != "" {
                
                destView.articleDetail = self.articleModel[(indexPath?.row)!]
            } else{
                destView.articleDetail = self.articleModel[(indexPath?.section)!]

            }            
        }
        
        // Click Edit row =====================
        if segue.identifier == "editSegue" {
            let destView = segue.destination as! AddEditTableViewController
            let article = sender as! ArticleModel
            
            destView.articleModel = article
            
        }
    }
}

// MARK: - Override func protocol
extension HomeArticleTableViewController: HomeArticleProtocol, UISearchResultsUpdating, UISearchBarDelegate {
    
     func deleteDataFromPresenter() {
        
        DispatchQueue.main.sync {
            
            self.myTableView.reloadData()
            
        }
    }
    
    // MARK: Config Pagination =========================
    func calCulatePage(){
        
        whichLoading = true
        
        //print("===========Compare page witb total page==========")
        
        //print("============Total Page: \(pagination.total_pages!)==========")
        
        if pagination.page! < pagination.total_pages! {
            pagination.page  = pagination.page! + 1
            addLoadingIndicator()
            //print("============Page: \(pagination.page!)==========")
            homeArticlePresenter?.fetchData(search: "", page: pagination.page!, limit: 15)
            
        } else {
            
            myTableView.tableFooterView?.isHidden = true
        }
    }
    
    func addLoadingIndicator(){
        
        let activityView = UIView()
        var frame = activityView.frame
        frame.size.width = tableView.bounds.width
        frame.size.height = 40
        activityView.frame = frame
        
        paggingView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        paggingView?.center = activityView.center
        paggingView?.tintColor = UIColor.black
        paggingView?.color = UIColor.black
        paggingView?.startAnimating()
        activityView.addSubview(paggingView!)
        tableView.tableFooterView = activityView
    }
    
    //MARK: Complete From Presenter
    func fetchDataFromPresenter(data: [ArticleModel], pagination:Pagination) {
        myTableView.refreshControl?.endRefreshing()
         myTableView.tableFooterView?.isHidden = true
        self.pagination = pagination
        
        if whichLoading == false {
            
            self.articleModel = data
            
        } else {
           
            whichLoading = false
            self.articleModel.append(contentsOf: data)
            
        }
        
        DispatchQueue.main.sync {
            
            self.myTableView.reloadData()
            
        }
    }
    
    //MARK: - Search Controller =============
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.isActive {

            print("search is active")
            self.articleModel.removeAll(keepingCapacity: false)
            
            
            if !((searchController.searchBar.text?.isEmpty)!) {
                
                homeArticlePresenter?.fetchData(search: (searchController.searchBar.text?.lowercased())!, page: 1, limit: 15)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        print("cancel search")
        shouldShowSearchResults = false
        homeArticlePresenter?.fetchData(search: "", page: 1, limit: 15)
        //self.myTableView.reloadData()

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
         print("did begin editing search")
        
        shouldShowSearchResults = true
        self.myTableView.reloadData()
    }
}
