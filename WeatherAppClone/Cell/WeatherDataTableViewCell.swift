//
//  WeatherDataTableViewCell.swift
//  WeatherAppClone
//
//  Created by John Gamil on 14/06/2023.
//

import UIKit

class WeatherDataTableViewCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var weatherDescriptionLabel : UILabel!
    @IBOutlet var iconImage : UIImageView!
    static let identifier = "WeatherDataTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .cyan
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    static func nib() -> UINib{
        return UINib(nibName: WeatherDataTableViewCell.identifier, bundle: nil)
    }
    public func configure(date:String, humdity:Int, temp: Double, WeatherDescription: String){
        self.dateLabel.text = date
       // self.windspeed.text = "\(windspeed)m/s"
        self.humidityLabel.text = "\(humdity)%"
        self.tempLabel.text = "\(temp)°C"
        self.weatherDescriptionLabel.text = WeatherDescription
        if WeatherDescription.contains("clear"){
        self.iconImage.image = UIImage(named: "Clear")
        }
        else if WeatherDescription.contains("clouds"){
            self.iconImage.image = UIImage(named: "Cloudy")

        }
        else{
            self.iconImage.image = UIImage(named: "Rain")

        }
    }
}
