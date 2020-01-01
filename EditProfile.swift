/*-----------------------------------
 
 - Recipes -
 
 Created by cubycode ©2017
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
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var occupationTxt: UITextField!
    @IBOutlet weak var aboutMeTxt: UITextView!
    @IBOutlet weak var avatarimage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var updateProfileOutlet: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    

    /* Variables */
    var userObj = PFUser()
    
    
    
    
override func viewDidLoad() {
        super.viewDidLoad()

    
    self.title = "EDIT PROFILE"
    
    view1.layer.cornerRadius = 10
    view1.layer.borderWidth = 1
    view1.layer.borderColor = UIColor(red: 128.0/255, green: 128.0/255, blue: 128.0/255, alpha: 1.0).cgColor
    
    view2.layer.cornerRadius = 10
    view2.layer.borderWidth = 1
    view2.layer.borderColor = UIColor(red: 128.0/255, green: 128.0/255, blue: 128.0/255, alpha: 1.0).cgColor
    
    view3.layer.cornerRadius = 10
    view3.layer.borderWidth = 1
    view3.layer.borderColor = UIColor(red: 128.0/255, green: 128.0/255, blue: 128.0/255, alpha: 1.0).cgColor
    
    // Initialize a BACK BarButton Item
    let butt = UIButton(type: UIButtonType.custom)
    butt.adjustsImageWhenHighlighted = false
    butt.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
    butt.setBackgroundImage(UIImage(named: "backButt"), for: .normal)
    butt.addTarget(self, action: #selector(backButt(_:)), for: .touchUpInside)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: butt)

    updateProfileOutlet.layer.cornerRadius = 21
    updateProfileOutlet.layer.shadowOpacity = 1
    updateProfileOutlet.layer.shadowRadius = 5.0
    updateProfileOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
    updateProfileOutlet.layer.masksToBounds = false
    updateProfileOutlet.layer.shadowPath = UIBezierPath(roundedRect:  updateProfileOutlet.bounds, cornerRadius: updateProfileOutlet.layer.cornerRadius).cgPath
    updateProfileOutlet.layer.shadowColor = UIColor(red: 128.0/255, green: 128.0/255, blue: 128.0/255, alpha: 1.0).cgColor
    
    
    mainView.layer.cornerRadius = 21
    mainView.layer.shadowOpacity = 1
    mainView.layer.shadowRadius = 5.0
    mainView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
    mainView.layer.masksToBounds = false
    mainView.layer.shadowPath = UIBezierPath(roundedRect:  mainView.bounds, cornerRadius: mainView.layer.cornerRadius).cgPath
    updateProfileOutlet.layer.shadowColor = UIColor(red: 128.0/255, green: 128.0/255, blue: 128.0/255, alpha: 1.0).cgColor
    
    containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width, height: 800)
    
    // Round views corners
    updateProfileOutlet.layer.cornerRadius = 5
    avatarimage.layer.cornerRadius = avatarimage.bounds.size.width/2
    
    createKeyboardToolbar()
    showUserDetails()
}

    
// MARK: - TOOLBAR TO DISMISS THE KEYBOARD
func createKeyboardToolbar() {
    let keyboardToolbar = UIView()
    keyboardToolbar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44)
    keyboardToolbar.backgroundColor = UIColor.clear
    keyboardToolbar.autoresizingMask = UIViewAutoresizing.flexibleWidth
    fullnameTxt.inputAccessoryView = keyboardToolbar
    occupationTxt.inputAccessoryView = keyboardToolbar
    aboutMeTxt.inputAccessoryView = keyboardToolbar
    
    // Dismiss keyboard button
    let dismissButt = UIButton(type: .custom)
    dismissButt.frame = CGRect(x: keyboardToolbar.frame.size.width-44, y: 0, width: 44, height: 44)
    dismissButt.setBackgroundImage(UIImage(named: "dismissButt"), for: .normal)
    dismissButt.addTarget(self, action: #selector(dismissKeyboard(_:)), for: .touchUpInside)
    keyboardToolbar.addSubview(dismissButt)
        
}
@objc func dismissKeyboard(_ sender:UIButton) {
    fullnameTxt.resignFirstResponder()
    occupationTxt.resignFirstResponder()
    aboutMeTxt.resignFirstResponder()
}

    
    
    
// MARK: SHOW USER DETAILS
func showUserDetails() {
    fullnameTxt.text = "\(userObj[USER_FULLNAME]!)"
    if userObj[USER_JOB] != nil { occupationTxt.text = "\(userObj[USER_JOB]!)"
    } else { occupationTxt.text = nil }
    if userObj[USER_ABOUTME] != nil { aboutMeTxt.text = "\(userObj[USER_ABOUTME]!)"
    } else { aboutMeTxt.text = nil }
    emailLabel.text = "\(userObj[USER_EMAIL]!)"
    
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
    
    
    
    
// MARK: - BACK BUTTON
@objc func backButt(_ sender:UIButton) {
    _ = navigationController?.popViewController(animated: true)
}
  
  
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
