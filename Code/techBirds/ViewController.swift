//
//  ViewController.swift
//  techBirds
//
//  Created by admin on 31.07.2020.
//  Copyright © 2020 techBirds. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let category = App.current.categoriesClassifier.classify(
            "Где открывали, туда и идите. До сих пор! А я пожалуй закрою карту и все счета в сбере."
        )
        
        print(category)
    }
}
