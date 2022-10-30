//
//  CollectionViewCell.swift
//  Aqui
//
//  Created by Dara on 2022-10-26.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cityImage: UIImageView!
    
    @IBOutlet weak var cityIndex: UILabel!
    
    @IBOutlet weak var cityName: UILabel!
    
    var uiColor:CGColor?
    private lazy var gradient: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, uiColor]
        gradientLayer.backgroundColor = UIColor.clear.cgColor
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.8)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 90, width: 120, height: 30)
        return gradientLayer
    }()
    
    
    
    func setup(image:UIImage, index:Int, city:String){
        
        DispatchQueue.main.async {
            // cell rounded section
                
            self.cityIndex.text = "Air quality index : \(index)"
            self.cityIndex.numberOfLines = 1;
            self.cityImage.image = image
            self.cityImage.layer.cornerRadius = 7
            self.cityName.text = city
            self.layer.cornerRadius = 10
            //Gradient to add in the cell
            switch index {
            case 1:
                self.uiColor = UIColor.green.cgColor
            case 2:
                self.uiColor = UIColor.yellow.cgColor
            case 3:
                self.uiColor = UIColor.orange.cgColor
            case 4:
                self.uiColor = UIColor.red.cgColor
            case 5:
                self.uiColor = UIColor.purple.cgColor
            default:
                self.uiColor = UIColor.white.cgColor
            }
                
            self.layer.insertSublayer(self.gradient, at: 0)
        }
    }
}
