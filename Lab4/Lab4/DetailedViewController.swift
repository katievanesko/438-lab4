//
//  DetailedViewController.swift
//  Lab4
//
//  Created by Katie Vanesko on 11/6/20.
//  Copyright © 2020 Katie Vanesko. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

    var image: UIImage!
       var imageName: String!
       override func viewDidLoad() {
           super.viewDidLoad()
           // Do any additional setup after loading the view.
           
           let imageFrame = CGRect(x: view.frame.midX - image.size.width/2, y: view.frame.midY - image.size.width/2, width: image.size.width, height: image.size.height)
           
           let imageView = UIImageView(frame: imageFrame)
           
           imageView.image = image
           view.addSubview(imageView)
           
           let textFrame = CGRect(x: 0, y: image.size.height + 120, width: view.frame.width, height: 30)
           let textView = UILabel(frame: textFrame)
           textView.text = imageName
           textView.textAlignment = .center
           view.addSubview(textView)
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
