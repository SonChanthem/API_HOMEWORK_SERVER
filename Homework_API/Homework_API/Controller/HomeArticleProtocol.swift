//
//  HomeArticleProtocol.swift
//  Homework_API
//
//  Created by son chanthem on 12/15/16.
//  Copyright © 2016 son chanthem. All rights reserved.
//

import UIKit


// MARK: - Delegate for HomeArticleTableViewController 

protocol HomeArticleProtocol {
    
    func fetchDataFromPresenter(data: [ArticleModel], pagination:Pagination)
    func deleteDataFromPresenter()
   // func uploadImageFromPresenter()
    
}

// MARK: - Delegate for AddEditTableViewController 

protocol AddEditProtocol {
    
    func completeUploadData()
}
