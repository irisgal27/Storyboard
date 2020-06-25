//
//  AppViewController.swift
//  camaraPrub
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
		var docType: ProccessId
		switch sender.tag {
			case 0:  //Seleccionar el que tipo de documento
				docType = .AnyDocument(documentLbl: "", detailLbl: " ")
			/*case 1:
				docType = .ineFront
			case 2:
				docType = .passport
			case 3:
				docType = .acta
			case 4:
				docType = .Custom(minAspecRatio: 0.4, maxApectRatio: 1.0, documentLbl: "Este es nuevo", detailLbl: "Tienes algo nuevo")*/
			default:
				docType = .acta
				print("Nada")
			
		}
		let docVC = DocumentViewController.captureDocumentViewController(proccessId: docType, delegate: self)
		present(docVC, animated: true, completion: nil)
	}
}

extension AppViewController: DocumentViewControllerDelegate {
	func captureDidFinishWithDocument(_ document: Document, captureVC: DocumentViewController) {
		//croppedAutoImage.image = document.croppedImage
		croppedAutoImage.image = UIImage(data: document.compressed!)
		captureVC.dismiss(animated: true, completion: nil)
	}
	
	func captureDidCancel(captureVC: DocumentViewController) {
		captureVC.dismiss(animated: true, completion: nil)
		
	}
}

