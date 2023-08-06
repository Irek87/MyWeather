//
//  FiveDaysCollectionManager.swift
//  MyWeather
//
//  Created by Reek i on 06.08.2023.
//

import UIKit

class FiveDaysCollectionManager: UICollectionViewController {
  
  var fiveDaysWeatherData: FiveDaysWeatherData?
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    fiveDaysWeatherData?.list.count ?? 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
      guard let list = fiveDaysWeatherData?.list[indexPath.item] else { return cell }
      cell.configure(with: list)
      return cell
  }
}

extension FiveDaysCollectionManager: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:          UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 80, height: 60)
    }
}
