/*-----------------------------------
 
 - Recipes -
 
 Created by ElTech ©2017
 All Rights reserved
 
 -----------------------------------*/

import UIKit
import Parse


class EditProfile: UIViewController,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UITextFieldDelegate
{

    /* Views */
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var occupationTxt: UITextField!
    @IBOutlet weak var aboutMeTxt: UITextView!
    @IBOutlet weak var avatarimage: UIImageView!
    @IBOutlet weak var emailTxt: UITextField!
    
    /* Variables */
    var userObj = PFUser()
    
    
override func viewDidLoad() {
        super.viewDidLoad()

    self.navigationController?.navigationBar.addGradientNavigationBar(colors: [ThemeColor, GredientLightColor], angle: 135)
        

    showUserDetails()
}

    


    
    
    
// MARK: SHOW USER DETAILS
func showUserDetails() {
    fullnameTxt.text = "\(userObj[USER_FULLNAME]!)"
    if userObj[USER_JOB] != nil { occupationTxt.text = "\(userObj[USER_JOB]!)"
    } else { occupationTxt.text = nil }
    if userObj[USER_ABOUTME] != nil { aboutMeTxt.text = "\(userObj[USER_ABOUTME]!)"
    } else { aboutMeTxt.text = nil }
    emailTxt.text = "\(userObj[USER_EMAIL]!)"
    
    // Get avatar image
    avatarimage.image = UIImage(named: "logo")
    let imageFile = userObj[USER_AVATAR] as? PFFile
    imageFile?.getDataInBackground(block: { (imageData, error) -> Void in
        if error == nil {
            if let imageData = imageData {
                self.avatarimage.image = UIImage(data:imageData)
    } } })
    
}
    
 
    
// MARK: - UPLOAD AVATAR IMAGE BUTTON
@IBAction func uploadPicButt(_ sender: AnyObject) {
    let alert = UIAlertController(title: APP_NAME,
        message: "Select source",
        preferredStyle: UIAlertControllerStyle.alert)
    let camera = UIAlertAction(title: "Take a picture", style: .default, handler: { (action) -> Void in
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    })
    let library = UIAlertAction(title: "Pick from Library", style: .default, handler: { (action) -> Void in
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
            
    })
        
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
    
    alert.addAction(camera);
    alert.addAction(library);
    alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
}

    
// ImagePicker delegate
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        avatarimage.image = scaleImageToMaxWidth(image: pickedImage, newWidth: 300)

    }
    dismiss(animated: true, completion: nil)
}
 
    

    
// MARK: - UPDATE PROFILE BUTTON
@IBAction func updateProfileButt(_ sender: AnyObject) {
    showHUD()
    
    userObj[USER_FULLNAME] = fullnameTxt.text
    userObj[USER_EMAIL] = emailTxt.text
    userObj[USER_USERNAME] = emailTxt.text
    
    if occupationTxt.text != "" { userObj[USER_JOB] = occupationTxt.text
    } else { userObj[USER_JOB] = "" }
    if aboutMeTxt.text != "" { userObj[USER_ABOUTME] = aboutMeTxt.text
    } else { userObj[USER_ABOUTME] = "" }
    
    // Save Image (if exists)
    if avatarimage.image != nil {
        let imageData = UIImageJPEGRepresentation(avatarimage.image!, 0.5)
        let imageFile = PFFile(name:"avatar.jpg", data:imageData!)
        userObj[USER_AVATAR] = imageFile
    }
    
    userObj.saveInBackground { (success, error) -> Void in
        if error == nil {
            self.simpleAlert("Your Profile has been updated!")
            self.hideHUD()
            _ = self.navigationController?.popViewController(animated: true)
            
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    }}
}
    
@IBAction func btnBack(_ sender: Any) {
    _ = navigationController?.popViewController(animated: true)
}

override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
