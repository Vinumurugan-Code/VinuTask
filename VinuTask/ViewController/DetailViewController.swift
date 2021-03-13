//
//  DetailViewController.swift
//  VinuTask
//
//  Created by vinumax on 12/03/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imgV: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var subtitle: UILabel!

    @IBOutlet weak var desc: UILabel!
    
    var info: Details!
    
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleL.text = info.name
        
        subtitle.text = info.email
        
        desc.text = info.body
        
        self.view.downloadImageFrom(link: imageUrl + "\(index + 1)", contentMode: .scaleAspectFit) { image in
            self.imgV.image = image
        }
    }

}
