//
//  HomeTableViewCell.swift
//  Motion Picture
//
//  Created by LogicalWings Mac on 28/04/19.
//  Copyright © 2019 Hiren Kadam. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblVideoTitle: UILabel!
    @IBOutlet weak var lblVideoDescription: UILabel!
    @IBOutlet weak var ViewBackground: UIView!
    
    var VideoObj:VideoListingData? {
        didSet{
            setCellData()
        }
    }
    
    func setCellData() {
        
        if let imgurl = VideoObj?.thumb {
            imgThumbnail.sd_setImage(with: URL(string: imgurl), placeholderImage: UIImage(named: "placeholder"))
        }
        
        if let videTitle = VideoObj?.title {
            lblVideoTitle.text = videTitle
        }
        
        if let videoDesc = VideoObj?.description {
            lblVideoDescription.text = videoDesc
        }
        
        layoutIfNeeded()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
