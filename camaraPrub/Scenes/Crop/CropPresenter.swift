//
//  CropPresenter.swift
//  MotorImages
//
//  Created by iris on 05/07/20.
//  Copyright (c) 2020 iris. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CropPresentationLogic
{
  func presentImageToCrop(response: Crop.Something.Response)
	func cropFinished()
}

class CropPresenter: CropPresentationLogic
{
	func cropFinished() {
		viewController!.displayCropFinish()
	}
	
  weak var viewController: CropDisplayLogic?
  
  // MARK: Do something
  
  func presentImageToCrop(response: Crop.Something.Response)
  {
	let viewModel = Crop.Something.ViewModel(imagenRecibida: response.imagenRecibida, imagenRecibidaCG: response.imagenRecibidaCG)
    viewController?.displayImage(viewModel: viewModel)
  }
}