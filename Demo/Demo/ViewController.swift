//
//  ViewController.swift
//  Demo
//
//  Created by Jérémy Marchand on 03/03/2018.
//  Copyright © 2018 Jérémy Marchand. All rights reserved.
//

import UIKit
import TVVLCPlayer

class ViewController: UIViewController {
    let demoVideoURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/8/88/Big_Buck_Bunny_alt.webm")!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let playerVC = segue.destination as? VLCPlayerViewController {
            let media = VLCMedia(url: demoVideoURL)
            playerVC.media = media
            playerVC.delegate = self
        }
    }
}

extension ViewController: VLCMediaPlayerViewControllerDelegate {
    func mediaPlayer(_ playerViewController: VLCPlayerViewController, stateChanged state: VLCMediaPlayerState) {
        print("State changed: \(state.rawValue)")
    }
    
    func mediaPlayer(_ playerViewController: VLCPlayerViewController, timeChanged time: VLCTime) {
        print("Time changed: \(time)")
    }
    
    func mediaPlayer(_ playerViewController: VLCPlayerViewController, titleChanged name: String, duration: Int, isMenu: Bool) {
        print("Title changed: \(name)")
    }
    
    func mediaPlayer(_ playerViewController: VLCPlayerViewController, chapterChanged name: String, timeOffset: Int, duration: Int) {
        print("Chapter changed: \(name)")
    }
}
