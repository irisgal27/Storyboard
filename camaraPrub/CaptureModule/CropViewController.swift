//
//  CropViewController.swift
//  ViewForCrop
//
//  Created by iris on 06/06/20.
//  Copyright © 2020 iris. All rights reserved.
//

import UIKit

protocol CropViewControllerDelegate {
	func documentDidCropped(_ document: Document)

}

class CropViewController: UIViewController, UIGestureRecognizerDelegate{
	var delegate: CropViewControllerDelegate?
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var bottomLeft: UIImageView!
	@IBOutlet weak var topLeft: UIImageView!
	@IBOutlet weak var topRight: UIImageView!
	@IBOutlet weak var bottomRight: UIImageView!
	var puntoInicio: CGPoint = CGPoint(x: 0, y: 0)
	@IBOutlet var panGesture: UIPanGestureRecognizer!
	var workView : UIImageView? = nil
	var cuadroVerde : CGRect = CGRect.zero
	var document: Document? {
		didSet(doc) {
			
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		panGesture = UIPanGestureRecognizer(target: self, action: #selector(panDetected(sender:)))
		view?.addGestureRecognizer(panGesture!)
		panGesture?.delegate = self
    imageView.image = UIImage(cgImage: (document?.cgImage)!)
		cuadroVerde = document?.observation ?? CGRect.zero
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
	}
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: false)
	 navigationController?.interactivePopGestureRecognizer?.isEnabled = false

  }
	
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
      case .changed:
        
        if let view = workView {
          let xfinal = (touch.x - puntoInicio.x)
          let yfinal = (touch.y - puntoInicio.y)
          view.center = CGPoint(x: puntoInicio.x + xfinal, y: puntoInicio.y + yfinal)
          if view == bottomRight {
            topRight.center = CGPoint(x: self.bottomRight.center.x, y: self.topRight.center.y)
            bottomLeft.center = CGPoint(x: self.bottomLeft.center.x, y: self.bottomRight.center.y)
          }
          else if view == topRight {
            bottomRight.center = CGPoint(x: self.topRight.center.x, y: self.bottomRight.center.y)
            topLeft.center = CGPoint(x: self.topLeft.center.x, y: self.topRight.center.y)
          }
          else if view == bottomLeft {
            topLeft.center = CGPoint(x: self.bottomLeft.center.x, y: self.topLeft.center.y)
            bottomRight.center = CGPoint(x: self.bottomRight.center.x, y: self.bottomLeft.center.y)
          }
          else if view == topLeft{
            topRight.center = CGPoint(x: self.topRight.center.x, y: self.topLeft.center.y)
            bottomLeft.center = CGPoint(x: self.topLeft.center.x, y: self.bottomLeft.center.y)
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
    
    var puntoTL : CGPoint = CGPoint(x: topLeft.frame.origin.x, y: topLeft.frame.origin.y)
    var puntoBR : CGPoint = CGPoint(x: bottomRight.frame.origin.x + bottomRight.frame.size.width, y: bottomRight.frame.origin.y + bottomRight.frame.size.height)

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

	@IBAction func cutImage(_ sender: Any) {
		guard let imageRef = document?.cgImage,
		var doc = document,
		let image = doc.image
		
		else {
			return
		}
		let calculo = calculoRect()
			if let croppedImage = imageRef.cropping(to: calculo) {
        let image: UIImage = UIImage(cgImage: croppedImage, scale: image.scale, orientation: image.imageOrientation)
				doc.compressed = image.compressed()
				doc.croppedImage = image
			}else{
				print("No se pudo cotar")
			}
 
    delegate!.documentDidCropped(doc)
      
  }
  
  
  
}




