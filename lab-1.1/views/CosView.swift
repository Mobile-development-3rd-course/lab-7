//
//  cosView.swift
//  lab-1.1
//
//  Created by Kirill on 09.02.2021.
//

import UIKit

class CosView: UIView {
    // MARK: - Colors
    let blackColor = UIColor.black
    let blueColor = UIColor.blue
    
    // MARK: - Main draw function
    override func draw(_ rect: CGRect) {
        let rectWidth = rect.width
        let rectHeight = rect.height
        
        designCoordinates(rect, rectWidth, rectHeight)
        designCos(rect, rectWidth, rectHeight)
    }
    
    // MARK: Cos(x)
    private func designCos(_ rect: CGRect, _ rectWidth: CGFloat, _ rectHeight: CGFloat) {
        let origin = CGPoint(x: rectWidth * (1 - 1.1 ) / 2, y: rectHeight * 0.50)
        let cosFunc = UIBezierPath()
        cosFunc.move(to: origin)
        
        for angle in stride(from: 5.0, through: 360.0, by: 5) {
            let x = origin.x + CGFloat(angle / 360.0) * rectWidth * 1.1
            let y = origin.y - CGFloat(-cos(angle / 180.0 * Double.pi)) * rectHeight * 0.2
            cosFunc.addLine(to: CGPoint(x: x, y: y))
        }
        
        blueColor.setStroke()
        cosFunc.stroke()
    }
    
    // MARK: - Coordinates
    private func designCoordinates (_ rect: CGRect, _ rectWidth: CGFloat, _ rectHeight: CGFloat) {
        let rectCenter: CGPoint = CGPoint(x: rectWidth / 2, y: rectHeight / 2)
        let coordinates = UIBezierPath()
        
        // Coordinate X
        coordinates.move(to: CGPoint(x: 0, y: rectCenter.y))
        coordinates.addLine(to: CGPoint(x: rectHeight, y: rectCenter.y))
        coordinates.move(to: CGPoint(x: rectWidth / 2 - 8, y: rectHeight / 2 - rectHeight * 0.2))
        coordinates.addLine(to: CGPoint(x: rectWidth / 2 + 8, y: rectHeight / 2 - rectHeight * 0.2))
        // Coordinate Y
        coordinates.move(to: CGPoint(x: rectCenter.x, y: 0))
        coordinates.addLine(to: CGPoint(x: rectCenter.x, y: rectWidth))
        

        coordinates.move(to: CGPoint(x: rectWidth / 2 + rectWidth * 0.2, y: rectHeight / 2 - 8))
        coordinates.addLine(to: CGPoint(x: rectWidth / 2 + rectWidth * 0.2, y: rectHeight / 2 + 8))
        
        // Arrows
        coordinates.move(to: CGPoint(x: rectCenter.x, y: 0))
        coordinates.addLine(to: CGPoint(x: rectCenter.x + 10, y: 10))
        coordinates.addLine(to: CGPoint(x: rectCenter.x - 10, y: 10))
        coordinates.addLine(to: CGPoint(x: rectCenter.x, y: 0))
        
        coordinates.move(to: CGPoint(x: rectWidth, y: rectCenter.y))
        coordinates.addLine(to: CGPoint(x: rectWidth - 10, y: rectCenter.y + 10))
        coordinates.addLine(to: CGPoint(x: rectWidth - 10, y: rectCenter.y - 10))
        coordinates.addLine(to: CGPoint(x: rectWidth, y: rectCenter.y))
        
        coordinates.lineWidth = 1
        blackColor.setStroke()
        coordinates.stroke()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
