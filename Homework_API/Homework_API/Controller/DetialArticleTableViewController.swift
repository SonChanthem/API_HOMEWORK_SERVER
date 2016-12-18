//
//  DetialArticleTableViewController.swift
//  Homework_API
//
//  Created by son chanthem on 12/14/16.
//  Copyright © 2016 son chanthem. All rights reserved.
//

import UIKit

class DetialArticleTableViewController: UITableViewController {
    
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLable: UITextView!
    
    var articleDetail: ArticleModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        if articleDetail != nil{
            titleLabel.text = articleDetail?.title
            descriptionLable.text = articleDetail?.description
            
            if let url = URL(string: (articleDetail?.imageUrl)!) {
                
                if let data = try? Data(contentsOf: url) {
                    viewImage.image = UIImage(data: data)

                } else {
                    viewImage.image = UIImage(named: "noImages")
                }
                
            } else {
                viewImage.image = UIImage(named: "noImages")
            }
          
        }
    }
    
    
    
}
