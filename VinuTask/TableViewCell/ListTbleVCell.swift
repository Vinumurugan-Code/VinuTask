//
//  ListTbleVCell.swift
//  VinuTask
//
//  Created by vinumax on 12/03/21.
//

import UIKit

class ListTbleVCell: UITableViewCell {
    
    @IBOutlet weak var imgV: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    static var identifier: String{
        return String(describing: self)
    }
    
    func setDetails(info:Details,index:Int) {
        title.text = info.name
        subtitle.text = info.email
        desc.text = info.body
        self.downloadImageFrom(link: imageUrl + "\(index + 1)", contentMode: .scaleAspectFit) { image in
            self.imgV.image = image
        }
    }
}
