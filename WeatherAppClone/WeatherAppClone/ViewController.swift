import UIKit
import CoreLocation



class ViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    var weatherData =  [Weather]() // Variable holding Daily Weather Data
    var hourlyweatherData = [Weather]() //Variable holding Hourly Weather Data
    override func viewDidLoad() {
            super.viewDidLoad()
            //Register 2 cells
        tableView.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        tableView.register(WeatherDataTableViewCell.nib(), forCellReuseIdentifier: WeatherDataTableViewCell.identifier)
            searchBar.delegate = self
            tableView.delegate = self
            tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 3/255.0, green: 186/255.0, blue: 252/255.0, alpha: 1)
        view.backgroundColor = UIColor(red: 3/255.0, green: 186/255.0, blue: 252/255.0, alpha: 1)
    
        }
// Creating a tableHeader View to show the current temperature
    func createTableHeader(city:String, temp: Double, WeatherDescription: String) -> UIView{
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
        headerView.backgroundColor = UIColor(red: 3/255.0, green: 186/255.0, blue: 252/255.0, alpha: 1)
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.size.width, height: 20))
        let imageIcon = UIImageView(frame: CGRect(x:  locationLabel.frame.minX, y: 20+locationLabel.frame.maxY, width: 50, height: 50))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 40+imageIcon.frame.size.height+locationLabel.frame.size.height, width: view.frame.size.width, height: 30))
        headerView.addSubview(locationLabel)
        headerView.addSubview(tempLabel)
        headerView.addSubview(imageIcon)
        locationLabel.textAlignment = .center
        tempLabel.textAlignment = .center
        imageIcon.center.x = view.center.x
        tempLabel.text = "\(temp)°C"
        tempLabel.font = UIFont(name: "Helvetica-Bold",size: 30)
        locationLabel.text = city
        locationLabel.font = .boldSystemFont(ofSize: 20)
        if WeatherDescription.contains("clear"){
            imageIcon.image = UIImage(named: "Clear")
        }
        else if WeatherDescription.contains("clouds"){
            imageIcon.image = UIImage(named: "Cloudy")

        }
        else{
            imageIcon.image = UIImage(named: "Rain")

        }
        return headerView
        }
    }
    extension ViewController: UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            let apiClient = APICaller()
            if let searchText = searchBar.text {
                apiClient.fetchDailyWeatherData(for: searchText) { newWeatherData, error in
                    if let error = error {
                                        print(error.localizedDescription)
                                        return
                                    }
                    guard let newWeatherData = newWeatherData else {
                                        print("Weather data not found")
                                        return
                                    }
                    DispatchQueue.main.async {
                        self.weatherData = newWeatherData
                        self.tableView.reloadData()
                        self.tableView.tableHeaderView = self.createTableHeader(city: searchText.uppercased(), temp: self.weatherData.first!.temp, WeatherDescription: self.weatherData.first!.weatherCondition)
                                    }
                }
                apiClient.fetchHourlyWeatherData(for: searchText) { hourlyWeatherData, error in
                    if let error = error {
                                        print(error.localizedDescription)
                                        return
                                    }
                    guard let hourlyWeatherData = hourlyWeatherData else {
                                        print("Weather data not found")
                                        return
                                    }
                    DispatchQueue.main.async {
                        self.hourlyweatherData = hourlyWeatherData
                        self.tableView.reloadData()
                                    }
                }
            }
        }
    }

    extension ViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                // Only 1 cell for collection
                return 1
            }
            return weatherData.count
        }
        func numberOfSections(in tableView: UITableView) -> Int {
            return 2
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
                cell.configure(model: hourlyweatherData)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDataTableViewCell.identifier, for: indexPath) as! WeatherDataTableViewCell
            let weather = weatherData[indexPath.row]
            cell.configure(date: weather.date, humdity: weather.humidity, temp: weather.temp, WeatherDescription: weather.weatherCondition)
            cell.backgroundColor = UIColor(red: 3/255.0, green: 186/255.0, blue: 252/255.0, alpha: 1)            
            return cell
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.section == 0 {
                return 200
            }
            return 90
        }

    }
struct Weather {
        let date: String
        let temp: Double
        let humidity: Int
        let windSpeed: Double
        let weatherCondition: String
    }

