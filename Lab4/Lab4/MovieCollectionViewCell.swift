//
//  MovieCollectionViewCell.swift
//  Lab4
//
//  Created by Katie Vanesko on 11/7/20.
//  Copyright © 2020 Katie Vanesko. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with image: UIImage, title: String) {
        imageView.image = image
        label.text = title
    }
 
    static func nib() ->UINib {
        return UINib(nibName: "MovieCollectionViewCell", bundle: nil)
    }

}
