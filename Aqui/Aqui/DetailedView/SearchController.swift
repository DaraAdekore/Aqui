//
//  ViewController.swift
//  Aqui
//
//  Created by Dara Adekore on 2022-11-12.
//

import UIKit

class SearchController: UIViewController , UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{
    func dataLoad(city name:String){
        self.imageData = []
        self.apiData = []
        let endpoints = customData.makeEndpoint(city: name)
        
        getImageData(for: endpoints.0, name)
        getCoordData(for: endpoints.1)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.imagView.image = self.imageData[indexPath.row]
        cell.cityName.text = self.searchedCity
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchedCity = searchBar.text!
        dataLoad(city:searchBar.text!)
        self.view.endEditing(true)
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var customData = CustomData()
    var searchedCity = ""
    var imageData = [UIImage]()
    var apiData:[CustomData.AirData] = []
    var geoData:[CustomData.GeoDatum] = []
    var coord:[(Double,Double)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    func makeApiCall(_ localGeoData:CustomData.GeoDatum) {
        let path = self.customData.apiEndpoint.replacingOccurrences(of: "{lat}", with: String((localGeoData.lat)!)).replacingOccurrences(of: "{lon}", with: String((localGeoData.lon)!))
        guard let url = URL(string: path) else {print("HEREE");return}
        let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)){(data, response, error) in
            
            guard error == nil else{ print(error as Any); return}
            
            if let data = data{
                DispatchQueue.main.async {
                    self.apiData.append(try! JSONDecoder().decode(CustomData.AirData.self, from: data))
                    self.tableView.reloadData()
                }
            }else{
                print("error")
                return
            }
        }
        dataTask.resume()
    }
    func getImageData(for city:String,_ name:String){
        guard let url = URL(string: city) else {return}
        let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)){ (data, response, error) in
            
            guard error == nil else{ print(error as Any); return}
            
            if let data = data{
                if let results = try! JSONDecoder().decode(CustomData.ImageData.self, from: data).results{
                    for result in results{
                        if let string = result.urls?.thumb{
                            let newDataTask = URLSession.shared.dataTask(with: URLRequest(url: URL(string:string)!)) {(data,response,error) in
                                guard error ==  nil else {print(error?.localizedDescription as Any); return}
                                
                                if let data = data {
                                    let image = UIImage(data: data)
                                    DispatchQueue.main.async  {
                                        self.imageData.append(image!)
                                    }
                                }
                            }
                            newDataTask.resume()
                        }
                    }
                }
                
                
            }else{
                print("here error")
                return
            }
        }
        dataTask.resume()
    }
    func getCoordData(for url:String){
        guard let url = URL(string: url) else {return}
        
        let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)){(data, response, error) in
            
            guard error == nil else{ print(error as Any); return}
            
            if let data = data{
                DispatchQueue.main.async {
                    self.geoData.append(contentsOf: (try! JSONDecoder().decode([CustomData.GeoDatum].self, from: data)))
                    self.makeApiCall(self.geoData.last!)
                }
                
            }else{
                print("here error")
                return
            }
        }
        dataTask.resume()
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
         if(segue.identifier == "detailed"){
             let destination = segue.destination as! DetailedViewController
          let cellIndex = self.tableView.indexPathForSelectedRow?.row
             destination.localImage = self.imageData[cellIndex!]
             destination.cityNameText = self.searchedCity
             destination.co = "Carbon Monoxide(CO) : \( String(describing: self.apiData[cellIndex!].list?[0].components?["co"]))".replacingOccurrences(of: "Optional(", with: "")
             destination.pm25 = "Particle Matter(PM2.5) : \( String(describing: self.apiData[cellIndex!].list?[0].components?["pm2_5"]))".replacingOccurrences(of: "Optional(", with: "")
             destination.no2 = "Nitrogren Dioxide(NO2) : \(String(describing: self.apiData[cellIndex!].list?[0].components?["no2"]))".replacingOccurrences(of: "Optional(", with: "")
             destination.no = "Nitric Oxide(NO) : \(String(describing: self.apiData[cellIndex!].list?[0].components?["no"]))".replacingOccurrences(of: "Optional(", with: "")
             destination.nh3 = "Ammonia(NH3) : \(String(describing: self.apiData[cellIndex!].list?[0].components?["nh3"]))".replacingOccurrences(of: "Optional(", with: "")
             destination.so2 = "Sulfur Dioxide(SO2) : \( String(describing: self.apiData[cellIndex!].list?[0].components?["so2"]))".replacingOccurrences(of: "Optional(", with: "")
             
             destination.o3 = "Trioxygen(O3) : \(String(describing: self.apiData[cellIndex!].list?[0].components?["o3"]))".replacingOccurrences(of: "Optional(", with: "")
             
             destination.pm10 = "Particle Matter(PM10) : \( String(describing: self.apiData[cellIndex!].list?[0].components?["pm10"]))".replacingOccurrences(of: "Optional(", with: "")
         }
     }
     
    
}
extension Dictionary{
    subscript(i:Int) -> (key:Key, value:Value){
        get {
            return self[index(startIndex, offsetBy: i)]
        }
    }
}
