//
//  HorizontalGradient.swift
//  Aqui
//
//  Created by Dara on 2022-10-30.
//

import UIKit

class HorizontalGradient: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let gradient = CAGradientLayer()

        override init(frame: CGRect) {
            super.init(frame:frame)
            setupGradient(color: UIColor.red)
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupGradient(color: UIColor.red)
        }
        func setupGradient(color: UIColor ) {
            gradient.colors = [
                UIColor.clear.cgColor,
                color.cgColor
            ]
            
            gradient.startPoint = CGPoint(x: 0, y: 0.70)
            gradient.endPoint = CGPoint(x: 1, y: 0.70)

            // don't do this here
            //gradient.frame = bounds
            
            layer.addSublayer(gradient)
        }

        override func layoutSubviews() {
            super.layoutSubviews()

            // do this here
            gradient.frame = bounds
        }
}
