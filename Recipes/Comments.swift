/*-----------------------------------
 
 - Recipes -
 
 Created by ElTech ©2017
 All Rights reserved
 
 -----------------------------------*/

import UIKit
import Parse



// MARK: - COMMENT CUSTOM CELL
class CommentCell: UITableViewCell {
    /* Views */
    @IBOutlet weak var cAvatarImage: UIImageView!
    @IBOutlet weak var cFullnameLabel: UILabel!
    @IBOutlet weak var cTxtView: UITextView!
    @IBOutlet weak var cDateLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
}







// MARK: - COMMENTS CONTROLLER
class Comments: UIViewController,
UITableViewDelegate,
UITableViewDataSource,
UITextViewDelegate,
UITextFieldDelegate
{

    /* Views */
    @IBOutlet weak var commentsTableView: UITableView!
    let commentTxt = UITextView()
    @IBOutlet weak var fakeTxt: UITextField!
    
    
    
    /* Variables */
    var recipeObj = PFObject(className: RECIPES_CLASS_NAME)
    var recipeUser = PFUser()
    var commentsArray = [PFObject]()
    
  

    
    
    
override func viewWillAppear(_ animated: Bool) {
    
    // Get User Pointer
    let userPointer = recipeObj[RECIPES_USER_POINTER] as! PFUser
    userPointer.fetchIfNeededInBackground(block: { (user, error) in
        if error == nil {

            // Get user of this Recipe
            self.recipeUser = userPointer
            
            // Call query
            self.queryComments()

        } else {
            self.simpleAlert("\(error!.localizedDescription)")
    }})
    

}
    
    
    
    
    
override func viewDidLoad() {
        super.viewDidLoad()

    self.title = "Comments"
    
    
    // Initialize a REFRESH BarButton Item
    let butt = UIButton(type: UIButtonType.custom)
    butt.adjustsImageWhenHighlighted = false
    butt.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
    butt.setBackgroundImage(UIImage(named: "refreshButt"), for: .normal)
    butt.addTarget(self, action: #selector(refreshComments), for: .touchUpInside)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: butt)


    
    // Init a keyboard toolbar to send Comments
    let toolbar = UIView(frame: CGRect(x: 0, y: view.frame.size.height+44, width: view.frame.size.width, height: 48))
    toolbar.backgroundColor = UIColor(red: 255/255, green: 225/255, blue: 76/255, alpha: 1)
    
    let sendButt = UIButton(frame: CGRect(x: toolbar.frame.size.width - 100, y: 0, width: 44, height: 44))
    sendButt.setBackgroundImage(UIImage(named: "send_comment_butt"), for: .normal)
    sendButt.addTarget(self, action: #selector(sendCommentButt(_:)), for: UIControlEvents.touchUpInside)
    toolbar.addSubview(sendButt)
    
    let dismissButt = UIButton(frame: CGRect(x: toolbar.frame.size.width - 60, y: 0, width: 44, height: 44))
    dismissButt.setBackgroundImage(UIImage(named: "dismissButt"), for: .normal)
    dismissButt.addTarget(self, action: #selector(dismissKeyboard), for: UIControlEvents.touchUpInside)
    toolbar.addSubview(dismissButt)
    
    commentTxt.frame = CGRect(x: 8, y: 4, width: toolbar.frame.size.width - 120, height: 32)
    commentTxt.backgroundColor = UIColor.white
    commentTxt.textColor = UIColor.black
    commentTxt.font = UIFont(name: "HelveticaNeue-Light", size: 13)
    commentTxt.clipsToBounds = true
    commentTxt.layer.cornerRadius = 5
    commentTxt.keyboardAppearance = .dark
    commentTxt.autocapitalizationType = .none
    commentTxt.autocorrectionType = .no
    toolbar.addSubview(commentTxt)
    
    fakeTxt.inputAccessoryView = toolbar
}

// REFRESH COMMENTS
@objc func refreshComments() { queryComments() }
    
    
    
    
    
    
    
// MARK: - QUERY COMMENTS
@objc func queryComments() {
    showHUD()

    let query = PFQuery(className: COMMENTS_CLASS_NAME)
    query.whereKey(COMMENTS_RECIPE_POINTER, equalTo: recipeObj)
    query.order(byDescending: "createdAt")
    query.findObjectsInBackground { (objects, error)-> Void in
        if error == nil {
            self.commentsArray = objects!
            self.commentsTableView.reloadData()
            self.hideHUD()
            
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    }}
}
    
    
// MARK: - COMMENTS TABLEVIEW DELEGATES
func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return commentsArray.count
}
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
    
    cell.mainView.layer.cornerRadius = 10
    cell.mainView.layer.shadowOpacity = 1
    cell.mainView.layer.shadowRadius = 5.0
    cell.mainView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
    cell.mainView.layer.masksToBounds = false
    cell.mainView.layer.shadowPath = UIBezierPath(roundedRect: cell.mainView.bounds, cornerRadius: cell.mainView.layer.cornerRadius).cgPath
    cell.mainView.layer.shadowColor = UIColor(red: 128.0/255, green: 128.0/255, blue: 128.0/255, alpha: 1.0).cgColor
    
    let commRecord = commentsArray[indexPath.row]
   
    // Get userPointer
    let userPointer = commRecord[COMMENTS_USER_POINTER] as! PFUser
    userPointer.fetchIfNeededInBackground { (user, error) in
    
        cell.cFullnameLabel.text = "\(userPointer[USER_FULLNAME]!)"
            
        // Get image
        cell.cAvatarImage.image = UIImage(named: "logo")
        let avFile = userPointer[USER_AVATAR] as? PFFile
        avFile?.getDataInBackground(block: { (imageData, error) -> Void in
            if error == nil {
                if let imageData = imageData {
                    cell.cAvatarImage.image = UIImage(data:imageData)
        }}})
        cell.cAvatarImage.layer.cornerRadius = cell.cAvatarImage.bounds.size.width/2
            
        // Get comment
        cell.cTxtView.text = "\(commRecord[COMMENTS_COMMENT]!)"
            
        // Get Date
        let date = commRecord.createdAt
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM dd yyyy, hh:mm"
        cell.cDateLabel.text = dateFormat.string(from: date!)
    }
    
    
return cell
}
    
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return  86
}
    
    
// MARK: -  CELL HAS BEEN TAPPED -> SHOW USER PROFILE
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let commRecord = commentsArray[indexPath.row]

    // Get userPointer & show its profile
    let userPointer = commRecord[COMMENTS_USER_POINTER] as! PFUser
    userPointer.fetchIfNeededInBackground { (user, error) in

        let oupVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserProfile") as! OtherUserProfile
        oupVC.otherUserObj = userPointer
        _ = self.navigationController?.pushViewController(oupVC, animated: true)
    }
}
    
    
    
    
    
// MARK: - TEXTFIELD DELEGATES
func textFieldDidBeginEditing(_ textField: UITextField) {
    commentTxt.becomeFirstResponder()
}
func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    commentTxt.becomeFirstResponder()
return true
}
    
    
    
    
    
// MARK: - SEND COMMENT BUTTON
@objc func sendCommentButt(_ sender:UIButton) {
    if PFUser.current() != nil {
    dismissKeyboard()
    showHUD()
    
    let commRecord = PFObject(className: COMMENTS_CLASS_NAME)
    
    // Save comment
    commRecord[COMMENTS_USER_POINTER] = PFUser.current()!
    commRecord[COMMENTS_RECIPE_POINTER] = recipeObj
    commRecord[COMMENTS_COMMENT] = commentTxt.text
    
    
    commRecord.saveInBackground { (succ, error) in
        if error == nil {
            self.hideHUD()
            
            
            // Increment comments amount of this Recipe
            self.recipeObj.incrementKey(RECIPES_COMMENTS, byAmount: 1)
            self.recipeObj.saveInBackground()
            
            
            
            // Send Push Notification
            let pushStr = "\(PFUser.current()![USER_FULLNAME]!) commented your Recipe: \(self.recipeObj[RECIPES_TITLE]!)"
            
            let data = [ "badge" : "Increment",
                         "alert" : pushStr,
                         "sound" : "bingbong.aiff"
                        ]
            let request = [
                "someKey" : self.recipeUser.objectId!,
                "data" : data
                ] as [String : Any]
            PFCloud.callFunction(inBackground: "push", withParameters: request as [String : Any], block: { (results, error) in
                if error == nil {
                    print ("\nPUSH SENT TO: \(self.recipeUser[USER_USERNAME]!)\nMESSAGE: \(pushStr)\n")
                } else {
                    print ("\(error!.localizedDescription)")
                }
            })
            
            

            // Save Activity
            let activityClass = PFObject(className: ACTIVITY_CLASS_NAME)
            activityClass[ACTIVITY_CURRENT_USER] = self.recipeUser
            activityClass[ACTIVITY_OTHER_USER] = PFUser.current()!
            activityClass[ACTIVITY_TEXT] = "\(PFUser.current()![USER_FULLNAME]!) commented your Recipe: \(self.recipeObj[RECIPES_TITLE]!)"
            activityClass.saveInBackground(block: { (succ, error) in
                if error == nil {
                    print("NEW ACTIVITY SAVED!")
                    
                    // Lastly refresh commentsTableView
                    Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.queryComments), userInfo: nil, repeats: false)
                    
                } else {  self.simpleAlert("\(error!.localizedDescription)")
            }})
            
            
        // error
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    }}
    }
    else{
        
        let alert = UIAlertController(title: APP_NAME,
            message: "You must login/sign up to comment on a recipe!",
            preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction(title: "Login", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
            self.present(loginVC, animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in })
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        
    }
}
    
    
    
// MARK: - DISMISS KEYBAORD
@objc func dismissKeyboard() {
    fakeTxt.resignFirstResponder()
    commentTxt.resignFirstResponder()
}
    
    

    

    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}





