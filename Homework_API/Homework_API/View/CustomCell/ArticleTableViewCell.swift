//
//  ArticleTableViewCell.swift
//  Homework_API
//
//  Created by son chanthem on 12/14/16.
//  Copyright © 2016 son chanthem. All rights reserved.
//

import UIKit
import Kingfisher
import FontAwesome_swift

class ArticleTableViewCell: UITableViewCell {

    //MARK: - /Connetion Outlet of UIElement
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var categoryLable: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(article: ArticleModel){
        
       // print("===========================Articl Model in Cell \(article)")
        favoriteLabel.font = UIFont.fontAwesome(ofSize: 20)
        favoriteLabel.text = String.fontAwesomeIcon(name: .heartO)
        
        if let title = article.title {
            titleLabel.text = title.capitalized
        }
        if let author = article.author?.name {
            authorLabel.text =  author
        }
        
        if let category = article.category?.name {
            categoryLable.text = category
        }
        if let imageUrl = article.imageUrl {
            if let url = URL(string: imageUrl){
               // viewImage.kf.setImage(with: url)
                viewImage.kf.setImage(with: url, placeholder: UIImage(named: "noImages"), options: nil, progressBlock: nil, completionHandler: nil)
            }
        }
    }
}
