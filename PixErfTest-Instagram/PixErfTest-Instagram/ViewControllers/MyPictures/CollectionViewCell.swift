//
//  CollectionViewCell.swift
//  PixErfTest-Instagram
//
//  Created by Krishantha Sunil Premaretna on 13/5/16.
//  Copyright © 2016 Krishantha Sunil Premaretna. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setupData(imageUrl:String){
        
        self.imageView.af_setImageWithURL(NSURL(string: imageUrl)!)
    
    }
}
