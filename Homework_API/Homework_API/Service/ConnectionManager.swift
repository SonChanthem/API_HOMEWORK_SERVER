//
//  ConnectionManager.swift
//  Homework_API
//
//  Created by son chanthem on 12/15/16.
//  Copyright © 2016 son chanthem. All rights reserved.
//

import UIKit

class ConnectionManager {

    //MARK: - Global Variable =================
    var homeArticlePresenterProtocol: HomeArticlePresenterProtocol?
    var articleModel = [ArticleModel]()
    var pagination: Pagination!

    // MARK: - Request data from server
    func requestData(search: String, page: Int, limit: Int) {
        
        articleModel = [ArticleModel]()
        
       // print(search)
        
        let url = URL(string:"\(Constant.ArticleConstant.ARTICLE_URL_BASE)?title=\(search.replacingOccurrences(of: " ", with: "%20"))&page=\(page)&limit=\(limit)")
        
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.addValue(Constant.ArticleConstant.ARTICLE_HEADER["Authorization"]!, forHTTPHeaderField: "Authorization")
        
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            do{
                if error == nil {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
                    
                    let dataResponse = jsonData["DATA"] as! [Any]
                    let paginationResponse = jsonData["PAGINATION"] as! [String:Any]
                    self.pagination = Pagination(JSON: paginationResponse)
                    
                    
                    for data in dataResponse {
                        
                        self.articleModel.append(ArticleModel(JSON: data as! [String: Any])!)
                    }
                    
                    
                    // <<<<<<<<<<<<<<< Notify >>>>>>>>>>>>>>>>>
                    self.homeArticlePresenterProtocol?.fetchDataFromService(data: self.articleModel,pagination: self.pagination)
                    
                } else {
                    print("error trying to get data from server")
                }
            
            }catch {
                print("error trying to convert data to JSON")
                return
            }
        })
        
        task.resume()
        
    }
    
    // MARK: - Delete data from server =================
    func deleteDataFromServer(articleID: Int) {
        
        //print(articleID)
        
        let url = URL(string: "\(Constant.ArticleConstant.ARTICLE_URL_BASE)/\(articleID)")

        var urlRequest = URLRequest(url: url!)
        
        urlRequest.addValue(Constant.ArticleConstant.ARTICLE_HEADER["Authorization"]!, forHTTPHeaderField: "Authorization")
        
        urlRequest.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            
            if error == nil {
                    
                //-------------- Notify
                self.homeArticlePresenterProtocol?.deleteDataFromServerFinish()
                //print(response!)
                
            } else {
                print("error trying to get data from server")
            }
        })
        
        task.resume()
    }
    
    
    //MARK: Upload Image ===================
    func uploadImage(data: Data) {
        
        let url = URL(string: Constant.ArticleConstant.ARTICLE_URL_IMAGE)
        var urlRequest = URLRequest(url: url!)
        
        // Set method
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue(Constant.ArticleConstant.ARTICLE_HEADER["Authorization"], forHTTPHeaderField: "Authorization")
        
        // Set boundary
        let boundary = "Boundary-\(UUID().uuidString)"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Create requestBody
        var formData = Data()
        
        let mimeType = "image/png" // Multipurpose Internet Mail Extension
        formData.append("--\(boundary)\r\n".data(using: .utf8)!)
        formData.append("Content-Disposition: form-data; name=\"FILE\"; filename=\"Image.png\"\r\n".data(using: .utf8)!)
        formData.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        formData.append(data)
        formData.append("\r\n".data(using: .utf8)!)
        formData.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        urlRequest.httpBody = formData
        
        print(formData)
        
        
        let uploadTask = URLSession.shared.dataTask(with: urlRequest){
            
            data, response, error in
            
            var responseData: String?
            
            if error == nil{
                
                print("Success : \(response)")
                
                do{
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
                    
                    responseData = jsonData["DATA"] as? String
                    
                }catch let error{
                    print("Error : \(error.localizedDescription)")
                }
                
                self.homeArticlePresenterProtocol?.uploadImageFromServerFinish(imageUrl: responseData!)
                
            }else{
                
                print("\(error?.localizedDescription)")
            }
            
        }
        
        uploadTask.resume()
        
    }
    
    //MARK: - Send Article to Server ==================
    
    func postDataToServer(article: ArticleModel) {
            
        let jsonString = article.toJSONString()
       // print("jsong ========= \(jsonString)")
    
        var urlrequest = URLRequest(url: URL(string: Constant.ArticleConstant.ARTICLE_URL_BASE)!)
        
        urlrequest.addValue(Constant.ArticleConstant.ARTICLE_HEADER["Authorization"]!, forHTTPHeaderField: "Authorization")
        
        urlrequest.httpMethod = "POST"
        //=================== Tell Server To Accept ========
        urlrequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlrequest.addValue("application/json", forHTTPHeaderField: "Accept")
    
        urlrequest.httpBody = jsonString?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlrequest as URLRequest){ data,response,error in
            
            if error != nil{
                
                print("\(error?.localizedDescription)")
                return
                
            }
            
            self.homeArticlePresenterProtocol?.uploadDataComplete()
            
        }
        
        task.resume()
    }
    
    
    //MARK: - Update Data ===============
    func updateDataToServer(article: ArticleModel) {
        
        let jsonString = article.toJSONString()
        print("jsong ========= \(jsonString)")
        
        let url = "\(Constant.ArticleConstant.ARTICLE_URL_BASE)/\(article.id!)"
        var urlrequest = URLRequest(url: URL(string: url)!)
        print("url upldate ==============")
        print(url)
        
        urlrequest.addValue(Constant.ArticleConstant.ARTICLE_HEADER["Authorization"]!, forHTTPHeaderField: "Authorization")
        
        urlrequest.httpMethod = "PUT"
        
        //=================== Tell Server To Accept ========
        urlrequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlrequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        urlrequest.httpBody = jsonString?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlrequest as URLRequest){ data,response,error in
            
            if error != nil{
                
                print("\(error?.localizedDescription)")
                return
                
            }
            
            self.homeArticlePresenterProtocol?.uploadDataComplete()
        }
        
        task.resume()
 
    }
}





