/*-----------------------------------
 
 - Recipes -
 
 Created by ElTech ©2017
 All Rights reserved
 
 -----------------------------------*/

import UIKit
import Parse
import GoogleMobileAds
import AudioToolbox

class RecipeDetails: UIViewController,
GADBannerViewDelegate
{

    /* Views */
    @IBOutlet weak var coverImage: UIImageView!
        
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var aboutReceipeLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    
    @IBOutlet weak var cookingLabel: UILabel!
    @IBOutlet weak var bakingLabel: UILabel!
    @IBOutlet weak var restingLabel: UILabel!
    
    @IBOutlet weak var videoWebView: UIWebView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    
    @IBOutlet weak var ingredientsTxt: UILabel!
    @IBOutlet weak var preparationTxt: UILabel!
    
    @IBOutlet weak var conHeightWebView: NSLayoutConstraint!
    @IBOutlet weak var conBottomBtnAdd: NSLayoutConstraint!
    
    //Ad banners properties
    var adMobBannerView = GADBannerView()
    
    /* Variables */
    var recipeObj = PFObject(className: RECIPES_CLASS_NAME)
    var ingredientsArray:[String] = []
    var likesArray = [PFObject]()

    
    
    
    
override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge()
    self.title = "RECIPE"
    
    // Init ad banners
    initAdMobBanner()
    
    
    // Show recipe details
    showRecipeDetails()
}

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true  //Hide
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false  //Show
    }
    
    
    
// MARK: - SHOW RECIPE DETAILS
func showRecipeDetails() {
    let userPointer = recipeObj[RECIPES_USER_POINTER] as! PFUser
    userPointer.fetchIfNeededInBackground { (user, error) in
        if error == nil {
            
            // Get cover image
            let imageFile = self.recipeObj[RECIPES_COVER] as? PFFile
            imageFile?.getDataInBackground(block: { (imageData, error) in
                if error == nil {
                    self.coverImage.image = UIImage(data:imageData!)
            }})
    
            // Get Title and Category
            self.titleLabel.text = "\(self.recipeObj[RECIPES_TITLE]!)"
            self.categoryLabel.text = "\(self.recipeObj[RECIPES_CATEGORY]!)"
    
            // Get Likes
            if self.recipeObj[RECIPES_LIKES] != nil {
                let likes = self.recipeObj[RECIPES_LIKES] as! Int
                self.likesLabel.text = likes.abbreviated
            } else { self.likesLabel.text = "0" }
    
            
            // Get Comments
            if self.recipeObj[RECIPES_COMMENTS] != nil {
                let comments = self.recipeObj[RECIPES_COMMENTS] as! Int
                self.commentsLabel.text = comments.abbreviated
            } else { self.commentsLabel.text = "0" }

            
            // Get User's details
            if userPointer[USER_JOB] != nil {
                self.userFullNameLabel.text = "\(userPointer[USER_FULLNAME]!) (\(userPointer[USER_JOB]!))"
            }
            else {
                self.userFullNameLabel.text = "\(userPointer[USER_FULLNAME]!)"
            }

    
            // Get avatar image
            self.avatarImage.image = UIImage(named: "logo")
            let avatarFile = userPointer[USER_AVATAR] as? PFFile
            avatarFile?.getDataInBackground(block: { (imageData, error) -> Void in
                if error == nil {
                    self.avatarImage.image = UIImage(data:imageData!)
            }})
    
    
            self.aboutReceipeLabel.text = "\(self.recipeObj[RECIPES_ABOUT]!)"
            self.difficultyLabel.text = "Difficulty: \(self.recipeObj[RECIPES_DIFFICULTY]!)"
            
            self.cookingLabel.text = "Cooking\n\(self.recipeObj[RECIPES_COOKING]!)"
            self.bakingLabel.text = "Baking\n\(self.recipeObj[RECIPES_BAKING]!)"
            self.restingLabel.text = "Resting\n\(self.recipeObj[RECIPES_RESTING]!)"

            var isVideo = false
            // Get video
            if self.recipeObj[RECIPES_YOUTUBE] != nil {
                if "\(self.recipeObj[RECIPES_YOUTUBE]!)" != "" {
                    let youtubeLink = "\(self.recipeObj[RECIPES_YOUTUBE]!)"
                    let videoId = youtubeLink.replacingOccurrences(of: "https://youtu.be/", with: "")
                    let embedHTML = "<iframe width='\(self.videoWebView.frame.size.width)' height='\(self.videoWebView.frame.size.height)' src='https://www.youtube.com/embed/\(videoId)?rel=0&amp;controls=0&amp;showinfo=0' frameborder='0' allowfullscreen></iframe>"
                    self.videoWebView.loadHTMLString(embedHTML, baseURL: nil)
                    isVideo = true
                }
            }
                
            if !isVideo{
                    self.videoTitleLabel.text = "No video Available"
                    self.videoWebView.isHidden = true
                    self.conHeightWebView.constant = 0
                    self.view.layoutIfNeeded()
            }
    
            if let text = self.recipeObj[RECIPES_VIDEO_TITLE] as? String, text.count != 0{
                self.videoTitleLabel.text = text
            }
    
            // Get Ingredients and make an array (for your Shopping List)
            self.ingredientsTxt.text = "\(self.recipeObj[RECIPES_INGREDIENTS]!)"
            self.ingredientsArray = self.ingredientsTxt.text?.components(separatedBy: "\n") ?? []
    
            // Get Preparstion Steps
            self.preparationTxt.text = "\(self.recipeObj[RECIPES_PREPARATION]!)"
            
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
        }
    
    }
}
    
    
    
// MARK: - LIKE RECIPE BUTTON
@IBAction func likeButt(_ sender: AnyObject) {
    // USER IS LOGGED IN
    if PFUser.current() != nil {
                
        // Query Likes
        likesArray.removeAll()
        let query = PFQuery(className: LIKES_CLASS_NAME)
        query.whereKey(LIKES_LIKED_BY, equalTo: PFUser.current()!)
        query.whereKey(LIKES_RECIPE_LIKED, equalTo: recipeObj)
        query.findObjectsInBackground { (objects, error)-> Void in
            if error == nil {
                self.likesArray = objects!
                print("LIKES ARRAY: \(self.likesArray)")
                
                var likesClass = PFObject(className: LIKES_CLASS_NAME)
                
                if self.likesArray.count == 0 {
                    
                
                // LIKE RECIPE
                self.recipeObj.incrementKey(RECIPES_LIKES, byAmount: 1)
                self.recipeObj.saveInBackground()
                let likeInt = self.recipeObj[RECIPES_LIKES] as! Int
                self.likesLabel.text = likeInt.abbreviated
                    
                likesClass[LIKES_LIKED_BY] = PFUser.current()
                likesClass[LIKES_RECIPE_LIKED] = self.recipeObj
                likesClass.saveInBackground(block: { (success, error) -> Void in
                    if error == nil {
                        self.simpleAlert("You've liked this recipe and saved into your Account!")
            
                        // Get User Pointer
                        let userPointer = self.recipeObj[RECIPES_USER_POINTER] as! PFUser
                        userPointer.fetchIfNeededInBackground(block: { (user, error) in
                        
                        
                            // Send Push Notification
                            let pushStr = "\(PFUser.current()![USER_FULLNAME]!) liked your \(self.recipeObj[RECIPES_TITLE]!) recipe!"
                            
                            let data = [ "badge" : "Increment",
                                         "alert" : pushStr,
                                         "sound" : "bingbong.aiff"
                            ]
                            let request = [
                                "someKey" : userPointer.objectId!,
                                "data" : data
                                ] as [String : Any]
                            PFCloud.callFunction(inBackground: "push", withParameters: request as [String : Any], block: { (results, error) in
                                if error == nil {
                                    print ("\nPUSH SENT TO: \(userPointer[USER_USERNAME]!)\nMESSAGE: \(pushStr)\n")
                                } else {
                                    print ("\(error!.localizedDescription)")
                            }})
                            
                            
                            
                            // Save activity
                            let activityClass = PFObject(className: ACTIVITY_CLASS_NAME)
                            activityClass[ACTIVITY_CURRENT_USER] = userPointer
                            activityClass[ACTIVITY_OTHER_USER] = PFUser.current()!
                            activityClass[ACTIVITY_TEXT] = "\(PFUser.current()![USER_FULLNAME]!) liked your \(self.recipeObj[RECIPES_TITLE]!) recipe"
                            activityClass.saveInBackground()
                        })
                }})
                   
                    
                    
                // UNLIKE RECIPE
                } else if self.likesArray.count > 0 {
                    self.recipeObj.incrementKey(RECIPES_LIKES, byAmount: -1)
                    self.recipeObj.saveInBackground()
                    let likeInt = self.recipeObj[RECIPES_LIKES] as! Int
                    self.likesLabel.text = likeInt.abbreviated
                    
                    likesClass = self.likesArray[0] 
                    likesClass.deleteInBackground {(success, error) -> Void in
                        if error == nil {
                            self.simpleAlert("You've unliked this recipe")
                    }}
                }
                
                
            // Error in query likes
            } else {
                self.simpleAlert("\(error!.localizedDescription)")
        }}
        
        
        
        
    // USER IS NOT LOGGED IN/REGISTERED
    } else {
        let alert = UIAlertController(title: APP_NAME,
            message: "You must login/sign up to like a recipe!",
            preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Login", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
            self.present(loginVC, animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
        })
        alert.addAction(ok); alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}

    
    
    
// MARK: - ADD INGREDIENTS TO SHOPPING LIST
@IBAction func addToShoppingButt(_ sender: AnyObject) {
    shoppingArray += ingredientsArray
    print("SHOPPING LIST in RecipeDetails: \(shoppingArray)")
    
    // Save shoppingArray
    let tempArr = shoppingArray
    defaults.set(tempArr, forKey: "tempArr")
    
    
    // Show an Alert
    let alert = UIAlertView(title: APP_NAME,
        message: "These ingredients have been saved into your Shopping List!",
        delegate: nil,
        cancelButtonTitle: "OK" )
    alert.show()
}
    
  
    
// MARK: - SHARE BUTTON
    @IBAction func btnShare(_ sender: Any) {
    let messageStr  = "I love this Recipe: \(recipeObj[RECIPES_TITLE]!), found on #\(APP_NAME)"
    
    let shareItems = [messageStr]
    let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
    activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
    
    if UIDevice.current.userInterfaceIdiom == .pad {
        // iPad
        let popOver = UIPopoverController(contentViewController: activityViewController)
        popOver.present(from: CGRect.zero, in: view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
    } else {
        // iPhone
        present(activityViewController, animated: true, completion: nil)
    }
}
    
    
    
    
// MARK: - COMMENT BUTTON
@IBAction func commentButt(_ sender: Any) {
    let aVC = storyboard?.instantiateViewController(withIdentifier: "Comments") as! Comments
    aVC.recipeObj = recipeObj
    navigationController?.pushViewController(aVC, animated: true)
}
    
// MARK: - BACK BUTTON
    @IBAction func btnBack(_ sender: Any) {
    _ = navigationController?.popViewController(animated: true)
}

    
// MARK: - REPORT RECIPE BUTTON
    @IBAction func btnReport(_ sender: Any) {
    
    let alert = UIAlertController(title: APP_NAME,
        message: "Tell us briefly why you're reporting this Recipe",
        preferredStyle: .alert)
    
    
    // REPORT A RECIPE
    let ok = UIAlertAction(title: "Report", style: .default, handler: { (action) -> Void in
        // TextField
        let textField = alert.textFields!.first!
        let txtStr = textField.text!
        
        self.recipeObj[RECIPES_IS_REPORTED] = true
        self.recipeObj[RECIPES_REPORT_MESSAGE] = txtStr
        self.recipeObj.saveInBackground(block: { (succ, error) in
            if error == nil {
                self.simpleAlert("Thanks for reporting this recipe!.\nWe'll check it out within 24h. Now please hit the refresh button")
                _ = self.navigationController?.popViewController(animated: true)
        }})
        
    })
    
    
    // CANCEL button
    let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
    
    // Add textField
    alert.addTextField { (textField: UITextField) in
        textField.keyboardAppearance = .dark
        textField.keyboardType = .default
    }
    
    alert.addAction(ok)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
}
    
    
    
    
    
    
    
    
    
// MARK: - ADMOB BANNER METHODS
    func initAdMobBanner() {
        adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
        adMobBannerView.frame = CGRect(x: 0, y: self.view.bounds.size.height, width: self.view.bounds.size.width, height: 50)
        adMobBannerView.adUnitID = ADMOB_BANNER_UNIT_ID
        adMobBannerView.rootViewController = self
        adMobBannerView.delegate = self
        view.addSubview(adMobBannerView)
        let request = GADRequest()
        adMobBannerView.load(request)
    }
    
    
    // Hide the banner
    func hideBanner(_ banner: UIView) {
        UIView.beginAnimations("hideBanner", context: nil)
        
        banner.frame = CGRect(x: 0, y: self.view.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        conBottomBtnAdd.constant = 0
        self.view.layoutIfNeeded()
        UIView.commitAnimations()
        banner.isHidden = true
        
    }
    
    // Show the banner
    func showBanner(_ banner: UIView) {
        let h : CGFloat = CommonUtils.hasTopNotch() ? 34 : 0
        
        UIView.beginAnimations("showBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2,
                              y: view.frame.size.height - banner.frame.size.height - h,
                              width: banner.frame.size.width, height: banner.frame.size.height);
        conBottomBtnAdd.constant = 50
        self.view.layoutIfNeeded()
        UIView.commitAnimations()
        banner.isHidden = false
    }
    


    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView) {
        print("AdMob loaded!")
        showBanner(adMobBannerView)
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("AdMob Can't load ads right now, they'll be available later \n\(error)")
        hideBanner(adMobBannerView)
    }
    
    
    

    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
