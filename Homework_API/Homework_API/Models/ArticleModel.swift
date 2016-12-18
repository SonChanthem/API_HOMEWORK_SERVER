//
//  ArticleModel.swift
//  Homework_API
//
//  Created by son chanthem on 12/14/16.
//  Copyright © 2016 son chanthem. All rights reserved.
//

import UIKit
import ObjectMapper

struct Category : Mappable {
    
    var id:Int?
    var name:String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id      <- map["ID"]
        name    <- map["NAME"]
        
    }
}

struct Author : Mappable {
    var id:Int?
    var name:String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id      <- map["ID"]
        name    <- map["NAME"]
        
    }
}

struct ArticleModel : Mappable {
    var id:Int?
    var title : String?
    var description: String?
    var imageUrl:String?
    var category:Category?
    var author:Author?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id      <- map["ID"]
        title   <- map["TITLE"]
        description <- map["DESCRIPTION"]
        imageUrl    <- map["IMAGE"]
        category   <- map["CATEGORY"]
        author  <- map["AUTHOR"]
    }
}

struct Pagination : Mappable {
    var page:Int?
    var limit : Int?
    var total_count: Int?
    var total_pages:Int?
   
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        page        <- map["PAGE"]
        limit       <- map["LIMIT"]
        total_count <- map["TOTAL_COUNT"]
        total_pages <- map["TOTAL_PAGES"]

    }
}



