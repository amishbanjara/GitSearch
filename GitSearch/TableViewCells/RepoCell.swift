//
//  RepoCell.swift
//  GitSearch
//
//  Created by Amish on 19/10/19.
//  Copyright © 2019 Amish. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {

    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        repoNameLabel.text = nil
        forksLabel.text = nil
        starsLabel.text = nil
    }

    var repoData: RepoModelElement? {
        didSet {
            guard let data = repoData else {return}
            repoNameLabel.text = data.fullName
            forksLabel.text = data.forksCount.description + " " + "forks"
            starsLabel.text = data.stargazersCount.description + " " + "stars"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
