//
//  DocumentViewController.swift
//  camaraPrub
//
//  Created by mabas on 03/06/20.
//  Copyright © 2020 irisdarka. All rights reserved.
//

import UIKit
import AVFoundation

import Vision


public protocol DocumentViewControllerDelegate: NSObjectProtocol {
	func captureDidFinishWithDocument(_ document: Document, captureVC: DocumentViewController)
	func captureDidCancel(captureVC: DocumentViewController)
}

open class DocumentViewController: UIViewController {
	public static func captureDocumentViewController(proccessId: ProccessId, client: Client? = nil, delegate vcDelegate: DocumentViewControllerDelegate) -> UINavigationController {
		//let vc = UIStoryboard(name: "DocumentCamara", bundle: Bundle(identifier: "com.documentCapture")).instantiateViewController(identifier: "captureVC") as! DocumentViewController
		let storyboardBundle = UIStoryboard(name: "DocumentCamera", bundle: Bundle(for: DocumentViewController.self))
		let vc = storyboardBundle.instantiateViewController(identifier: "captureVC") as! DocumentViewController
		
		vc.documentType = proccessId
		vc.doc = Document(documentType: proccessId)

		vc.delegate = vcDelegate
		let navVC = UINavigationController(rootViewController: vc)
		navVC.modalPresentationStyle = .overFullScreen
		return navVC
	}
	
	var delegate: DocumentViewControllerDelegate?
	@IBOutlet weak var viewForTakingPicture: UIImageView!
	@IBOutlet weak var imageLimit: UIImageView!
	@IBOutlet weak var instructionsLbl: UILabel!
	@IBOutlet weak var detailLbl: UILabel!
	
	var documentType: ProccessId = .ineFront
	
	var session = AVCaptureSession()
	private  let deviceOutput = AVCaptureVideoDataOutput()
	var requests = [VNRequest]()
	
	var coincidenceCounter: Int = 0 {
		didSet {
			coincidenceUpdated()
		}
	}
	var lastObservation: VNRectangleObservation?
	var lastBuffer: CVPixelBuffer?
	var observationFrame : CGRect = CGRect.zero
	let stillImage = AVCapturePhotoOutput()
	var doc: Document?
  var imageLayer : CALayer = CALayer()
	@IBAction func close(_ sender: Any) {
		delegate?.captureDidCancel(captureVC: self)
	}
	
}

//MARK: - View Life Cycle
extension DocumentViewController {
	open override func viewDidLoad() {
		super.viewDidLoad()
		switch documentType {
			case .acta:
				imageLimit.image = UIImage(named: "focusActaFrame")
				instructionsLbl.text = "Captura el acta de nacimiento de tu hijo/a"
			case .ineFront:
				imageLimit.image = UIImage(named: "focusIdFrame")
				instructionsLbl.text = "Captura tu identificación oficial"
			
			case .ineBack:
				imageLimit.image = UIImage(named: "focusIdFrame")
				instructionsLbl.text = "Captura la parte trasera de tu identificación oficial"
			case .passport:
				imageLimit.image = UIImage(named: "focusPassport")
				instructionsLbl.text = "Captura tu identificación oficial"
		}
    configureSession()
	}
	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
	}
	open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
    startStream()
  }
}

//MARK: - AV Session
extension DocumentViewController {
  func configureSession(){
    session.sessionPreset = AVCaptureSession.Preset.photo
    guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else{return}
    let deviceInput = try! AVCaptureDeviceInput(device: captureDevice)
    if(captureDevice.isFocusModeSupported(.continuousAutoFocus)) {
      try! captureDevice.lockForConfiguration()
      captureDevice.focusMode = .continuousAutoFocus
      captureDevice.unlockForConfiguration()
    }
    if captureDevice.hasTorch{
      do{
        try captureDevice.lockForConfiguration()
        captureDevice.torchMode = .auto
        captureDevice.unlockForConfiguration()
      }catch{
        print("torch couldn´t be used")
      }
    }
    self.deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
    self.deviceOutput.alwaysDiscardsLateVideoFrames = true
    self.deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
    self.session.addInput(deviceInput)
    self.session.addOutput(deviceOutput)
    session.addOutput(stillImage)
    session.sessionPreset = .photo

    imageLayer = AVCaptureVideoPreviewLayer(session: session)
  }
	func startStream() {
		imageLayer.frame = viewForTakingPicture.bounds
		viewForTakingPicture.layer.addSublayer(imageLayer)
    coincidenceCounter = 0
    session.startRunning()
	}
	
	func startSearchingRect(in image: CVPixelBuffer) {
		let rectDetectRequest = VNDetectRectanglesRequest(completionHandler:{(request: VNRequest, erro: Error?) in DispatchQueue.main.async {
			guard let observations = request.results as? [VNRectangleObservation] else{return}
			guard let observation = observations.first else {return}
			self.lastObservation = observation
			self.lastBuffer = image
			self.frameDidDetected(box: observation)
			}
		})
		let minimumAspectRatio: Float
		let maximumAspectRatio: Float
		let orientation: CGImagePropertyOrientation
		switch documentType {
			case .acta:
				minimumAspectRatio = 0.50
				maximumAspectRatio = 0.88
				orientation = .up
			case .ineFront, .ineBack:
				minimumAspectRatio = 0.48
				maximumAspectRatio = 0.74
				orientation = .right
			case .passport:
				minimumAspectRatio = 0.62
				maximumAspectRatio = 0.82
				orientation = .right
		}
		rectDetectRequest.maximumObservations = 1
		rectDetectRequest.minimumAspectRatio = minimumAspectRatio
		rectDetectRequest.maximumAspectRatio = maximumAspectRatio
		rectDetectRequest.minimumSize =  0.5
    rectDetectRequest.minimumConfidence = 0.8
		let imageRequestHAndler = VNImageRequestHandler(cvPixelBuffer: image, orientation: orientation, options: [:])
		try? imageRequestHAndler.perform([rectDetectRequest])
	}
	
	func frameDidDetected(box: VNRectangleObservation) {
		self.imageLimit.layer.sublayers?.removeSubrange(1...)
		let scaleHeight = view.frame.width / imageLimit.frame.width * imageLimit.frame.height
		let x = imageLimit.frame.width * box.boundingBox.origin.x
		let height = imageLimit.frame.height * box.boundingBox.height
		let y = scaleHeight * (1 - box.boundingBox.origin.y) - height
		let witdh  = imageLimit.frame.width * box.boundingBox.width
		let detectedFrame = CGRect(x: x , y: y, width: witdh , height: height)
		
		let dato = imageLimit.convert(detectedFrame, to: self.viewForTakingPicture)
		let containsView = imageLimit.convert(detectedFrame, to: self.imageLimit)
    	//print("containsView ---------------",containsView)
		//print("imageLimit------------------",imageLimit.frame)
		let aspectRatio = dato.size.width / dato.size.height
		let outerREct =  self.imageLimit.bounds
		let innerTRECtLimit = self.imageLimit.bounds
		//    print("outerREct-----------------",outerREct)
		//    print("DAto----------------------",dato)
		let outline = CALayer()
		outline.frame = CGRect(x: x , y: y, width: witdh , height: height)
		observationFrame = dato
		//print(outline.frame)
		outline.borderWidth = 3
		outline.borderColor = UIColor.blue.cgColor
		//print("outlone: ----------    ",outline.frame)
    // imageLimit.layer.addSublayer(outline)

		
		//print("Box ratio: \(box.boundingBox.size.height / box.boundingBox.size.width), aspectRatio: \(aspectRatio)")
		//coincidenceCounter += 1
		
		if outerREct.contains(dato) {
			//coincidenceCounter += 1
    //  print("si esta en el cuadro")
    }

		if aspectRatio > 1.1 && aspectRatio < 1.7 {
			//print("Es probable que sea una tarjeta")
			if innerTRECtLimit.contains(containsView) {
				//print("Se tomara foto de tarjeta---------------")
			}
			coincidenceCounter += 1

			//coincidenceCounter += 1
			
			//print("Cupo en el aspect")
			//let innerRect = CGRect(x: outerREct.origin.x + 80, y: outerREct.origin.y + 80, width: outerREct.size.width - 160, height: outerREct.size.height - 160)
			
		}
		else if aspectRatio > 0.66 && aspectRatio < 0.91 {
			//print("Es probable que  una un acta")
     // print("apectRatio----------",aspectRatio)
			//coincidenceCounter += 1
			
			//print(viewForTakingPicture.frame)
			//if(viewForTakingPicture.frame.contains(outline.frame)){
			//	print("Contains-----------------------------------Acta en posicion")
				coincidenceCounter += 1
				//print("Esta dentro ")
				//let innerRect = CGRect(x: outerREct.origin.x + 80, y: outerREct.origin.y + 80, width: outerREct.size.width - 160, height: outerREct.size.height - 160)
			//}
		}
		else {
			//coincidenceCounter = 0
		}
	}
	
/*	func coincidenceUpdated() {
		print(coincidenceCounter)
		if coincidenceCounter == 5 {
			session.stopRunning()
			guard let buffer = lastBuffer/*, let observation = lastObservation*/ else {
				return
			}
			DispatchQueue.main.async {
				let ciImage = CIImage(cvImageBuffer: buffer).oriented(CGImagePropertyOrientation.right)
				let output = UIImage(ciImage: ciImage)
				self.doc?.cgImage = ciImage.getCgImage()
				self.doc?.image = output
				self.doc?.observation = self.observationFrame
				self.doc?.proccess = DocumentProccess(success: true)
				
				
				let nuevaImagenShow = self.storyboard?.instantiateViewController(withIdentifier:"cropView") as! CropViewController
				nuevaImagenShow.document = self.doc
				nuevaImagenShow.delegate = self
				self.navigationController?.pushViewController(nuevaImagenShow, animated: true)
			}
			
		}
	}*/
}

//corta Automaticamente esta función no borrar

extension DocumentViewController {
	func coincidenceUpdated() {
		print(coincidenceCounter)
		if coincidenceCounter == 3{
			let settings = AVCapturePhotoSettings()
			let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
			let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
										kCVPixelBufferWidthKey as String: 160,
										kCVPixelBufferHeightKey as String: 160]
			settings.previewPhotoFormat = previewFormat
			stillImage.capturePhoto(with: settings, delegate: self)
		
			
			//session.stopRunning()
			
		}
  }
}


extension DocumentViewController : AVCaptureVideoDataOutputSampleBufferDelegate {
	public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
		guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
			return
		}
		self.startSearchingRect(in: pixelBuffer)
		var requestOptions:[VNImageOption : Any] = [:]
		
		if let camData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
			requestOptions = [.cameraIntrinsics:camData]
		}
		
		let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation.up, options: requestOptions)
		
		do {
			try imageRequestHandler.perform(self.requests)
		} catch {
			print(error)
		}
	}
}

extension DocumentViewController: CropViewControllerDelegate {
	func documentDidCropped(_ document: Document) {
		doc = document
		delegate!.captureDidFinishWithDocument(document, captureVC: self)
	}
}

extension CGPoint{
  func scaled(size: CGSize) -> CGPoint {
    //print("CGPoint---",CGPoint(x: self.x * size.width-100 ,y: self.y * size.height))
    return CGPoint(x: self.x * size.width, y: self.y * size.height)
 }
}

extension DocumentViewController: AVCapturePhotoCaptureDelegate {
	public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
		let imageData = photo.fileDataRepresentation()
		if let data = imageData, let img = UIImage(data: data) {
			guard let buffer = lastBuffer ,let obbservation = lastObservation else {
				return
			}
			//print("buffer-------------------",buffer)
			//print("CIIMAGE-------------------",ciImage)
			//doc?.image = UIImage(ciImage: ciImage)
			//let img = UIImage(ciImage: ciImage)
			//let dato = Document(image: img, proccess: DocumentProccess(success: true))
			
			DispatchQueue.main.async {
				
				var ciImage = CIImage(data: data)!.oriented(CGImagePropertyOrientation.right)//CIImage(cvImageBuffer: buffer)
				/*var topLeft = obbservation.topLeft.scaled(size: ciImage.extent.size)
				var topRight = obbservation.topRight.scaled(size: ciImage.extent.size)
				var bottomLeft = obbservation.bottomLeft.scaled(size: ciImage.extent.size)
				var bottomRight = obbservation.bottomRight.scaled(size: ciImage.extent.size)
				
				print("top",topLeft,topRight,bottomLeft,bottomRight)
				ciImage = ciImage.applyingFilter("CIPerspectiveCorrection", parameters: [
					"inputTopLeft": CIVector(cgPoint: topLeft),
					"inputTopRight": CIVector(cgPoint: topRight),
					"inputBottomLeft": CIVector(cgPoint: bottomLeft),
					"inputBottomRight": CIVector(cgPoint: bottomRight),
				])*/
				let context = CIContext()
				let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
				let output = UIImage(ciImage: ciImage)
				self.doc?.cgImage = ciImage.getCgImage()
				self.doc?.image = output
				self.doc?.observation = self.observationFrame
				self.doc?.proccess = DocumentProccess(success: true)
				let nuevaImagenShow = self.storyboard?.instantiateViewController(withIdentifier:"cropView") as! CropViewController
				nuevaImagenShow.document = self.doc
				nuevaImagenShow.delegate = self
				self.navigationController?.pushViewController(nuevaImagenShow, animated: true)
			}
			//session.stopRunning()
		}
	}
	
	public func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
	}
}

