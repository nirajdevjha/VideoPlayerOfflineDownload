//
//  CircularProgressbarView.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 14/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

@IBDesignable class CircularProgressbarView: UIView {

    var bgPath: UIBezierPath!
    var shapeLayer: CAShapeLayer!
    var progressLayer: CAShapeLayer!
    
    var progress: Float = 0 {
        willSet(newValue) {
            debugPrint("newValue\(newValue)")
            progressLayer.strokeEnd = CGFloat(newValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgPath = UIBezierPath()
        self.simpleShape()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bgPath = UIBezierPath()
        self.simpleShape()
    }
    
    func simpleShape() {
        createCirclePath()
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bgPath.cgPath
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0).cgColor
        
        progressLayer = CAShapeLayer()
        progressLayer.path = bgPath.cgPath
        progressLayer.lineCap = CAShapeLayerLineCap.round
        progressLayer.lineWidth = 5
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor(red: 0/255, green: 140/255, blue: 255/255, alpha: 1.0).cgColor
        progressLayer.strokeEnd = 0.0
                
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(progressLayer)
    }
    
    private func createCirclePath() {
        let x = CGFloat(26)
        let y = CGFloat(26)
        let center = CGPoint(x: x, y: y)
        print(x,y,center)
        bgPath.addArc(withCenter: center, radius: x/CGFloat(2), startAngle: CGFloat(0), endAngle: CGFloat(6.28), clockwise: true)
        bgPath.close()
    }
}

