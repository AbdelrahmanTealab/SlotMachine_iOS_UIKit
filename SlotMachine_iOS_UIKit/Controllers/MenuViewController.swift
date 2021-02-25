//
//  MenuViewController.swift
//  SlotMachine_iOS_UIKit
//
//  Created by Abdelrahman  Tealab on 2021-02-23.
//

import UIKit
import AVFoundation

class MenuViewController: UIViewController {
    var player: AVAudioPlayer?

    @IBOutlet weak var menuView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.layer.cornerRadius = 15;
        menuView.layer.masksToBounds = true;
        // Do any additional setup after loading the view.
    }
    
    @IBAction func resumePressed(_ sender: UIButton) {
        playSound(soundName: "remove_menu.wav")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func infoPressed(_ sender: UIButton) {
        playSound(soundName: "open_menu.wav")
    }
    
    @IBAction func resetPressed(_ sender: UIButton) {
        resetEverything()
    }
    
    func resetEverything() {
        /**  This block of code here is to hard reset the entire game with the values as well **/
        if let parentVC = self.presentingViewController as? ViewController {
            let alert = UIAlertController(title: "WARNING", message: "You're about to reset the game, are you sure ?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { [self] (UIAlertAction) in
                parentVC.bet = 10
                parentVC.coins = 100
                parentVC.reset()
                playSound(soundName: "remove_menu.wav")
                self.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler:nil))
            
            self.present(alert, animated: true, completion: nil)
        
           }
    }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
