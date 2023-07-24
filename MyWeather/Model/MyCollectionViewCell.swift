//
//  MyCollectionViewCell.swift
//  MyWeather
//
//  Created by Reek i on 02.07.2023.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    private let formatter = DateFormatter()
    
    let dateTimeLabel = UILabel()
    let iconImageView = UIImageView()
    let temperatureLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white.withAlphaComponent(0.2)
        contentView.layer.cornerRadius = 8
        
        contentView.addSubview(dateTimeLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(temperatureLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        dateTimeLabel.font = UIFont(name: "Georgia", size: 20)
        dateTimeLabel.textColor = .white
        dateTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        dateTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        dateTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        dateTimeLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -10).isActive = true
        
        iconImageView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        iconImageView.frame = CGRect(x: contentView.frame.size.width / 2 - 10,
                                     y: 0,
                                     width: contentView.frame.size.height,
                                     height: contentView.frame.size.height)
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = UIFont(name: "Georgia", size: 20)
        temperatureLabel.textColor = .white
        temperatureLabel.textAlignment = .center
        temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        temperatureLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor).isActive = true
        temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    func configure(with list: List) {
        formatter.dateFormat = "dd.MM    HH"
        let date =  Date(timeIntervalSince1970: list.dt)
        dateTimeLabel.text = formatter.string(from: date) + " h"
        iconImageView.image = UIImage(named: list.weather.first?.icon ?? "")
        temperatureLabel.text = "\(Int(list.main.temp))°"
    }
}
