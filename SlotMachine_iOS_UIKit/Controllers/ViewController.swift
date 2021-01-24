//
//  ViewController.swift
//  SlotMachine_iOS_UIKit
//
//  Created by Abdelrahman  Tealab on 2021-01-22.
//

import UIKit
import Spruce

class ViewController: UIViewController {

    
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var jackpotLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var winJackpotImage: UIImageView!
    
    
    @IBOutlet weak var leftTopImage: UIImageView!
    @IBOutlet weak var leftMiddleImage: UIImageView!
    @IBOutlet weak var leftBottomImage: UIImageView!
    @IBOutlet weak var centerTopImage: UIImageView!
    @IBOutlet weak var centerMiddleImage: UIImageView!
    @IBOutlet weak var centerBottomImage: UIImageView!
    @IBOutlet weak var rightTopImage: UIImageView!
    @IBOutlet weak var rightMiddleImage: UIImageView!
    @IBOutlet weak var rightBottomImage: UIImageView!
    
    @IBOutlet weak var leftFrame: UIImageView!
    @IBOutlet weak var centerFrame: UIImageView!
    @IBOutlet weak var rightFrame: UIImageView!
    
    let leftReel:Array<UIImage> = [#imageLiteral(resourceName: "icon_1"),#imageLiteral(resourceName: "icon_2"),#imageLiteral(resourceName: "icon_3"),#imageLiteral(resourceName: "icon_4"),#imageLiteral(resourceName: "icon_5"),#imageLiteral(resourceName: "icon_6"),#imageLiteral(resourceName: "icon_7"),#imageLiteral(resourceName: "icon_8")]
    let centerReel:Array<UIImage> = [#imageLiteral(resourceName: "icon_6"),#imageLiteral(resourceName: "icon_7"),#imageLiteral(resourceName: "icon_8"),#imageLiteral(resourceName: "icon_1"),#imageLiteral(resourceName: "icon_2"),#imageLiteral(resourceName: "icon_3"),#imageLiteral(resourceName: "icon_4"),#imageLiteral(resourceName: "icon_5")]
    let rightReel:Array<UIImage> = [#imageLiteral(resourceName: "icon_6"),#imageLiteral(resourceName: "icon_7"),#imageLiteral(resourceName: "icon_8"),#imageLiteral(resourceName: "icon_4"),#imageLiteral(resourceName: "icon_5"),#imageLiteral(resourceName: "icon_1"),#imageLiteral(resourceName: "icon_2"),#imageLiteral(resourceName: "icon_3")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    func animateImages(images:[UIImageView],reel:Array<UIImage>) {

        for image in images {
            image.animationImages = reel
            image.animationRepeatCount = 2
            image.animationDuration = 1
            image.startAnimating()
        }
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        
        let leftImages = [leftTopImage!,leftMiddleImage!,leftBottomImage!]
        let centerImages = [centerTopImage!,centerMiddleImage!,centerBottomImage!]
        let rightImages = [rightTopImage!,rightMiddleImage!,rightBottomImage!]
        
        animateImages(images: leftImages, reel: leftReel)
        animateImages(images: centerImages, reel: centerReel)
        animateImages(images: rightImages, reel: rightReel)

        leftTopImage.image = leftReel[Int.random(in: 0...leftReel.count-1)]
        leftMiddleImage.image = leftReel[Int.random(in: 0...leftReel.count-1)]
        leftBottomImage.image = leftReel[Int.random(in: 0...leftReel.count-1)]

        centerTopImage.image = centerReel[Int.random(in: 0...centerReel.count-1)]
        centerMiddleImage.image = centerReel[Int.random(in: 0...centerReel.count-1)]
        centerBottomImage.image = centerReel[Int.random(in: 0...centerReel.count-1)]

        rightTopImage.image = rightReel[Int.random(in: 0...rightReel.count-1)]
        rightMiddleImage.image = rightReel[Int.random(in: 0...rightReel.count-1)]
        rightBottomImage.image = rightReel[Int.random(in: 0...rightReel.count-1)]

        if leftMiddleImage.image == centerMiddleImage.image &&  leftMiddleImage.image == rightMiddleImage.image{
            
            winJackpotImage.image = #imageLiteral(resourceName: "stars")
            leftFrame.alpha = 1
            centerFrame.alpha = 1
            rightFrame.alpha = 1

        }
        else{
            
            winJackpotImage.image = nil
            leftFrame.alpha = 0
            centerFrame.alpha = 0
            rightFrame.alpha = 0
        }
        
    }
    
}

