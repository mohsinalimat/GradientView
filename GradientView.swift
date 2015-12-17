//
//  GradientView.swift
//  headlines
//
//  Created by Ethem Ozcan on 22/11/15.
//  Copyright © 2015 Ethem Ozcan. All rights reserved.
//

import UIKit

public enum GradientDirection{
	case leftToRight
	case rightToLeft
	case topToBottom
	case bottomToTop
}

@IBDesignable
class GradientView: UIView {

	@IBInspectable var gradientColor : UIColor = UIColor.clearColor(){
		didSet{
			self.setNeedsDisplay()
		}
	}

	@IBInspectable var level : CGFloat = 1.0{
		didSet{
			if level > 1 {
				level = 1.0
			}
			self.setNeedsDisplay()
		}
	}

	var direction : GradientDirection = .rightToLeft{
		didSet{
			self.setNeedsDisplay()
		}
	}

	static func viewWithRect(rect: CGRect, gradientColor: UIColor, direction: GradientDirection, level: CGFloat) -> GradientView{
		let g = GradientView.init(frame: rect)
		g.level = level
		g.direction = direction
		g.gradientColor = gradientColor
		g.backgroundColor = UIColor.clearColor()
		return g
	}

	override func drawRect(rect: CGRect) {
		let context = UIGraphicsGetCurrentContext()
		drawLinearGradient(context!, rect: rect)
	}

	func drawLinearGradient(context: CGContextRef,rect: CGRect){

		let colorSpace = CGColorSpaceCreateDeviceRGB()

		let locations : [CGFloat] = [0, level * 0.5, level * 0.6, level * 0.8, level * 1.0]
		let colors = [
			gradientColor.CGColor,
			gradientColor.colorWithAlphaComponent(level * 0.5).CGColor,
			gradientColor.colorWithAlphaComponent(level * 0.2).CGColor,
			gradientColor.colorWithAlphaComponent(level * 0.1).CGColor,
			gradientColor.colorWithAlphaComponent(level * 0.005).CGColor
		]

		let gradient = CGGradientCreateWithColors(colorSpace, colors, locations)

		var startPoint : CGPoint
		var endPoint : CGPoint

		switch direction
		{
		case .leftToRight:
			startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect))
			endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect))

		case .rightToLeft:
			startPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect))
			endPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect))

		case .topToBottom:
			startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect))
			endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect))

		case .bottomToTop:
			startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect))
			endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect))
		}

		CGContextSaveGState(context)
		CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, .DrawsBeforeStartLocation)
		CGContextRestoreGState(context)
	}
}

