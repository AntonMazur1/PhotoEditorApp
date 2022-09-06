//
//  CollectionViewCell.swift
//  minimumApp
//
//  Created by Клоун on 05.09.2022.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    private let nameColors: [UIColor] = [.red, .green, .blue, .systemMint, .purple]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
    }
    
    func configure(with colorName: String) {
        name.text = colorName
        name.textColor = nameColors.randomElement()
    }
}
