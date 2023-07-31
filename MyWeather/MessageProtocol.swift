//
//  MessageProtocol.swift
//  MyWeather
//
//  Created by Reek i on 31.07.2023.
//

import UIKit

protocol MessageProtocol {}

extension MessageProtocol {
    func showAlert(with text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.rootViewController?.present(alert, animated: true)
    }
}
