//
//  UploadMultiTableViewController.swift
//  Homework_API
//
//  Created by son chanthem on 12/18/16.
//  Copyright © 2016 son chanthem. All rights reserved.
//

import UIKit
import PKHUD
import DKImagePickerController
import Alamofire

class UploadMultiTableViewController: UITableViewController {
    
    let dkpickerController = DKImagePickerController()
    var imageDKAsset:[DKAsset]!

    
    var imagePath:[URL] = [URL]()
    
    var imageUIImage: [UIImage] = [UIImage]()
    
    @IBOutlet var imageTableView: UITableView!
    
    let headers: HTTPHeaders = [
        "Authorization": "Basic cmVzdGF1cmFudEFETUlOOnJlc3RhdXJhbnRQQFNTV09SRA==",
        "Accept": "application/json"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - Buttob Browse Image ============
    @IBAction func browseButton(_ sender: Any) {
        
        dkpickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            for imageDK in assets {
                
                imageDK.fetchOriginalImageWithCompleteBlock({ (imageData, info) in
                    
                    self.imageUIImage.append(imageData!)
                    self.imageTableView.reloadData()
                    
                    self.imagePath.append(info!["PHImageFileURLKey"] as! URL)
                    
                })
            }
        }
        
        present(dkpickerController, animated: true, completion: {
            
            self.dkpickerController.deselectAllAssets()
        })
    }
    
    // MARK: - Button Upload Data =============
    @IBAction func uploadImageButton(_ sender: Any) {
        
        HUD.show(.progress)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                for imageui in self.imageUIImage {
                    
                    multipartFormData.append(UIImageJPEGRepresentation(imageui, 0.6)!, withName: "files", fileName:"image.jpg", mimeType: "image/jpg")
                }
                
                multipartFormData.append("restaurant".data(using: .utf8)!, withName: "name")
        },
            
            to: "http://120.136.24.174:15020/v1/api/admin/upload/multiple",
            method: HTTPMethod(rawValue: "POST")!,
            headers: headers,
            
            
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        
                        HUD.hide()
                        
                        HUD.flash(.success, delay: 1.5)
                    }
                case .failure(let encodingError):
                    print(encodingError)
            }
        }
        )
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return imageUIImage.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MultiUploadTableViewCell
        
        cell.uploadImageView.image = imageUIImage[indexPath.row]
        cell.imagePathLabel.text = imagePath[indexPath.row].description
        
        return cell

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            imagePath.remove(at: indexPath.row)
            imageUIImage.remove(at: indexPath.row)
            
        }
        
        imageTableView.reloadData()
    }

}
