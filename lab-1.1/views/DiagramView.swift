//
//  DiagramView.swift
//  lab-1.1
//
//  Created by Kirill on 10.02.2021.
//

import UIKit

class DiagramView: UIView {
    
    override func draw(_ rect: CGRect) {
        
        let segmentsArray: [(UIColor, Double)] = [(.cyan, 0.45),
                                                  (.purple, 0.05),
                                                  (.yellow, 0.25),
                                                  (.gray, 0.25)]
        let rectWidth: CGFloat = rect.width
        let rectHeight: CGFloat = rect.width
        let center = CGPoint(x: rectWidth / 2, y: rectHeight / 2)
        let radius = rect.width / 2.2
        
        var startAngle = CGFloat(0)
        for (color, value) in segmentsArray {
            let segment = UIBezierPath()
            let endAngle = startAngle + (360 * CGFloat(value) * CGFloat(Double.pi) / 180)
            
            segment.addArc(withCenter: center,
                           radius: radius,
                           startAngle: startAngle,
                           endAngle: endAngle,
                           clockwise: true)
            
            segment.addArc(withCenter: center,
                           radius: radius / 2,
                           startAngle: endAngle,
                           endAngle: startAngle,
                           clockwise: false)
            
            color.setFill()
            color.setStroke()
            segment.fill()
            segment.stroke()
            
            startAngle = endAngle
        }
        
    }
    
    
    
}
