//
//  AddEditTableViewController.swift
//  Homework_API
//
//  Created by son chanthem on 12/14/16.
//  Copyright © 2016 son chanthem. All rights reserved.
//

import UIKit
import  Kingfisher
import PKHUD

class AddEditTableViewController: UITableViewController {

    let imagePicker = UIImagePickerController()
    var homeArticlePresenter : HomeArticlePresenter?
    
    var articleModel : ArticleModel!
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var viewImage: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UITextView!
    
    //MARK: Button Upload =========================
    @IBAction func uploadDataButton(_ sender: Any) {
        
        HUD.show(.progress)
        
        homeArticlePresenter = HomeArticlePresenter()
        
        homeArticlePresenter?.addEditProtocol = self
        
        var myData:[String:Any]!
            
        let imageData = UIImagePNGRepresentation(viewImage.image!)
        
        if let title = titleLabel.text, let description =  descriptionLabel.text  {
            
            myData = [
                "TITLE": title,
                "DESCRIPTION": description,
                "AUTHOR": 0,
                "CATEGORY_ID" : 0,
                "STATUS": "string",
                "IMAGE": ""
            ]
        }
        
        var articleData = ArticleModel(JSON: myData)
            
        if articleModel == nil {
            
             homeArticlePresenter?.uploadData(article: articleData!, imageURL: imageData!)
            
        } else {
            
            articleData?.id = articleModel.id
            print("article ID: ==== \(articleData?.id)")
            
            homeArticlePresenter?.updateData(artile: articleData!, imageURL: imageData!, resquest: "request")
        }
    }
    
    //MARK : - Choose Image ========================
    @IBAction func clickChooseImage(_ sender: Any) {
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        let alertController = UIAlertController(title: "Choose Options", message: "What would you like to do?", preferredStyle: .actionSheet)
        
        let libraryButton = UIAlertAction(title: "Photo Library", style: .default, handler: { (action) -> Void in
            print("Photo Library button tapped")
            
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let  cameraButton = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            print("Camera button tapped")
            
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                
                self.present(self.imagePicker, animated: true, completion: nil)
                
            } else {
                self.noCamera()
            }
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        alertController.addAction(libraryButton)
        alertController.addAction(cameraButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        if articleModel != nil {
            titleLabel.text = articleModel.title
            descriptionLabel.text = articleModel.description
            viewImage.kf.setImage(with: URL(string:articleModel.imageUrl!), placeholder: UIImage(named:"noImages"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    //MARK: Method for camera
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
}
//MARK: - Comform Protocol ====================
extension AddEditTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, AddEditProtocol{
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        viewImage.contentMode = .scaleAspectFit
        viewImage.image = chosenImage
        dismiss(animated:true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func completeUploadData() {
        
        DispatchQueue.main.async {
            
            HUD.hide()
            self.navigationController!.popViewController(animated: true)
            
        }
    }
}

