//
//  DataViewController.swift
//  Test_Final_Project
//
//  Created by cpsc on 12/14/20.
//

import UIKit

class DataViewController: UIViewController {
    
    @IBOutlet weak var slideTitle: UILabel!
    var displayTitle: String?
    var titleIndex: Int?
    
    
    @IBOutlet weak var dataLabel: UILabel!
    var displayText: String?
    var index: Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataLabel.text = displayText
        slideTitle.text = displayTitle
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
