/*-----------------------------------
 
 - Recipes -
 
 Created by ElTech ©2017
 All Rights reserved
 
 -----------------------------------*/

import UIKit
import Parse
import GoogleMobileAds
import AudioToolbox
import IQDropDownTextField

class AddEditRecipe: UIViewController,
UITextFieldDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIScrollViewDelegate,
GADBannerViewDelegate
{

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    /* Views */
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var categoryTxt: IQDropDownTextField!
    @IBOutlet weak var storyTxt: UITextView!
    @IBOutlet var difficultyButtons: [UIButton]!
    @IBOutlet weak var cookingTxt: UITextField!
    @IBOutlet weak var bakingTxt: UITextField!
    @IBOutlet weak var restingTxt: UITextField!
    @IBOutlet weak var youtubeTxt: UITextField!
    @IBOutlet weak var videoTitleTxt: UITextField!
    @IBOutlet weak var ingredientsTxt: UITextView!
    @IBOutlet weak var preparationTxt: UITextView!
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var submitOutlet: UIButton!
    
    @IBOutlet weak var conBottomPageControl: NSLayoutConstraint!
    
    //Ad banners properties
    var adMobBannerView = GADBannerView()
    
    /* Variables */
    var recipeObj = PFObject(className: RECIPES_CLASS_NAME)
    var likesArray = [PFObject]()
    var difficultyStr = ""
    

override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.addGradientNavigationBar(colors: [ThemeColor, GredientLightColor], angle: 135)
    
    categoryTxt.itemList = categoriesArray
    
    // Check if your Adding or Editing a recipe
    if recipeObj[RECIPES_TITLE] == nil {
        self.title = "Add New Recipe"
        submitOutlet.setTitle("Submit your Recipe!", for: .normal)
        self.navigationItem.rightBarButtonItem = nil
        difficultyStr = ""

    } else {
        self.title = "Edit Recipe"
        submitOutlet.setTitle("Update your Recipe", for: .normal)
        showRecipeDetails()
    }
    
    // Init ad banners
    initAdMobBanner()
}
    
// MARK: - SHOW RECIPE DETAILS
func showRecipeDetails() {
    titleTxt.text = "\(recipeObj[RECIPES_TITLE]!)"
    storyTxt.text = "\(recipeObj[RECIPES_ABOUT]!)"
    if recipeObj[RECIPES_YOUTUBE] != nil { youtubeTxt.text = "\(recipeObj[RECIPES_YOUTUBE]!)"
    } else { youtubeTxt.text = "" }
    if recipeObj[RECIPES_VIDEO_TITLE] != nil { videoTitleTxt.text = "\(recipeObj[RECIPES_VIDEO_TITLE]!)"
    } else { videoTitleTxt.text = ""  }
    cookingTxt.text = "\(recipeObj[RECIPES_COOKING]!)"
    bakingTxt.text = "\(recipeObj[RECIPES_BAKING]!)"
    restingTxt.text = "\(recipeObj[RECIPES_RESTING]!)"
    ingredientsTxt.text = "\(recipeObj[RECIPES_INGREDIENTS]!)"
    preparationTxt.text = "\(recipeObj[RECIPES_PREPARATION]!)"
    
    categoryTxt.selectedItem = "\(recipeObj[RECIPES_CATEGORY]!)"
    
    // Set difficulty button
    difficultyStr = "\(recipeObj[RECIPES_DIFFICULTY]!)"
    for butt in difficultyButtons {
        if butt.titleLabel?.text == difficultyStr {
            butt.setTitleColor(UIColor.white, for: .normal)
            butt.backgroundColor = ThemeColor
        }
    }
    
    // Get image
    let imageFile = recipeObj[RECIPES_COVER] as? PFFile
    imageFile?.getDataInBackground(block: { (imageData, error) -> Void in
        if error == nil {
            if let imageData = imageData {
                self.coverImage.image = UIImage(data:imageData)
    } } })
}

    
// MARK: - DIFFICULTY BUTTONS
@IBAction func difficultyButt(_ sender: AnyObject) {
    let butt = sender as! UIButton
    for butt in difficultyButtons {
        butt.setTitleColor(UIColor.black, for: .normal)
        butt.backgroundColor = .lightGray
    }
    
    difficultyStr = butt.titleLabel!.text!
    print("SEL. DIFFICULTY: \(difficultyStr)")
    
    butt.setTitleColor(UIColor.white, for: .normal)
    butt.backgroundColor = ThemeColor
}
  
    
    
    
// MARK: - UPLOAD COVER IMAGE BUTTON
@IBAction func uploadPicButt(_ sender: AnyObject) {
    let alert = UIAlertController(title: APP_NAME,
        message: "Select source",
        preferredStyle: .alert)
    
    let camera = UIAlertAction(title: "Take a picture", style: .default, handler: { (action) -> Void in
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    })
    
    let library = UIAlertAction(title: "Pick from Library", style: .default, handler: { (action) -> Void in
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.navigationBar.isTranslucent = false
            imagePicker.navigationBar.barTintColor = .black // Background color
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
        coverImage.image = scaleImageToMaxWidth(image: pickedImage, newWidth: 700)
    }
    dismiss(animated: true, completion: nil)
}
    
    
// MARK: - SUBMIT/DELETE YOUR RECIPE
    @IBAction func btn1Next(_ sender: Any) {
        if titleTxt.text == "" || categoryTxt.selectedItem == "" || storyTxt.text == "" {
            self.simpleAlert("You must fill all the required fields!")
            return
        }
        mainScrollView.setContentOffset(CGPoint.init(x: mainScrollView.frame.size.width, y: 0), animated: true)
        pageControl.currentPage = 1
    }
    
    @IBAction func btn2Next(_ sender: Any) {
        if difficultyStr == "" || cookingTxt.text == "" || bakingTxt.text == "" ||
            restingTxt.text == "" || ingredientsTxt.text == "" || preparationTxt.text == "" {
            self.simpleAlert("You must fill all the required fields!")
            return
        }
        mainScrollView.setContentOffset(CGPoint.init(x: mainScrollView.frame.size.width * 2, y: 0), animated: true)
        pageControl.currentPage = 2
    }
    
@IBAction func submitButt(_ sender: AnyObject) {
    if titleTxt.text == "" || categoryTxt.selectedItem == "" || storyTxt.text == "" {
        
        self.simpleAlert("You must fill all the required fields!"){
            self.mainScrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            self.pageControl.currentPage = 0
        }
        return
    }
    if difficultyStr == "" || cookingTxt.text == "" || bakingTxt.text == "" ||
        restingTxt.text == "" || ingredientsTxt.text == "" || preparationTxt.text == "" {
        
        self.simpleAlert("You must fill all the required fields!") {
            self.mainScrollView.setContentOffset(CGPoint.init(x: self.mainScrollView.frame.size.width, y: 0), animated: true)
            self.pageControl.currentPage = 1
        }
        return
    }
    if coverImage.image == nil {
        self.simpleAlert("You must fill all the required fields!")
        return
    }
    
    showHUD()
    
    let currentUser = PFUser.current()
    recipeObj[RECIPES_USER_POINTER] = currentUser
    recipeObj[RECIPES_TITLE] = titleTxt.text
    recipeObj[RECIPES_TITLE_LOWERCASE] = titleTxt.text!.lowercased()
    
    // Save keywords
    let keywords = titleTxt.text!.lowercased().components(separatedBy: " ")
    recipeObj[RECIPES_KEYWORDS] = keywords
    
    recipeObj[RECIPES_CATEGORY] = categoryTxt.selectedItem
    recipeObj[RECIPES_ABOUT] = storyTxt.text
    recipeObj[RECIPES_DIFFICULTY] = difficultyStr
    recipeObj[RECIPES_COOKING] = cookingTxt.text
    recipeObj[RECIPES_BAKING] = bakingTxt.text
    recipeObj[RECIPES_RESTING] = restingTxt.text
    if youtubeTxt.text != "" { recipeObj[RECIPES_YOUTUBE] = youtubeTxt.text
    } else { recipeObj[RECIPES_YOUTUBE] = "" }
    if videoTitleTxt.text != "" { recipeObj[RECIPES_VIDEO_TITLE] = videoTitleTxt.text
    } else { recipeObj[RECIPES_VIDEO_TITLE] = "" }
    recipeObj[RECIPES_INGREDIENTS] = ingredientsTxt.text
    recipeObj[RECIPES_PREPARATION] = preparationTxt.text
    recipeObj[RECIPES_IS_REPORTED] = false
    recipeObj[RECIPES_COMMENTS] = 0
    recipeObj[RECIPES_LIKES] = 0

    // Save Image (if exists)
    if coverImage.image != nil {
        let imageData = UIImageJPEGRepresentation(coverImage.image!, 0.8)
        let imageFile = PFFile(name:"cover.jpg", data:imageData!)
        recipeObj[RECIPES_COVER] = imageFile
    }
    

    // Saving block
    recipeObj.saveInBackground { (success, error) -> Void in
        if error == nil {
            
            self.simpleAlert("You've successfully submitted your recipe!") {
                self.navigationController?.popViewController(animated: true)
            }
            self.hideHUD()
    
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    }}
}
    
  
 
// MARK: - DELETE RECIPE BUTTON
@IBAction func btnDelete(_ sender: Any) {
    let alert = UIAlertController.init(title: "Delete", message: "Are you sure want to delete this recipe?", preferredStyle: .alert)
    alert.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (btn) in
        self.deleteRecipe()
    }))
    alert.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil)
}
    
func deleteRecipe () {
    likesArray.removeAll()
    
    // DELETE ALL LIKES
    let query = PFQuery(className: LIKES_CLASS_NAME)
    query.whereKey(LIKES_RECIPE_LIKED, equalTo: recipeObj)
    query.findObjectsInBackground { (objects, error)-> Void in
        if error == nil {
            self.likesArray = objects!
            
            DispatchQueue.main.async(execute: {
                if self.likesArray.count > 0 {
                    for i in 0..<self.likesArray.count {
                        var likesClass = PFObject(className: LIKES_CLASS_NAME)
                        likesClass = self.likesArray[i]
                        likesClass.deleteInBackground()
                    }
                }
            })
            
            
        // DELETE RECIPE
        self.recipeObj.deleteInBackground {(success, error) -> Void in
            if error == nil {
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                self.simpleAlert("\(error!.localizedDescription)")
        }}
        
    }}
   
}
    
    
    
    
// MARK: - BACK BUTTON
@IBAction func btnBack(_ sender: Any) {
    let alert = UIAlertController.init(title: "Warning", message: "Are you sure want to back?\n.All form data will erase.", preferredStyle: .alert)
    alert.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (btn) in
        self.navigationController?.popViewController(animated: true)
    }))
    alert.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil)
}

//MARK: - SCROLL VIEW
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == mainScrollView {
        let pageWidth = scrollView.frame.size.width
        let fractionalPage = scrollView.contentOffset.x / pageWidth
        let page = lround(Double(fractionalPage))
        pageControl.currentPage = page
    }
}

// MARK: - TEXT FIELD DELEGATE
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == titleTxt { titleTxt.resignFirstResponder() }
    if textField == cookingTxt { bakingTxt.becomeFirstResponder() }
    if textField == bakingTxt { restingTxt.becomeFirstResponder() }
    if textField == restingTxt { youtubeTxt.becomeFirstResponder() }
    if textField == youtubeTxt { videoTitleTxt.becomeFirstResponder() }
    if textField == videoTitleTxt { videoTitleTxt.resignFirstResponder() }
    
return true
}
  
    
// MARK: - ADMOB BANNER METHODS
func initAdMobBanner() {
    adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
    adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: self.view.bounds.size.width, height: 50)
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
        conBottomPageControl.constant = 0
        self.view.layoutIfNeeded()
        UIView.commitAnimations()
        banner.isHidden = true
    }
    
    // Show the banner
    func showBanner(_ banner: UIView) {
        let h : CGFloat = CommonUtils.hasTopNotch() ? 34.0 : 0.0
        
        UIView.beginAnimations("showBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2,
                              y: view.frame.size.height - banner.frame.size.height - h,
                              width: banner.frame.size.width, height: banner.frame.size.height);
        conBottomPageControl.constant = 50
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
        // Dispose of any resources that can be recreated.
    }
}
