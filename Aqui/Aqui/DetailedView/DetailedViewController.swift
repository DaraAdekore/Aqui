//
//  ViewController.swift
//  Aqui
//
//  Created by Dara Adekore on 2022-11-13.
//

import UIKit

class DetailedViewController: UIViewController{

    @IBOutlet weak var o3Label: UILabel!
    @IBOutlet weak var so2Label: UILabel!
    @IBOutlet weak var nh3Label: UILabel!
    @IBOutlet weak var coLabel: UILabel!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var pm10Label: UILabel!
    @IBOutlet weak var no2Label: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var pm25Label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var cityNameText:String?
    var localImage:UIImage?
    var o3:String = ""
    var so2:String = ""
    var nh3:String = ""
    var co:String = ""
    var no:String = ""
    var pm10:String = ""
    var no2:String = ""
    var pm25:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        o3Label.text = o3
        so2Label.text = so2
        nh3Label.text = nh3
        coLabel.text = co
        noLabel.text = no
        pm10Label.text = pm10
        pm25Label.text = pm25
        no2Label.text = no2
        
        cityName.text = cityNameText!
        imageView.image = localImage!
        
        
        o3Label.text?.removeLast()
        so2Label.text?.removeLast()
        nh3Label.text?.removeLast()
        coLabel.text?.removeLast()
        noLabel.text?.removeLast()
        pm10Label.text?.removeLast()
        pm25Label.text?.removeLast()
        no2Label.text?.removeLast()
        // Do any additional setup after loading the view.
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
