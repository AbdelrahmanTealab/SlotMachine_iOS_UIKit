//
//  ViewController.swift
//  SlotMachine_iOS_UIKit
//
//  Created by Abdelrahman  Tealab on 2021-01-22.
//

import UIKit
import Spruce
import AVFoundation

class ViewController: UIViewController {

    
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var jackpotLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var winJackpotImage: UIImageView!
    @IBOutlet weak var raysJackpotImage: UIImageView!
    
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
    
    var player: AVAudioPlayer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        reset()
        var bottomPerspectiveTransform = CATransform3DIdentity
        bottomPerspectiveTransform.m34 = 1.0 / -200
        bottomPerspectiveTransform = CATransform3DRotate(bottomPerspectiveTransform, -45.0 * .pi / 360.0, 180.0,  0.0, 0.0)
        
        var topPerspectiveTransform = CATransform3DIdentity
        topPerspectiveTransform.m34 = 1.0 / 200
        topPerspectiveTransform = CATransform3DRotate(topPerspectiveTransform, -45.0 * .pi / 360.0, 180.0,  0.0, 0.0)
        
        leftBottomImage.layer.transform = bottomPerspectiveTransform
        centerBottomImage.layer.transform = bottomPerspectiveTransform
        rightBottomImage.layer.transform = bottomPerspectiveTransform

        leftTopImage.layer.transform = topPerspectiveTransform
        centerTopImage.layer.transform = topPerspectiveTransform
        rightTopImage.layer.transform = topPerspectiveTransform
    }
    
    func animateImages(images:[UIImageView],reel:Array<UIImage>) {
        
        for (index,image) in images.enumerated() {
            UIView.animate(
                withDuration: 0.2,
                delay: 0.0,
                options: [.autoreverse],
                animations: {
                    if image == images[1]
                    {
                        UIView.setAnimationRepeatCount(5)
                        var frame = image.frame
                        frame.origin.y += 5
                        image.frame = frame
                    }
                    else{
                        UIView.setAnimationRepeatCount(5)
                        var frame = image.frame
                        frame.origin.y -= 5
                        image.frame = frame
                    }
                }, completion: {finished in

               print("animation finished")
                    image.image = reel[Int.random(in: 0...reel.count-1)]
                    //self.alwaysWin(imageView: image)
                    if image == images[1]
                    {
                        var frame = image.frame
                        frame.origin.y -= 5
                        image.frame = frame
                    }
                    else{
                        var frame = image.frame
                        frame.origin.y += 5
                        image.frame = frame
                    }
              }
            )
            image.animationImages = reel
            image.animationRepeatCount = 2
            image.animationDuration = 1
            image.startAnimating()
        }
    }
    
    func alwaysWin(imageView: UIImageView) {
        imageView.image = leftReel[0]
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        reset()
        sender.isUserInteractionEnabled = false
        sender.setImage(#imageLiteral(resourceName: "start_active_btn"), for: .normal)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
            sender.isUserInteractionEnabled = true
            sender.setImage(#imageLiteral(resourceName: "start_btn"), for: .normal)
        })
        
        let leftImages = [leftTopImage!,leftMiddleImage!,leftBottomImage!]
        let centerImages = [centerTopImage!,centerMiddleImage!,centerBottomImage!]
        let rightImages = [rightTopImage!,rightMiddleImage!,rightBottomImage!]
        
        playSound(soundName: "spinning.wav")
        
        animateImages(images: leftImages, reel: leftReel)
        animateImages(images: centerImages, reel: centerReel)
        animateImages(images: rightImages, reel: rightReel)

        Timer.scheduledTimer(withTimeInterval: 2.1, repeats: false, block: { [self] _ in
            checkWinning(leftImage: leftMiddleImage.image!, centerImage: centerMiddleImage.image!, rightImage: rightMiddleImage.image!)
        })
        
    }
    
    func playSound(soundName: String) {
        let path = Bundle.main.path(forResource: soundName, ofType:nil)!

        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    func checkWinning(leftImage: UIImage, centerImage: UIImage, rightImage: UIImage){
        if leftImage == centerImage &&  leftImage == rightImage{
            
            playSound(soundName: "win.wav")
            winJackpotImage.image = #imageLiteral(resourceName: "mega_win")
            raysJackpotImage.image = #imageLiteral(resourceName: "rays")
            leftFrame.alpha = 1
            centerFrame.alpha = 1
            rightFrame.alpha = 1
            
            print("win")

        }
        else{
            playSound(soundName: "lose.wav")
            reset()
            print("lose")
        }
    }
    func reset() {
        winJackpotImage.image = nil
        raysJackpotImage.image = nil
        leftFrame.alpha = 0
        centerFrame.alpha = 0
        rightFrame.alpha = 0
    }
    
}

