//
//  MyCollectionViewCell.swift
//  MyWeather
//
//  Created by Reek i on 02.07.2023.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var dateTimeLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!

  /*
   Обычно для ячеек мы создаем функцию, в которой будем настраивать, например
   func configure(data: Data) {
    dateTimeLabel.text = data.text
    ...
   }
   */
}
