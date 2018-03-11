//
//  PanelViewController.swift
//  TVVLCPlayer
//
//  Created by Jérémy Marchand on 10/03/2018.
//

import UIKit

// MARK: - PanelViewController Delegate
protocol PanelViewControllerDelegate: class {
    func panelViewControllerDidDismiss(_ panelViewController: PanelViewController)
}

// MARK: - PanelViewController
class PanelViewController: UIViewController, UIViewControllerTransitioningDelegate {
    @IBOutlet weak var tabBar: UITabBar!
    weak var delegate: PanelViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func collapse(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.panelViewControllerDidDismiss(self)
        }
    }
}

