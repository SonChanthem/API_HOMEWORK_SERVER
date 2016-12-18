//
//  HomeArticlePresenter.swift
//  Homework_API
//
//  Created by son chanthem on 12/15/16.
//  Copyright © 2016 son chanthem. All rights reserved.
//

import UIKit

class HomeArticlePresenter {
    
    //MARK : - Global Variable ===========
    var homeArticleProtocol : HomeArticleProtocol?
    var addEditProtocol: AddEditProtocol?
    var connectionManager =  ConnectionManager()
    
    var articleModel:ArticleModel?
    var request:String!
    
    //MARK : - Fetch Data From Server ===========
    func fetchData(search: String, page: Int, limit: Int) {
        
        // set delegate to service ConnectionManager =================
        
        connectionManager.homeArticlePresenterProtocol = self
        
        // Notify back to service ConnectionManager ==================
        connectionManager.requestData(search: search, page: page, limit: limit)
        
    }
    
    //MARK : - Delete Data From Server ===========
    func deleteData(articleID: Int){
        
        connectionManager.homeArticlePresenterProtocol = self
        connectionManager.deleteDataFromServer(articleID: articleID)
    }
    
    //MARK : - Upload Data to Server ===========
    func uploadData(article:ArticleModel, imageURL:Data){
        
        connectionManager.homeArticlePresenterProtocol = self
        articleModel = article
        connectionManager.uploadImage(data: imageURL)
    }
    
    //MARK : - UpDate Data to Server ===========
    func updateData(artile: ArticleModel, imageURL: Data, resquest:String) {
        connectionManager.homeArticlePresenterProtocol = self
        articleModel = artile
        self.request = resquest
        connectionManager.uploadImage(data: imageURL)
        
    }
   
}

//MARK: - Conform to Protocol ===============================================
extension HomeArticlePresenter: HomeArticlePresenterProtocol {
    
    func fetchDataFromService(data: [ArticleModel], pagination:Pagination) {
        
       // print("Data From Service \(data)")
        
        // Notify back to HomeArticle ================================
        homeArticleProtocol?.fetchDataFromPresenter(data: data, pagination:pagination)
        
    }
    
    //MARK: - notify to view
    func deleteDataFromServerFinish() {
        
        
        homeArticleProtocol?.deleteDataFromPresenter()
    }
    
    func uploadImageFromServerFinish(imageUrl: String) {

        connectionManager.homeArticlePresenterProtocol = self
        articleModel?.imageUrl = imageUrl
        
        if request == nil {
            
            //print("======================uploadimage finish")
            //print(imageUrl)
           
            connectionManager.postDataToServer(article: articleModel!)
            
        } else {
            
            //print("======================update finish")
            connectionManager.updateDataToServer(article: articleModel!)
        }
    }
    
    func uploadDataComplete() {
        
        //print("======================post finish")
        addEditProtocol?.completeUploadData()
    }
}
