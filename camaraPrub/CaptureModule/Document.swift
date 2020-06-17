//
//  Document.swift
//  camaraPrub
//
//  Created by iris on 03/06/20.
//  Copyright © 2020 irisdarka. All rights reserved.
//

import UIKit

typealias ProccessId = Document.DocumentType

struct Document {
	enum DocumentType {
		case acta
		case passport
		case ineFront
		case ineBack
	}
	let documentType: DocumentType
	var image : UIImage?
	var cgImage : CGImage?
	var croppedImage: UIImage?
	var compressed : Data?
   var observation : CGRect?

	var proccess: DocumentProccess?
}

struct DocumentProccess: Codable {
	let success: Bool
}

struct Client {
	let id: String
	let accountNumber: String
	let curp: String
	//idProceso
	//idSubProceso
}
