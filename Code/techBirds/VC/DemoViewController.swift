//
//  DemoViewController.swift
//  techBirds
//
//  Created by admin on 02.08.2020.
//  Copyright © 2020 techBirds. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    @IBOutlet weak var enterComment: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func buttonAction() {
        if let text = enterComment.text {
            let category = composeNiceText(App.current.categoriesClassifier.classifyText(text))
            let team = composeNiceText(App.current.teamsClassifier.classifyText(text))
            resultLabel.text = "\(category)\n\(team)"
        }
        
        
    }
    
    private func composeNiceText(_ dict: [String: Double]) -> String {
        var text = ""
        let dictValInc = dict.sorted(by: { $0.value > $1.value })
        
        for i in dictValInc {
            text.append("\(i)\n")
        }
        return text
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

