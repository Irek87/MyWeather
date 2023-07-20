//
//  MyCollectionViewCell.swift
//  MyWeather
//
//  Created by Reek i on 02.07.2023.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    private let formatter = DateFormatter()
    
    @IBOutlet var dateTimeLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    
    func configure(with list: List) {
        formatter.dateFormat = "dd.MM    HH"
        let date =  Date(timeIntervalSince1970: list.dt ?? 0)
        dateTimeLabel.text = formatter.string(from: date) + " h"
        
        iconImageView.image = UIImage(named: list.weather?.first?.icon ?? "")
        temperatureLabel.text = "\(Int(list.main?.temp ?? 0))°"
    }
}
