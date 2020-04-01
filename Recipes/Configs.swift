/*-----------------------------------
 
 - Recipes -
 
 Created by ElTech ©2017
 All Rights reserved
 
 -----------------------------------*/

import Foundation
import UIKit
import Parse



// IMPORTANT: Replace the red string below accordingly to the new name you'll give to this app
let APP_NAME = "Enebla"


// PARSE KEYS -> Replace these red keys with your own ones from your Parse app on back4app.com
let PARSE_APP_KEY = "wWMulZnH1Xiy56R8JbwxJtn5akaLVxW4dg5UmTxz"
let PARSE_CLIENT_KEY = "xTsSDZ5CO2HaD0MN1jZ2iRup10sYFHmz1CwBnIxO"



// IMPORTANT: REPLACE THE RED STRING BELOW WITH THE UNIT ID YOU'VE GOT BY REGISTERING YOUR APP IN http://www.apps.admob.com
let ADMOB_BANNER_UNIT_ID = "ca-app-pub-3453913475502605/1028766550"



// FOOD CATEGORIES ARRAY (editable)
let categoriesArray =  [
    "Appetizer",
    "Breakfast",
    "Healthy",
    "Holidays & Events",
    "Main Dish",
    "Seafood",
    "Vegetarian",
    "Salad",
    "Desserts",
    "Beverage",
    
    // You can add categories here...
    // IMPORTANT: Also remember to add the proper images into the FOOD CATEGORIES folder in Assets.xcassets, naming them exactly like the red strings above!
    
]


// MARK: - List of Constants
let userDefault             = UserDefaults.standard
let appDelegate             = (UIApplication.shared.delegate as! AppDelegate)

let RateLink                = ""

// Custom yellow color
let yellow = UIColor(red: 247/255.0, green: 252/255.0, blue: 142/255.0, alpha: 1.0)
let ThemeColor = UIColor.init(red: 16/255.0, green: 112/255.0, blue: 4/255.0, alpha: 1.0)
let GredientLightColor = UIColor.init(red: 76/255.0, green: 187/255.0, blue: 23/255.0, alpha: 1.0)


// HUD VIEW
var hudView = UIView()
var animImage = UIImageView(frame: CGRect(x: 15, y: 15, width: 50, height: 50))
extension UIViewController {
    func showHUD() {
        hudView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        hudView.center = self.view.center
        hudView.backgroundColor = ThemeColor
        hudView.addGradient(colors: [ThemeColor, GredientLightColor], angle: 135)
        hudView.clipsToBounds = true
        hudView.layer.cornerRadius = hudView.bounds.size.width/2
        
        let imagesArr = ["hud1", "hud2", "hud3", "hud4", "hud5", "hud6", "hud7", "hud8", "hud9", "hud10", "hud11", "hud12"]
        var images:[UIImage] = []
        for i in 0..<imagesArr.count {
            images.append(UIImage(named: imagesArr[i])!)
        }
        animImage.animationImages = images
        animImage.animationDuration = 1.25
        hudView.addSubview(animImage)
        animImage.startAnimating()
        view.addSubview(hudView)
    }
    
    func hideHUD() {  hudView.removeFromSuperview()  }
    
    func simpleAlert(_ message:String, completion : (() -> Void)? = nil) {
        let alert = UIAlertController(title: APP_NAME, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: { (btn) in
            if completion != nil{
                completion!()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}






extension UIImageView{
    func roundedImageTop(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedImageBottom(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomLeft , .bottomRight],
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func roundedImageBoth(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomLeft , .bottomRight, .topLeft , .topRight],
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

extension UIView{
    func roundedViewBottom(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomLeft , .bottomRight],
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedViewTop(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func roundedViewBoth(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .topRight,.bottomLeft , .bottomRight],
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

extension UIScrollView{
    func roundedScrollViewBottom(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomLeft , .bottomRight],
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedScrollViewTop(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func roundedScrollViewBoth(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .topRight,.bottomLeft , .bottomRight],
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}






/****** DO NOT EDIT THE CODE BELOW *****/
let USER_CLASS_NAME = "_User"
let USER_FULLNAME = "fullName"
let USER_USERNAME = "username"
let USER_AVATAR = "avatar"
let USER_EMAIL = "email"
let USER_JOB = "job"
let USER_ABOUTME = "aboutMe"
let USER_IS_REPORTED = "isReported"
let USER_REPORT_MESSAGE = "reportMessage"


let LIKES_CLASS_NAME = "Likes"
let LIKES_LIKED_BY = "likedBy"
let LIKES_RECIPE_LIKED = "recipeLiked"


let RECIPES_CLASS_NAME = "Recipes"
let RECIPES_COVER = "cover"
let RECIPES_TITLE = "title"
let RECIPES_TITLE_LOWERCASE = "titleLowercase"
let RECIPES_CATEGORY = "category"
let RECIPES_LIKES = "likes"
let RECIPES_ABOUT = "aboutRecipe"
let RECIPES_DIFFICULTY = "difficulty"
let RECIPES_COOKING = "cooking"
let RECIPES_BAKING = "baking"
let RECIPES_RESTING = "resting"
let RECIPES_YOUTUBE = "youtube"
let RECIPES_VIDEO_TITLE = "videoTitle"
let RECIPES_INGREDIENTS = "ingredients"
let RECIPES_PREPARATION = "preparation"
let RECIPES_USER_POINTER = "userPointer"
let RECIPES_IS_REPORTED = "isReported"
let RECIPES_REPORT_MESSAGE = "reportMessage"
let RECIPES_COMMENTS = "comments"
let RECIPES_KEYWORDS = "keywords"

let ACTIVITY_CLASS_NAME = "Activity"
let ACTIVITY_CURRENT_USER = "currentUser"
let ACTIVITY_OTHER_USER = "otherUser"
let ACTIVITY_TEXT = "text"

let COMMENTS_CLASS_NAME = "Comments"
let COMMENTS_RECIPE_POINTER = "recipePointer"
let COMMENTS_USER_POINTER = "userPointer"
let COMMENTS_COMMENT = "comment"


let defaults = UserDefaults.standard
var currentUser = PFUser.current()
var justSignedUp = false




// MARK: - EXTENSION TO RESIZE A UIIMAGE
extension UIViewController {
    func scaleImageToMaxWidth(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}



// EXTENSION TO FORMAT LARGE NUMBERS INTO K OR M (like 1.1M, 2.5K)
extension Int {
    var abbreviated: String {
        let abbrev = "KMBTPE"
        return abbrev.enumerated().reversed().reduce(nil as String?) { accum, tuple in
            let factor = Double(self) / pow(10, Double(tuple.0 + 1) * 3)
            let format = (factor.truncatingRemainder(dividingBy: 1)  == 0 ? "%.0f%@" : "%.1f%@")
            return accum ?? (factor > 1 ? String(format: format, factor, String(tuple.1)) : nil)
            } ?? String(self)
    }
}


