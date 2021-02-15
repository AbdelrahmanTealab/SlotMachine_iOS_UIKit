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
    
    var bet = 10
    var coins = 100
    var jackpot = 0
    
    var player: AVAudioPlayer?

    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        reset()
        /** vv This block of code here is to skew the bottom and top reel images vv **/
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

        betLabel.text = String(bet)
        coinsLabel.text = String(coins)
        jackpotLabel.text = String(jackpot)
    }
    
    func reset() {
        /**  This block of code here is to reset the images and labels after winning or losing **/

        winJackpotImage.image = nil
        raysJackpotImage.image = nil
        leftFrame.alpha = 0
        centerFrame.alpha = 0
        rightFrame.alpha = 0
        
        coinsLabel.text = String(coins)
        betLabel.text = String(bet)
        jackpotLabel.text = String(jackpot)
    }
    
    func resetEverything() {
        /**  This block of code here is to hard reset the entire game with the values as well **/

        let alert = UIAlertController(title: "WARNING", message: "You're about to reset the game, are you sure ?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { [self] (UIAlertAction) in
            bet = 10
            coins = 100
            jackpot = 0
            reset()
        }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler:nil))
        
        self.present(alert, animated: true, completion: nil)
    
    }
    
    @IBAction func resetPressed(_ sender: UIButton) {
        resetEverything()
    }
    
    //MARK: - Betting
    @IBAction func changeBet(_ sender: UIButton) {
        /**  This block of code here is to change the bet according to user's preference **/

        if sender.tag == 1 {
            bet+=1
        }
        else{
            if bet == 1 {
                /**  This block of code here is to make sure the user doesnt bet below 1 coin **/
                let alert = UIAlertController(title: "Hey !", message: "Why do you play if you wont bet !?", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "SORRY", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
            else{
                bet-=1
            }
        }
        betLabel.text = String(bet)
    }
    

    
    //MARK: - spinning
    func animateImages(images:[UIImageView],reel:Array<UIImage>) {
        /**  This block of code here is to animate the reels and shuffle the images inside them  **/
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
        /**  This block of code here is to  win everytime for debugging purposes**/

        imageView.image = leftReel[0]
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        /**  This block of code here is to start the game, first we make sure the user has enough coins then proceed to call the animation function  **/

        if coins < bet {
            let alert = UIAlertController(title: "DENIED", message: "Insuffecient Coins, please purchase more coins to continue", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Buy 100 coin", style: UIAlertAction.Style.default, handler: { [self] (UIAlertAction) in
                coins += 100
                coinsLabel.text = String(coins)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler:nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        else{
            coins = coins - bet
            coinsLabel.text = String(coins)
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

            /**  This block of code here is to check whether the user won or lost after the animations and images have finished shuffling **/

            Timer.scheduledTimer(withTimeInterval: 2.1, repeats: false, block: { [self] _ in
                checkWinning(leftImage: leftMiddleImage.image!, centerImage: centerMiddleImage.image!, rightImage: rightMiddleImage.image!)
            })
            

        }
    }

    
    func checkWinning(leftImage: UIImage, centerImage: UIImage, rightImage: UIImage){
        /**  This block of code here is to check the user whether they won or lost and then accordingly an image and sound will be activated to show achievement **/

        if leftImage == centerImage &&  leftImage == rightImage{
            
            playSound(soundName: "win.wav")
            winJackpotImage.image = #imageLiteral(resourceName: "mega_win")
            raysJackpotImage.image = #imageLiteral(resourceName: "rays")
            leftFrame.alpha = 1
            centerFrame.alpha = 1
            rightFrame.alpha = 1
            
            
            coins += bet*2
            jackpot += bet*2
            jackpotLabel.text = String(jackpot)
            coinsLabel.text = String(coins)
            print("win")

        }
        else{
            playSound(soundName: "lose.wav")
            reset()
            print("lose")
        }
    }
    //MARK: - sounds
    func playSound(soundName: String) {
        /**  This block of code here is to play the sounds **/

        let path = Bundle.main.path(forResource: soundName, ofType:nil)!

        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("error loading sound file")
        }
    }
    
}

