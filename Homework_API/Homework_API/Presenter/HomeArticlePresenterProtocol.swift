//
//  HomeArticlePresenterPortocol.swift
//  Homework_API
//
//  Created by son chanthem on 12/15/16.
//  Copyright © 2016 son chanthem. All rights reserved.
//

import Foundation

protocol HomeArticlePresenterProtocol {
    
    func fetchDataFromService(data: [ArticleModel], pagination:Pagination)
    
    func deleteDataFromServerFinish()
    
    func uploadImageFromServerFinish(imageUrl: String)
    
    func uploadDataComplete()
}
