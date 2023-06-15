//
//  HourlyTableViewCell.swift
//  WeatherAppClone
//
//  Created by John Gamil on 14/06/2023.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {
    
    static let identifier = "HourlyTableViewCell"
    var models = [Weather]()
    @IBOutlet var collectionView : UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
        backgroundColor = .blue
        backgroundColor = UIColor(red: 3/255.0, green: 186/255.0, blue: 252/255.0, alpha: 1)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func nib() -> UINib{
        return UINib(nibName: HourlyTableViewCell.identifier, bundle: nil)
    }
    
}

extension HourlyTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as! WeatherCollectionViewCell
        let data = models[indexPath.row]
        cell.backgroundColor = UIColor(red: 3/255.0, green: 186/255.0, blue: 252/255.0, alpha: 1)
        cell.configure(time: data.date, temp: data.temp, windSpeed: data.windSpeed, humidity: data.humidity, weatherDescription: data.weatherCondition)
        return cell
    }
    func configure(model: [Weather]){
        self.models = model
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
   
    
    
}
