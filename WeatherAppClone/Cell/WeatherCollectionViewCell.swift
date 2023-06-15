//
//  WeatherCollectionViewCell.swift
//  WeatherAppClone
//
//  Created by John Gamil on 15/06/2023.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var windspeedLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var weatherDescLabel: UILabel!

    static let identifier = "WeatherCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(red: 3/255.0, green: 186/255.0, blue: 252/255.0, alpha: 1)
    }
    
    static func nib() -> UINib{
        return UINib(nibName: self.identifier, bundle: nil)
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    public func configure(time: String, temp: Double,windSpeed: Double, humidity: Int, weatherDescription: String){
        self.tempLabel.text = "\(temp)°C"
        self.timeLabel.text = time
        self.windspeedLabel.text = "\(windSpeed)m/s"
        self.humidityLabel.text = "\(humidity)%"
        self.weatherDescLabel.text = weatherDescription
    }
}
