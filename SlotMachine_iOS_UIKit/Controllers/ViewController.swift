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
    
    @IBOutlet weak var topReelLine: UIImageView!
    @IBOutlet weak var middleReelLine: UIImageView!
    @IBOutlet weak var bottomReelLine: UIImageView!
    
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinGained: UILabel!
    @IBOutlet weak var coinGainedBackground: UIImageView!
    @IBOutlet weak var plusCoinsUiView: UIView!
    
    let leftReel:Array<UIImage> = [#imageLiteral(resourceName: "icon_1"),#imageLiteral(resourceName: "icon_2"),#imageLiteral(resourceName: "icon_3"),#imageLiteral(resourceName: "icon_4"),#imageLiteral(resourceName: "icon_5"),#imageLiteral(resourceName: "icon_6"),#imageLiteral(resourceName: "icon_7"),#imageLiteral(resourceName: "icon_8")]
    let centerReel:Array<UIImage> = [#imageLiteral(resourceName: "icon_6"),#imageLiteral(resourceName: "icon_7"),#imageLiteral(resourceName: "icon_8"),#imageLiteral(resourceName: "icon_1"),#imageLiteral(resourceName: "icon_2"),#imageLiteral(resourceName: "icon_3"),#imageLiteral(resourceName: "icon_4"),#imageLiteral(resourceName: "icon_5")]
    let rightReel:Array<UIImage> = [#imageLiteral(resourceName: "icon_6"),#imageLiteral(resourceName: "icon_7"),#imageLiteral(resourceName: "icon_8"),#imageLiteral(resourceName: "icon_4"),#imageLiteral(resourceName: "icon_5"),#imageLiteral(resourceName: "icon_1"),#imageLiteral(resourceName: "icon_2"),#imageLiteral(resourceName: "icon_3")]
    
    var bet = 10
    var coins = 100
    var jackpot = 5000
    var winnings = 0

    var player: AVAudioPlayer?
    var betTimer: Timer?
    var timeAtPress: Date?

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
        winnings = 0
        
        topReelLine.alpha = 0
        middleReelLine.alpha = 0
        bottomReelLine.alpha = 0

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
            jackpot = 5000
            reset()
        }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler:nil))
        
        self.present(alert, animated: true, completion: nil)
    
    }
    
    @IBAction func resetPressed(_ sender: UIButton) {
        resetEverything()
    }
    
    //MARK: - Betting
    func changeBet(sender:UIButton,value:Int) -> Int {
        
        if sender.tag == 1 {
            bet+=value
        }
        else{
            if (bet-value) < 1 {
                /**  This block of code here is to make sure the user doesnt bet below 1 coin **/
                betTimer?.invalidate()
                let alert = UIAlertController(title: "Hey !", message: "Why do you play if you wont bet !?", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "SORRY", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                bet = 1
            }
            else{
                bet-=value
            }
        }
        return bet
    }
    
    @IBAction func changeBetBy10(_ sender: UIButton) {
        timeAtPress = Date()

        betTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [self] _ in
            let elapsed = Date().timeIntervalSince(timeAtPress!)
            let duration = Float(elapsed)
            
            if let myTimer = betTimer {
                if duration >= 9.5 {
                    betLabel.text = String(changeBet(sender: sender, value: 1000))
                }
                else if duration >= 5 {
                    betLabel.text = String(changeBet(sender: sender, value: 100))
                }
                else {
                    betLabel.text = String(changeBet(sender: sender, value: 10))
                }
            }

        })
    }
    
    @IBAction func stopChangingBet(_ sender: UIButton) {
        //betLabel.text = String(changeBet(sender: sender, value: 100))
        let elapsed = Date().timeIntervalSince(timeAtPress!)
        let duration = Float(elapsed)
        
        if let myTimer = betTimer {
            if duration < 0.4 {
                betLabel.text = String(changeBet(sender: sender, value: 1))
            }
        }
        betTimer?.invalidate()
    }
    
    
    
    //MARK: - spinning
    func animateImages(images:[UIImageView],reel:Array<UIImage>) {
        /**  This block of code here is to animate the reels and shuffle the images inside them  **/
        for (index,imageView) in images.enumerated() {
            UIView.animate(
                withDuration: 0.2,
                delay: 0.0,
                options: [.autoreverse],
                animations: {
                    if imageView == images[1]
                    {
                        UIView.setAnimationRepeatCount(5)
                        var frame = imageView.frame
                        frame.origin.y += 5
                        imageView.frame = frame
                    }
                    else{
                        UIView.setAnimationRepeatCount(5)
                        var frame = imageView.frame
                        frame.origin.y -= 5
                        imageView.frame = frame
                    }
                }, completion: {finished in

               print("animation finished")
                    let randomNumber = Int.random(in: 0...100)
                    var chosenImage = "icon_1"
                    if randomNumber <=  17{
                        chosenImage = "icon_1"
                        print("reel \(index): \(randomNumber)  |  chosen image: \(chosenImage)")
                    }else if randomNumber <= 40 {
                        chosenImage = "icon_2"
                        print("reel \(index): \(randomNumber)  |  chosen image: \(chosenImage)")
                    }else if randomNumber <= 55 {
                        chosenImage = "icon_3"
                        print("reel \(index): \(randomNumber)  |  chosen image: \(chosenImage)")
                    }else if randomNumber <= 70 {
                        chosenImage = "icon_4"
                        print("reel \(index): \(randomNumber)  |  chosen image: \(chosenImage)")
                    }else if randomNumber <= 80 {
                        chosenImage = "icon_5"
                        print("reel \(index): \(randomNumber)  |  chosen image: \(chosenImage)")
                    }else if randomNumber <= 90 {
                        chosenImage = "icon_6"
                        print("reel \(index): \(randomNumber)  |  chosen image: \(chosenImage)")
                    }else if randomNumber <= 95 {
                        chosenImage = "icon_8"
                        print("reel \(index): \(randomNumber)  |  chosen image: \(chosenImage)")
                    }else if randomNumber <= 100 {
                        chosenImage = "icon_7"
                        print("reel \(index): \(randomNumber)  |  chosen image: \(chosenImage)")
                    }
                    
                    
                    imageView.image = UIImage(named: chosenImage)
                    //self.alwaysWin(imageView: image)
                    if imageView == images[1]
                    {
                        var frame = imageView.frame
                        frame.origin.y -= 5
                        imageView.frame = frame
                    }
                    else{
                        var frame = imageView.frame
                        frame.origin.y += 5
                        imageView.frame = frame
                    }
              }
            )
            imageView.animationImages = reel
            imageView.animationRepeatCount = 2
            imageView.animationDuration = 1
            imageView.startAnimating()
        }
    }
    func animateCoinsGained(){
        plusCoinsUiView.alpha = 1
        plusCoinsUiView.frame.origin.y = 32
        UIView.animate(
            withDuration: 2,
            delay: 0.0,
            options: [.preferredFramesPerSecond60],
            animations: { [self] in

                var coinsViewFrame = plusCoinsUiView.frame
                coinsViewFrame.origin.y -= 50
                plusCoinsUiView.frame = coinsViewFrame
                plusCoinsUiView.alpha = 0
                
            }, completion: { [self]finished in
                var coinsViewFrame = plusCoinsUiView.frame
                plusCoinsUiView.frame = coinsViewFrame
            }
        )
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
            Timer.scheduledTimer(withTimeInterval: 4.2, repeats: false, block: { _ in
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
                checkWinning(leftImage: leftTopImage.image!, centerImage: centerTopImage.image!, rightImage: rightTopImage.image!, reel: "top")
            })
            Timer.scheduledTimer(withTimeInterval: 3.1, repeats: false, block: { [self] _ in
                checkWinning(leftImage: leftMiddleImage.image!, centerImage: centerMiddleImage.image!, rightImage: rightMiddleImage.image!, reel: "middle")
            })
            Timer.scheduledTimer(withTimeInterval: 4.1, repeats: false, block: { [self] _ in
                checkWinning(leftImage: leftBottomImage.image!, centerImage: centerBottomImage.image!, rightImage: rightBottomImage.image!, reel: "bottom")
            })

        }
    }

    
    func checkWinning(leftImage: UIImage, centerImage: UIImage, rightImage: UIImage, reel: String){
        /**  This block of code here is to check the user whether they won or lost and then accordingly an image and sound will be activated to show achievement **/
        //MARK: - 3 similar winnings
        if leftImage == centerImage &&  leftImage == rightImage && leftImage == UIImage(named: "icon_1"){
            if reel == "middle" {
                playSound(soundName: "win.wav")
                winJackpotImage.image = #imageLiteral(resourceName: "mega_win")
                raysJackpotImage.image = #imageLiteral(resourceName: "rays")
                
                leftFrame.alpha = 1
                centerFrame.alpha = 1
                rightFrame.alpha = 1
                middleReelLine.image = #imageLiteral(resourceName: "1")
                middleReelLine.alpha = 1
                
                winnings += ((bet/2) * 3) + bet
                coinGained.text = "+\(winnings)"
                animateCoinsGained()
                coins += winnings
                coinsLabel.text = String(coins)
            }
            else {
                playSound(soundName: "win3_not_middle.wav")
                raysJackpotImage.image = #imageLiteral(resourceName: "rays")
                winnings += (bet/2) * 3
                coinGained.text = "+\(winnings)"
                animateCoinsGained()
                coins += winnings
                coinsLabel.text = String(coins)
                if reel == "top"{
                    topReelLine.image = #imageLiteral(resourceName: "1")
                    topReelLine.alpha = 1
                }
                else if reel == "bottom"{
                    bottomReelLine.image = #imageLiteral(resourceName: "1")
                    bottomReelLine.alpha = 1
                }
            }
            print("win")
        }
        
        if leftImage == centerImage &&  leftImage == rightImage && leftImage == UIImage(named: "icon_2"){
            if reel == "middle" {
                playSound(soundName: "win.wav")
                winJackpotImage.image = #imageLiteral(resourceName: "mega_win")
                raysJackpotImage.image = #imageLiteral(resourceName: "rays")
                
                leftFrame.alpha = 1
                centerFrame.alpha = 1
                rightFrame.alpha = 1
                middleReelLine.image = #imageLiteral(resourceName: "1")
                middleReelLine.alpha = 1
                
                winnings += bet*3
                coinGained.text = "+\(winnings)"
                animateCoinsGained()
                coins += winnings
                coinsLabel.text = String(coins)
            }
            else {
                playSound(soundName: "win3_not_middle.wav")
                raysJackpotImage.image = #imageLiteral(resourceName: "rays")
                winnings += (bet*3)+bet
                coinGained.text = "+\(winnings)"
                animateCoinsGained()
                coins += winnings
                coinsLabel.text = String(coins)
                if reel == "top"{
                    topReelLine.image = #imageLiteral(resourceName: "1")
                    topReelLine.alpha = 1
                }
                else if reel == "bottom"{
                    bottomReelLine.image = #imageLiteral(resourceName: "1")
                    bottomReelLine.alpha = 1
                }
            }
            print("win")
        }
        if leftImage == centerImage &&  leftImage == rightImage && leftImage == UIImage(named: "icon_3"){
            if reel == "middle" {
                playSound(soundName: "win.wav")
                winJackpotImage.image = #imageLiteral(resourceName: "mega_win")
                raysJackpotImage.image = #imageLiteral(resourceName: "rays")
                
                leftFrame.alpha = 1
                centerFrame.alpha = 1
                rightFrame.alpha = 1
                middleReelLine.image = #imageLiteral(resourceName: "1")
                middleReelLine.alpha = 1
                
                winnings += (bet+Int(Float(bet)*0.25)) * 3
                coinGained.text = "+\(winnings)"
                animateCoinsGained()
                coins += winnings
                coinsLabel.text = String(coins)
            }
            else {
                playSound(soundName: "win3_not_middle.wav")
                raysJackpotImage.image = #imageLiteral(resourceName: "rays")
                winnings += bet+Int(Float(bet)*0.25)
                coinGained.text = "+\(winnings)"
                animateCoinsGained()
                coins += winnings
                coinsLabel.text = String(coins)
                if reel == "top"{
                    topReelLine.image = #imageLiteral(resourceName: "1")
                    topReelLine.alpha = 1
                }
                else if reel == "bottom"{
                    bottomReelLine.image = #imageLiteral(resourceName: "1")
                    bottomReelLine.alpha = 1
                }
            }
            print("win")
        }
        if leftImage == centerImage &&  leftImage == rightImage && leftImage == UIImage(named: "icon_4"){
            if reel == "middle" {
                playSound(soundName: "win.wav")
                winJackpotImage.image = #imageLiteral(resourceName: "mega_win")
                raysJackpotImage.image = #imageLiteral(resourceName: "rays")
                
                leftFrame.alpha = 1
                centerFrame.alpha = 1
                rightFrame.alpha = 1
                middleReelLine.image = #imageLiteral(resourceName: "1")
                middleReelLine.alpha = 1
                
                winnings += (Int(bet/2) + bet) * 3
                coinGained.text = "+\(winnings)"
                animateCoinsGained()
                coins += winnings
                coinsLabel.text = String(coins)
            }
            else {
                playSound(soundName: "win3_not_middle.wav")
                raysJackpotImage.image = #imageLiteral(resourceName: "rays")
                winnings += Int(bet/2) + bet
                coinGained.text = "+\(winnings)"
                animateCoinsGained()
                coins += winnings
                coinsLabel.text = String(coins)
                if reel == "top"{
                    topReelLine.image = #imageLiteral(resourceName: "1")
                    topReelLine.alpha = 1
                }
                else if reel == "bottom"{
                    bottomReelLine.image = #imageLiteral(resourceName: "1")
                    bottomReelLine.alpha = 1
                }
            }
            print("win")
        }
        if leftImage == centerImage &&  leftImage == rightImage && leftImage == UIImage(named: "icon_5"){
            if reel == "middle" {
                playSound(soundName: "win.wav")
                winJackpotImage.image = #imageLiteral(resourceName: "mega_win")
                raysJackpotImage.image = #imageLiteral(resourceName: "rays")
                
                leftFrame.alpha = 1
                centerFrame.alpha = 1
                rightFrame.alpha = 1
                middleReelLine.image = #imageLiteral(resourceName: "1")
                middleReelLine.alpha = 1
                
                winnings += (bet*2)*3
                coinGained.text = "+\(winnings)"
                animateCoinsGained()
                coins += winnings
                coinsLabel.text = String(coins)
            }
            else {
                playSound(soundName: "win3_not_middle.wav")
                raysJackpotImage.image = #imageLiteral(resourceName: "rays")
                winnings += bet*2
                coinGained.text = "+\(winnings)"
                animateCoinsGained()
                coins += winnings
                coinsLabel.text = String(coins)
                if reel == "top"{
                    topReelLine.image = #imageLiteral(resourceName: "1")
                    topReelLine.alpha = 1
                }
                else if reel == "bottom"{
                    bottomReelLine.image = #imageLiteral(resourceName: "1")
                    bottomReelLine.alpha = 1
                }
            }
            print("win")
        }
        if leftImage == centerImage &&  leftImage == rightImage && leftImage == UIImage(named: "icon_6"){
            if reel == "middle" {
                playSound(soundName: "win.wav")
                winJackpotImage.image = #imageLiteral(resourceName: "mega_win")
                raysJackpotImage.image = #imageLiteral(resourceName: "rays")
                
                leftFrame.alpha = 1
                centerFrame.alpha = 1
                rightFrame.alpha = 1
                middleReelLine.image = #imageLiteral(resourceName: "1")
                middleReelLine.alpha = 1
                
                winnings += Int(Float(bet)*2.5)*3
                coinGained.text = "+\(winnings)"
                animateCoinsGained()
                coins += winnings
                coinsLabel.text = String(coins)
            }
            else {
                playSound(soundName: "win3_not_middle.wav")
                raysJackpotImage.image = #imageLiteral(resourceName: "rays")
                winnings += Int(Float(bet)*2.5)
                coinGained.text = "+\(winnings)"
                animateCoinsGained()
                coins += winnings
                coinsLabel.text = String(coins)
                if reel == "top"{
                    topReelLine.image = #imageLiteral(resourceName: "1")
                    topReelLine.alpha = 1
                }
                else if reel == "bottom"{
                    bottomReelLine.image = #imageLiteral(resourceName: "1")
                    bottomReelLine.alpha = 1
                }
            }
            print("win")
        }
        if leftImage == centerImage &&  leftImage == rightImage && leftImage == UIImage(named: "icon_7"){
            if reel == "middle" {
                playSound(soundName: "win.wav")
                winJackpotImage.image = #imageLiteral(resourceName: "mega_win")
                raysJackpotImage.image = #imageLiteral(resourceName: "rays")
                
                leftFrame.alpha = 1
                centerFrame.alpha = 1
                rightFrame.alpha = 1
                middleReelLine.image = #imageLiteral(resourceName: "1")
                middleReelLine.alpha = 1
                
                winnings += jackpot
                coinGained.text = "+\(winnings)"
                animateCoinsGained()
                coins += winnings
                coinsLabel.text = String(coins)
            }
            else {
                playSound(soundName: "win3_not_middle.wav")
                raysJackpotImage.image = #imageLiteral(resourceName: "rays")
                winnings += (bet*4)*3
                coinGained.text = "+\(winnings)"
                animateCoinsGained()
                coins += winnings
                coinsLabel.text = String(coins)
                if reel == "top"{
                    topReelLine.image = #imageLiteral(resourceName: "1")
                    topReelLine.alpha = 1
                }
                else if reel == "bottom"{
                    bottomReelLine.image = #imageLiteral(resourceName: "1")
                    bottomReelLine.alpha = 1
                }
            }
            print("win")
        }
        if leftImage == centerImage &&  leftImage == rightImage && leftImage == UIImage(named: "icon_8"){
            if reel == "middle" {
                playSound(soundName: "win.wav")
                winJackpotImage.image = #imageLiteral(resourceName: "mega_win")
                raysJackpotImage.image = #imageLiteral(resourceName: "rays")
                
                leftFrame.alpha = 1
                centerFrame.alpha = 1
                rightFrame.alpha = 1
                middleReelLine.image = #imageLiteral(resourceName: "1")
                middleReelLine.alpha = 1
                
                winnings += (bet*3)*3
                coinGained.text = "+\(winnings)"
                animateCoinsGained()
                coins += winnings
                coinsLabel.text = String(coins)
            }
            else {
                playSound(soundName: "win3_not_middle.wav")
                raysJackpotImage.image = #imageLiteral(resourceName: "rays")
                winnings += bet*3
                coinGained.text = "+\(winnings)"
                animateCoinsGained()
                coins += winnings
                coinsLabel.text = String(coins)
                if reel == "top"{
                    topReelLine.image = #imageLiteral(resourceName: "1")
                    topReelLine.alpha = 1
                }
                else if reel == "bottom"{
                    bottomReelLine.image = #imageLiteral(resourceName: "1")
                    bottomReelLine.alpha = 1
                }
            }
            print("win")
        }
        //MARK: - 2 similar winnings
        else if leftImage == UIImage(named: "icon_1") && centerImage == UIImage(named: "icon_1") && leftImage != rightImage || centerImage == UIImage(named: "icon_1") && rightImage == UIImage(named: "icon_1") && leftImage != rightImage{
            playSound(soundName: "small_win.wav")
            raysJackpotImage.image = #imageLiteral(resourceName: "rays")
            winnings += Int(bet/2)
            coinGained.text = "+\(winnings)"
            animateCoinsGained()
            coins += winnings
            coinsLabel.text = String(coins)
            if reel == "top" {
                topReelLine.image = #imageLiteral(resourceName: "1")
                topReelLine.alpha = 1
            }
            else if reel == "middle"{
                middleReelLine.image = #imageLiteral(resourceName: "1")
                middleReelLine.alpha = 1
            }
            else{
                bottomReelLine.image = #imageLiteral(resourceName: "1")
                bottomReelLine.alpha = 1
            }
            print("small win")
        }
        else if leftImage == UIImage(named: "icon_2") && centerImage == UIImage(named: "icon_2") && leftImage != rightImage || centerImage == UIImage(named: "icon_2") && rightImage == UIImage(named: "icon_2") && leftImage != rightImage{
            playSound(soundName: "small_win.wav")
            raysJackpotImage.image = #imageLiteral(resourceName: "rays")
            winnings += bet
            coinGained.text = "+\(winnings)"
            animateCoinsGained()
            coins += winnings
            coinsLabel.text = String(coins)
            if reel == "top" {
                topReelLine.image = #imageLiteral(resourceName: "1")
                topReelLine.alpha = 1
            }
            else if reel == "middle"{
                middleReelLine.image = #imageLiteral(resourceName: "1")
                middleReelLine.alpha = 1
            }
            else{
                bottomReelLine.image = #imageLiteral(resourceName: "1")
                bottomReelLine.alpha = 1
            }
            print("small win")
        }
        else if leftImage == UIImage(named: "icon_3") && centerImage == UIImage(named: "icon_3") && leftImage != rightImage || centerImage == UIImage(named: "icon_3") && rightImage == UIImage(named: "icon_3") && leftImage != rightImage{
            playSound(soundName: "small_win.wav")
            raysJackpotImage.image = #imageLiteral(resourceName: "rays")
            winnings += bet + Int(Float(bet)*0.25)
            coinGained.text = "+\(winnings)"
            animateCoinsGained()
            coins += winnings
            coinsLabel.text = String(coins)
            if reel == "top" {
                topReelLine.image = #imageLiteral(resourceName: "1")
                topReelLine.alpha = 1
            }
            else if reel == "middle"{
                middleReelLine.image = #imageLiteral(resourceName: "1")
                middleReelLine.alpha = 1
            }
            else{
                bottomReelLine.image = #imageLiteral(resourceName: "1")
                bottomReelLine.alpha = 1
            }
            print("small win")
        }
        else if leftImage == UIImage(named: "icon_4") && centerImage == UIImage(named: "icon_4") && leftImage != rightImage || centerImage == UIImage(named: "icon_4") && rightImage == UIImage(named: "icon_4") && leftImage != rightImage{
            playSound(soundName: "small_win.wav")
            raysJackpotImage.image = #imageLiteral(resourceName: "rays")
            winnings += Int(bet/2) + bet
            coinGained.text = "+\(winnings)"
            animateCoinsGained()
            coins += winnings
            coinsLabel.text = String(coins)
            if reel == "top" {
                topReelLine.image = #imageLiteral(resourceName: "1")
                topReelLine.alpha = 1
            }
            else if reel == "middle"{
                middleReelLine.image = #imageLiteral(resourceName: "1")
                middleReelLine.alpha = 1
            }
            else{
                bottomReelLine.image = #imageLiteral(resourceName: "1")
                bottomReelLine.alpha = 1
            }
            print("small win")
        }
        else if leftImage == UIImage(named: "icon_5") && centerImage == UIImage(named: "icon_5") && leftImage != rightImage || centerImage == UIImage(named: "icon_5") && rightImage == UIImage(named: "icon_5") && leftImage != rightImage{
            playSound(soundName: "small_win.wav")
            raysJackpotImage.image = #imageLiteral(resourceName: "rays")
            winnings += bet*2
            coinGained.text = "+\(winnings)"
            animateCoinsGained()
            coins += winnings
            coinsLabel.text = String(coins)
            if reel == "top" {
                topReelLine.image = #imageLiteral(resourceName: "1")
                topReelLine.alpha = 1
            }
            else if reel == "middle"{
                middleReelLine.image = #imageLiteral(resourceName: "1")
                middleReelLine.alpha = 1
            }
            else{
                bottomReelLine.image = #imageLiteral(resourceName: "1")
                bottomReelLine.alpha = 1
            }
            print("small win")
        }
        else if leftImage == UIImage(named: "icon_6") && centerImage == UIImage(named: "icon_6") && leftImage != rightImage || centerImage == UIImage(named: "icon_6") && rightImage == UIImage(named: "icon_6") && leftImage != rightImage{
            playSound(soundName: "small_win.wav")
            raysJackpotImage.image = #imageLiteral(resourceName: "rays")
            winnings += Int(Float(bet)*2.5)
            coinGained.text = "+\(winnings)"
            animateCoinsGained()
            coins += winnings
            coinsLabel.text = String(coins)
            if reel == "top" {
                topReelLine.image = #imageLiteral(resourceName: "1")
                topReelLine.alpha = 1
            }
            else if reel == "middle"{
                middleReelLine.image = #imageLiteral(resourceName: "1")
                middleReelLine.alpha = 1
            }
            else{
                bottomReelLine.image = #imageLiteral(resourceName: "1")
                bottomReelLine.alpha = 1
            }
            print("small win")
        }
        else if leftImage == UIImage(named: "icon_7") && centerImage == UIImage(named: "icon_7") && leftImage != rightImage || centerImage == UIImage(named: "icon_7") && rightImage == UIImage(named: "icon_7") && leftImage != rightImage{
            playSound(soundName: "small_win.wav")
            raysJackpotImage.image = #imageLiteral(resourceName: "rays")
            winnings += bet * 4
            coinGained.text = "+\(winnings)"
            animateCoinsGained()
            coins += winnings
            coinsLabel.text = String(coins)
            if reel == "top" {
                topReelLine.image = #imageLiteral(resourceName: "1")
                topReelLine.alpha = 1
            }
            else if reel == "middle"{
                middleReelLine.image = #imageLiteral(resourceName: "1")
                middleReelLine.alpha = 1
            }
            else{
                bottomReelLine.image = #imageLiteral(resourceName: "1")
                bottomReelLine.alpha = 1
            }
            print("small win")
        }
        else if leftImage == UIImage(named: "icon_8") && centerImage == UIImage(named: "icon_8") && leftImage != rightImage || centerImage == UIImage(named: "icon_8") && rightImage == UIImage(named: "icon_8") && leftImage != rightImage{
            playSound(soundName: "small_win.wav")
            raysJackpotImage.image = #imageLiteral(resourceName: "rays")
            winnings += bet * 3
            coinGained.text = "+\(winnings)"
            animateCoinsGained()
            coins += winnings
            coinsLabel.text = String(coins)
            if reel == "top" {
                topReelLine.image = #imageLiteral(resourceName: "1")
                topReelLine.alpha = 1
            }
            else if reel == "middle"{
                middleReelLine.image = #imageLiteral(resourceName: "1")
                middleReelLine.alpha = 1
            }
            else{
                bottomReelLine.image = #imageLiteral(resourceName: "1")
                bottomReelLine.alpha = 1
            }
            print("small win")
        }
        else if leftImage != centerImage && centerImage != rightImage{
            playSound(soundName: "lose.wav")
            if reel == "top" {
                topReelLine.image = #imageLiteral(resourceName: "line")
                topReelLine.alpha = 1
            }
            else if reel == "middle"{
                middleReelLine.image = #imageLiteral(resourceName: "line")
                middleReelLine.alpha = 1
            }
            else{
                bottomReelLine.image = #imageLiteral(resourceName: "line")
                bottomReelLine.alpha = 1
            }
            print("lose")
        }
        if winnings > jackpot {
            jackpot = winnings
            jackpotLabel.text = String(jackpot)
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

