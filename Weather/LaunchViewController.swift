//
//  LaunchViewController.swift
//  Weather
//
//  Created by Venkateshprasad Ashwathnarayana on 12/15/16.
//  Copyright © 2016 Venkateshprasad Ashwathnarayana. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        perform(#selector(LaunchViewController.showNavController), with: nil, afterDelay: 2)
    }
    
    func showNavController()
    {
        performSegue(withIdentifier: "LaunchIdentifier", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
