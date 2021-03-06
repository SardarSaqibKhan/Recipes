/*-----------------------------------
 
 - Recipes -
 
 Created by ElTech ©2017
 All Rights reserved
 
 -----------------------------------*/

import UIKit
import Parse


class SignUp: UIViewController,
UITextFieldDelegate
{
    
    /* Views */
    @IBOutlet var containerScrollView: UIScrollView!
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var fullnameTxt: UITextField!
    @IBOutlet var mainView: UIView!
    

    
    
override func viewDidLoad() {
        super.viewDidLoad()
    
    
    //mainView.layer.cornerRadius = 21
    //mainView.layer.shadowOpacity = 1
    //mainView.layer.shadowRadius = 5.0
    //mainView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
    //mainView.layer.masksToBounds = false
    //mainView.layer.shadowPath = UIBezierPath(roundedRect: mainView.bounds, cornerRadius: mainView.layer.cornerRadius).cgPath
    //mainView.layer.shadowColor = UIColor(red: 128.0/255, green: 128.0/255, blue: 128.0/255, alpha: 1.0).cgColor
    
    // Setup layout views
    containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width, height: 300)
}
    
    
    
// MARK: - TAP TO DISMISS KEYBOARD
@IBAction func tapToDismissKeyboard(_ sender: UITapGestureRecognizer) {
   dismissKeyboard()
}
func dismissKeyboard() {
    usernameTxt.resignFirstResponder()
    passwordTxt.resignFirstResponder()
    confirmPassword.resignFirstResponder()
    fullnameTxt.resignFirstResponder()
}
    
// MARK: - SIGNUP BUTTON
@IBAction func signupButt(_ sender: AnyObject) {
    dismissKeyboard()
    showHUD()

    let userForSignUp = PFUser()
    userForSignUp.username = usernameTxt.text!.lowercased()
    userForSignUp.password = passwordTxt.text
    userForSignUp.email = usernameTxt.text
    userForSignUp[USER_FULLNAME] = fullnameTxt.text
    userForSignUp[USER_IS_REPORTED] = false
    
    // Save default avatar
    let imageData = UIImageJPEGRepresentation(UIImage(named:"logo")!, 1.0)
    let imageFile = PFFile(name:"image.jpg", data:imageData!)
    userForSignUp[USER_AVATAR] = imageFile
    
    if usernameTxt.text == "" || passwordTxt.text == "" || fullnameTxt.text == "" || confirmPassword.text == "" {
        simpleAlert("All fields are required to sign up")
        hideHUD()
        
    }
    else if passwordTxt.text !=  confirmPassword.text {
        simpleAlert("Passwords do not match")
        hideHUD()
        
    }
    else
    {
        userForSignUp.signUpInBackground { (succeeded, error) -> Void in
            if error == nil {
                self.dismiss(animated: false, completion: nil)
                self.view.window!.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
                self.hideHUD()
        
            // ERROR ON SIGN UP
            } else {
                self.simpleAlert("\(error!.localizedDescription)")
                self.hideHUD()
        }}
    }
    
}
    
    
    
// MARK: -  TEXTFIELD DELEGATE
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == usernameTxt {  passwordTxt.becomeFirstResponder()  }
    if textField == passwordTxt {  fullnameTxt.becomeFirstResponder()     }
    if textField == fullnameTxt {  fullnameTxt.resignFirstResponder()     }
return true
}
    
    
    
// MARK: - BACK BUTTON
@IBAction func backButt(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
}
    
    

// MARK: - TERMS OF USE BUTTON
@IBAction func touButt(_ sender: AnyObject) {
    let touVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsOfUse") as! TermsOfUse
    present(touVC, animated: true, completion: nil)
}
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
