//
//  ImageUtilities.swift
//  camaraPrub
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
