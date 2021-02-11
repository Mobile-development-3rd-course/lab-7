//
//  DrawingViewController.swift
//  lab-1.1
//
//  Created by Kirill on 09.02.2021.
//

import UIKit

@IBDesignable
class DrawingViewController: UIViewController {
    
    @IBOutlet var diagram: DiagramView!
    @IBOutlet var cos: CosView!
    
    override func viewDidLoad() {
        diagram.alpha = 0
        super.viewDidLoad()
    }
    
    @IBAction func suitDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            cos.alpha = 1
            diagram.alpha = 0
        case 1:
            cos.alpha = 0
            diagram.alpha = 1
        default:
            break
        }
        
    }
    
    
}
