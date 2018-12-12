//
//  LandmarkDetailViewController.swift
//  Metro Explorer
//
//  Created by hct0704 on 12/10/18.
//  Copyright © 2018 hct0704. All rights reserved.
//

import UIKit
import MBProgressHUD

class LandmarkDetailViewController: UIViewController {
    
    var landmark:Landmark?
    var flag: String = ""
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var AddressButtonText: UIButton!
    @IBAction func AddressButtonPressed(_ sender: Any) {
        if let link = URL(string: "http://maps.apple.com/?daddr=\(landmark!.latitude),\(landmark!.longitude)&dirflg=r"){
            UIApplication.shared.open(link, options: [:], completionHandler: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        //display the landmark detail
        if let urlString = landmark?.imageUrl, let url = URL(string: urlString){
            detailImage.load(url: url)
        }
        
        let rating = landmark?.rating ?? 0.0
        nameLabel?.text = landmark?.name
        ratingLabel?.text = ("Rating: \(rating)")

        //change button content to landmark address
        AddressButtonText.setTitle(landmark?.location.displayAddress.joined(separator: ", "), for: UIControl.State.normal)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
/*    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        <#code#>
    }
*/
    @IBAction func shareButtonPressed(_ sender: Any) {
        let shareText = "Check out this landmark: \(landmark?.name) \(landmark?.location.displayAddress.joined(separator: ", "))"
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        if PersistenceManager.sharedInstance.checkFavorite(landmark: landmark!){
            PersistenceManager.sharedInstance.removeLandmarks(landmark: landmark!)
        }else{
            PersistenceManager.sharedInstance.saveLandmarks(landmark: landmark!)
        }
    }

}
