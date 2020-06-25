//
//  Document.swift
//  camaraPrub
//
//  Created by iris on 03/06/20.
//  Copyright © 2020 irisdarka. All rights reserved.
//

import UIKit

public typealias ProccessId = Document.DocumentType

public struct Document {
	public enum DocumentType {
		case acta
		case passport
		case ineFront
		case ineBack
		case AnyDocument(documentLbl: String, detailLbl: String)
		case Custom(minAspecRatio: Float, maxApectRatio: Float, documentLbl: String, detailLbl:String)
	}
	let documentType: DocumentType
	var image : UIImage?
	var cgImage : CGImage?
	var croppedImage: UIImage?
	public var compressed : Data?
   var observation : CGRect?
	public var proccess: DocumentProccess?
}

public struct DocumentProccess: Codable {
	let success: Bool
}
public struct Client {
	let id: String
	let accountNumber: String
	let curp: String
	//idProceso
	//idSubProceso
}
