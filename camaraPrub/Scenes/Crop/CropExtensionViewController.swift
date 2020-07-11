//
//  CropExtensionViewController.swift
//  MotorImages
//
//  Created by iris on 05/07/20.
//  Copyright © 2020 iris. All rights reserved.
//

import UIKit

extension CropViewController{
	@objc func panDetected(sender: UIPanGestureRecognizer) {
		
		let touch = sender.location(in: view)
		switch sender.state {
			case .began:
				puntoInicio = touch
				if bottomRight.frame.contains(touch){
					workView = bottomRight
				}
				if bottomLeft.frame.contains(touch){
					workView = bottomLeft
				}
				if topLeft.frame.contains(touch){
					workView = topLeft
				}
				if topRight.frame.contains(touch){
					workView = topRight
				}
				if top.frame.contains(touch){
					workView = top
				}
				if right.frame.contains(touch) {
					workView = right
				}
				if botom.frame.contains(touch){
					workView = botom
				}
				if left.frame.contains(touch){
					workView = left
			}
			case .changed:
				if let view = workView {
					let xfinal = (touch.x - puntoInicio.x)
					let yfinal = (touch.y - puntoInicio.y)
					
					if view == bottomRight {
						
						view.center = CGPoint(x: puntoInicio.x + xfinal, y: puntoInicio.y + yfinal)
						topRight.center = CGPoint(x: self.bottomRight.center.x, y: self.topRight.center.y)
						right.center = CGPoint(x: self.bottomRight.center.x , y: (topRight.center.y + bottomRight.center.y)/2 )
						botom.center = CGPoint(x: (bottomLeft.center.x + bottomRight.center.x)/2, y: self.bottomRight.center.y)
						bottomLeft.center = CGPoint(x: self.bottomLeft.center.x, y: self.bottomRight.center.y)
						top.center = CGPoint(x: (self.topRight.center.x + self.topLeft.center.x)/2, y: self.topRight.center.y)
						left.center = CGPoint(x: self.bottomLeft.center.x, y: (topLeft.center.y + bottomLeft.center.y)/2)
						imageCentral.frame = CGRect(x: topLeft.center.x, y: topLeft.center.y, width: topRight.center.x - topLeft.center.x, height: bottomLeft.center.y - topLeft.center.y)
						
					}
					else if view == topRight {
						view.center = CGPoint(x: puntoInicio.x + xfinal, y: puntoInicio.y + yfinal)
						bottomRight.center = CGPoint(x: self.topRight.center.x, y: self.bottomRight.center.y)
						right.center = CGPoint(x: self.bottomRight.center.x , y: (topRight.center.y + bottomRight.center.y)/2 )
						topLeft.center = CGPoint(x: self.topLeft.center.x, y: self.topRight.center.y)
						top.center = CGPoint(x: (self.topRight.center.x + self.topLeft.center.x)/2, y: self.topRight.center.y)
						botom.center = CGPoint(x: (bottomLeft.center.x + bottomRight.center.x)/2, y: self.bottomRight.center.y)
						left.center = CGPoint(x: self.bottomLeft.center.x, y: (topLeft.center.y + bottomLeft.center.y)/2)
						imageCentral.frame = CGRect(x: topLeft.center.x, y: topLeft.center.y, width: topRight.center.x - topLeft.center.x, height: bottomLeft.center.y - topLeft.center.y)
						
					}
					else if view == bottomLeft {
						view.center = CGPoint(x: puntoInicio.x + xfinal, y: puntoInicio.y + yfinal)
						topLeft.center = CGPoint(x: self.bottomLeft.center.x, y: self.topLeft.center.y)
						left.center = CGPoint(x: self.bottomLeft.center.x, y: (topLeft.center.y + bottomLeft.center.y)/2)
						bottomRight.center = CGPoint(x: self.bottomRight.center.x, y: self.bottomLeft.center.y)
						botom.center = CGPoint(x:(bottomLeft.center.x + bottomRight.center.x)/2, y: self.bottomLeft.center.y)
						top.center = CGPoint(x: (self.topRight.center.x + self.topLeft.center.x)/2, y: self.topRight.center.y)
						right.center = CGPoint(x: self.bottomRight.center.x , y: (topRight.center.y + bottomRight.center.y)/2 )
						imageCentral.frame = CGRect(x: topLeft.center.x, y: topLeft.center.y, width: topRight.center.x - topLeft.center.x, height: bottomLeft.center.y - topLeft.center.y)
					}
					else if view == topLeft{
						view.center = CGPoint(x: puntoInicio.x + xfinal, y: puntoInicio.y + yfinal)
						topRight.center = CGPoint(x: self.topRight.center.x, y: self.topLeft.center.y)
						top.center = CGPoint(x: (topLeft.center.x + topRight.center.x)/2, y: self.topLeft.center.y)
						bottomLeft.center = CGPoint(x: self.topLeft.center.x, y: self.bottomLeft.center.y)
						left.center = CGPoint(x: self.topLeft.center.x, y: (self.topLeft.center.y + self.bottomLeft.center.y)/2)
						right.center = CGPoint(x: self.bottomRight.center.x , y: (topRight.center.y + bottomRight.center.y)/2 )
						botom.center = CGPoint(x:(bottomLeft.center.x + bottomRight.center.x)/2, y: self.bottomLeft.center.y)
						imageCentral.frame = CGRect(x: topLeft.center.x, y: topLeft.center.y, width: topRight.center.x - topLeft.center.x, height: bottomLeft.center.y - topLeft.center.y)
					}
					else if view == top{
						view.center = CGPoint(x: puntoInicio.x, y: puntoInicio.y + yfinal)
						topLeft.center = CGPoint(x: self.topLeft.center.x, y: self.top.center.y)
						topRight.center = CGPoint(x: self.topRight.center.x, y: self.top.center.y)
						imageCentral.frame = CGRect(x: topLeft.center.x, y: topLeft.center.y, width: topRight.center.x - topLeft.center.x, height: bottomLeft.center.y - topLeft.center.y)
						left.center = CGPoint(x: self.topLeft.center.x, y: (self.topLeft.center.y + self.bottomLeft.center.y)/2)
						right.center = CGPoint(x: self.bottomRight.center.x , y: (topRight.center.y + bottomRight.center.y)/2 )
						
					}
					else if view == botom{
						view.center = CGPoint(x: puntoInicio.x, y: puntoInicio.y + yfinal)
						bottomLeft.center = CGPoint(x: self.bottomLeft.center.x, y: self.botom.center.y)
						bottomRight.center = CGPoint(x: self.bottomRight.center.x, y: self.botom.center.y)
						imageCentral.frame = CGRect(x: topLeft.center.x, y: topLeft.center.y, width: topRight.center.x - topLeft.center.x, height: bottomLeft.center.y - topLeft.center.y)
						left.center = CGPoint(x: self.topLeft.center.x, y: (self.topLeft.center.y + self.bottomLeft.center.y)/2)
						right.center = CGPoint(x: self.bottomRight.center.x , y: (topRight.center.y + bottomRight.center.y)/2 )
					}
					else if view == left{
						view.center = CGPoint(x: puntoInicio.x + xfinal, y: puntoInicio.y)
						topLeft.center = CGPoint(x: self.left.center.x, y: self.topLeft.center.y)
						bottomLeft.center = CGPoint(x: self.left.center.x, y: self.bottomLeft.center.y)
						imageCentral.frame = CGRect(x: topLeft.center.x, y: topLeft.center.y, width: topRight.center.x - topLeft.center.x, height: bottomLeft.center.y - topLeft.center.y)
						top.center = CGPoint(x: (topLeft.center.x + topRight.center.x)/2, y: self.topLeft.center.y)
						botom.center = CGPoint(x:(bottomLeft.center.x + bottomRight.center.x)/2, y: self.bottomLeft.center.y)

					}
					else if view == right{
						view.center = CGPoint(x: puntoInicio.x + xfinal, y: puntoInicio.y)
						topRight.center = CGPoint(x: self.right.center.x, y: self.topRight.center.y)
						bottomRight.center = CGPoint(x: self.right.center.x, y: self.bottomRight.center.y)
						imageCentral.frame = CGRect(x: topLeft.center.x, y: topLeft.center.y, width: topRight.center.x - topLeft.center.x, height: bottomLeft.center.y - topLeft.center.y)
						top.center = CGPoint(x: (topLeft.center.x + topRight.center.x)/2, y: self.topLeft.center.y)
						botom.center = CGPoint(x:(bottomLeft.center.x + bottomRight.center.x)/2, y: self.bottomLeft.center.y)
					}
			}
			case .ended:
				workView = nil
			
			case .cancelled:
				workView = nil
			
			default:
				print("State", sender.state)
		}
	}
	func calculoRect() -> CGRect {
		guard let imageSize = imageView.image?.size else {
			return  CGRect.zero
		}
		var maxL : CGFloat = 0.0
		var min  : CGFloat = 0.0
		
		let ratio = imageSize.width / imageSize.height
		let viewRatio = imageView.frame.size.width / imageView.frame.size.height
		let deltaW =  imageSize.width / imageView.frame.width
		var espacioBlanco : CGFloat = 0
		let newIH = imageSize.height / deltaW
		let newIW = imageSize.width / deltaW
		
		//var puntoTL : CGPoint = CGPoint(x: topLeft.frame.origin.x, y: topLeft.frame.origin.y)
		// var puntoBR : CGPoint = CGPoint(x: bottomRight.frame.origin.x + bottomRight.frame.size.width, y: bottomRight.frame.origin.y + bottomRight.frame.size.height)
		var puntoTL : CGPoint = CGPoint(x: imageCentral.frame.origin.x, y: imageCentral.frame.origin.y)
		var puntoBR : CGPoint = CGPoint(x: imageCentral.frame.origin.x + imageCentral.frame.size.width, y: imageCentral.frame.origin.y + imageCentral.frame.size.height)
		
		puntoTL = view.convert(puntoTL, to: imageView)
		puntoBR = view.convert(puntoBR, to: imageView)
		
		if ratio > viewRatio {
			maxL = imageSize.width
			min =  imageSize.height
			espacioBlanco =  (imageView.frame.size.height - newIH) / 2
			puntoTL.y = puntoTL.y - espacioBlanco
			puntoBR.y =  puntoBR.y - espacioBlanco
		}
		else{
			maxL = imageSize.height
			min =  imageSize.width
			espacioBlanco =  (imageView.frame.size.width - newIW) / 2
			puntoTL.x = puntoTL.x - espacioBlanco
			puntoBR.x  = puntoBR.x - espacioBlanco
		}
		puntoTL.x = puntoTL.x < 0 ? 0 : puntoTL.x
		puntoTL.y = puntoTL.y < 0 ? 0 : puntoTL.y
		
		let porcentajes = CGRect(x: puntoTL.x / newIW, y: puntoTL.y / newIH, width: (puntoBR.x / newIW) - (puntoTL.x / newIW), height: (puntoBR.y / newIH) - (puntoTL.y / newIH))
		
		let inImage = CGRect(x: porcentajes.origin.x * imageSize.width, y: porcentajes.origin.y * imageSize.height, width: porcentajes.size.width * imageSize.width, height: porcentajes.size.height * imageSize.height)
		
		return inImage
	}
	
}
extension CropViewController{
	func imageRedonda(){
		botom.makeRoundCorner()
		top.makeRoundCorner()
		left.makeRoundCorner()
		right.makeRoundCorner()
		bottomLeft.makeRoundCorner()
		bottomRight.makeRoundCorner()
		topRight.makeRoundCorner()
		topLeft.makeRoundCorner()
	}
	func imageCentralComportamiento() {
		imageCentral.frame = CGRect(x: topLeft.center.x, y: topLeft.center.y, width: topRight.center.x - topLeft.center.x, height: bottomLeft.center.y - topLeft.center.y)
		self.imageCentral.layer.borderWidth = 1
		self.imageCentral.layer.borderColor = UIColor(red: 0/255, green: 75/255, blue: 141/255, alpha: 1).cgColor
	}
	
}
