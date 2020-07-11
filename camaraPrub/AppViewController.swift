//
//  AppViewController.swift
//  MotorImages
//
//  Created by mabas on 03/06/20.
//  Copyright © 2020 irisdarka. All rights reserved.
//

import UIKit

class AppViewController: UIViewController {
	
	@IBOutlet weak var croppedAutoImage: UIImageView!
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func pickImage(_ sender: UIButton) {
		var docType = ProccessId
			.anyDocument(documentLbl: "Eqtiqueta de arriba")
		let docVC = DocumentViewController.captureDocumentViewController(proccessId: docType, delegate: self)
		present(docVC, animated: true, completion: nil)
	}
}

extension AppViewController: DocumentComunicacionExternaViewControllerDelegate {
	func captureDidFinishWithDocument(_ document: Document, captureVC: DocumentViewController) {
		croppedAutoImage.image = UIImage(data: document.compressed!)
		captureVC.dismiss(animated: true, completion: nil)
	}

	
	func captureDidCancel(captureVC: DocumentViewController) {
		captureVC.dismiss(animated: true, completion: nil)
		
	}
}

