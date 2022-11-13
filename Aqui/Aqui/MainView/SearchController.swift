//
//  SearchController.swift
//  Aqui
//
//  Created by Dara Adekore on 2022-11-12.
//

import UIKit

class SearchController: UIViewController {

    var customData = CustomData()
    var imageData:[String:UIImage] = [:]
    var sortedImage:[(String,UIImage)] = []
    var apiData:[String:CustomData.AirData] = [:]
    var sortedApi:[(String, CustomData.AirData)] = []
    var geoData:[CustomData.GeoDatum] = []
    var coord:[(Double,Double)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func makeApiCall(_ localGeoData:CustomData.GeoDatum, _ index:Int) {
        let path = self.customData.apiEndpoint.replacingOccurrences(of: "{lat}", with: String((localGeoData.lat)!)).replacingOccurrences(of: "{lon}", with: String((localGeoData.lon)!))
        guard let url = URL(string: path) else {print("HEREE");return}
        let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)){(data, response, error) in
            
            guard error == nil else{ print(error as Any); return}
            
            if let data = data{
                DispatchQueue.main.async {
                    self.apiData[localGeoData.name!] = try! JSONDecoder().decode(CustomData.AirData.self, from: data)
                    if(index+1 == self.customData.endPoints.count){
                        DispatchQueue.main.async {
                            self.sortedApi = self.apiData.sorted(by: {$0.key < $1.key})
                            self.sortedImage = self.imageData.sorted(by: {$0.key < $1.key})
                        }
                    }
                }
            }else{
                print("error")
                return
            }
        }
        dataTask.resume()
    }
    
    func getImageData(for endPoint:(String,String,String), inside imageCollection: [String:UIImage]){
        guard let url = URL(string: endPoint.0) else {return}
            let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)){(data, response, error) in
                
                guard error == nil else{ print(error as Any); return}
                
                if let data = data{
                    if let string = try! JSONDecoder().decode(CustomData.ImageData.self, from: data).results![0].urls?.thumb{
                        let newDataTask = URLSession.shared.dataTask(with: URLRequest(url: URL(string:string)!)) {(data,response,error) in
                            guard error ==  nil else {print(error?.localizedDescription as Any); return}
                            
                            if let data = data {
                                let image = UIImage(data: data)
                                DispatchQueue.main.async  {
                                    self.imageData[endPoint.2] = image!
                                }
                            }
                        }
                        newDataTask.resume()
                    }
                    
                }else{
                    print("here error")
                    return
                }
            }
            dataTask.resume()
    }
    
    func getCoordData(for index:Int){
            guard let url = URL(string: customData.endPoints[index].1) else {return}
            
            let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)){(data, response, error) in
                
                guard error == nil else{ print(error as Any); return}
                
                if let data = data{
                    DispatchQueue.main.async {
                        self.geoData.append(contentsOf: (try! JSONDecoder().decode([CustomData.GeoDatum].self, from: data)))
                        self.makeApiCall(self.geoData.last!, index)
                    }
                    
                }else{
                    print("here error")
                    return
                }
            }
            dataTask.resume()
    }

}
