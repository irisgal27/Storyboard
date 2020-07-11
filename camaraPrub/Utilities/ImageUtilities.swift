//
//  ImageUtilities.swift
//  MotorImages
//
//  Created by iris on 12/06/20.
//  Copyright © 2020 irisdarka. All rights reserved.
//

import UIKit

extension CIImage {
	func getCgImage() -> CGImage? {
		let context = CIContext(options: nil)
		if let cgImage = context.createCGImage(self, from: self.extent) {
			return cgImage
		}
		return nil
	}
}
extension UIImage{
	typealias Kilobytes = Double
	func compressed(to newWeight: Kilobytes = 1024) -> Data {
		if let image : Data = self.jpegData(compressionQuality: 1){
			let KBsize = Double(image.count)/8/1024
			if KBsize  > newWeight {
				let compressImage = Double(newWeight/KBsize)
				let newImage = self.jpegData(compressionQuality: CGFloat(compressImage))
				//let base64String = newImage?.base64EncodedData()
				return newImage ?? Data()
			}else{
				//let base64String = image.base64EncodedData()
				return image
			}
		}
		return Data()
	}
}
extension UIImageView{
	func makeRoundCorner(){
		self.layer.cornerRadius = self.frame.width/2
		self.layer.borderWidth = 2
		self.layer.borderColor = UIColor(red: 1/255, green: 129/255, blue: 196/255, alpha: 1).cgColor
		self.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 255, green: 255, blue: 255, alpha: 0.3))
	}
}

