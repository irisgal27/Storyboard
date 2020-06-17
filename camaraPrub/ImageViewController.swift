//
//  ImageViewController.swift
//  camaraPrub
//
//  Created by iris on 03/06/20.
//  Copyright © 2020 irisdarka. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
      let pickerController = UIImagePickerController()
      pickerController.delegate = self
      pickerController.allowsEditing = true
      
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
