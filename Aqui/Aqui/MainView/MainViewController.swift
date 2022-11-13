//
//  ViewController.swift
//  Aqui
//
//  Created by Dara on 2022-10-24.
//

import UIKit
import Combine
class MainViewController: UICollectionViewController {
    
    
    @IBOutlet var tileView: UICollectionView!
    
    
    @IBAction func toSearch(_ sender: Any) {
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "search") as! SearchController
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
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
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        dataLoad()
        
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape,
           let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 200, height: 200)
            layout.invalidateLayout()
        }else if UIDevice.current.orientation.isPortrait,
                 let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.itemSize = CGSize(width: 120, height: 120)
            layout.invalidateLayout()
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.apiData.count
    }
    
    override  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellView", for: indexPath) as! CollectionViewCell
        cell.setup(image: self.sortedImage[indexPath.row].1, index: (self.sortedApi[indexPath.row].1.list?[0].main?.aqi)!, city: self.sortedApi[indexPath.row].0)
        return cell
    }
    enum NetworkError: Error {
        case url
        case server
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
                            print(self.sortedApi)
                            print(self.sortedImage)
                            self.sortedApi = self.apiData.sorted(by: {$0.key < $1.key})
                            self.sortedImage = self.imageData.sorted(by: {$0.key < $1.key})
                            self.tileView.reloadData()
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
    
    func dataLoad(){
        for endPoint in customData.endPoints{
            getImageData(for: endPoint, inside: imageData)
            
        }
        
        for index in 0..<customData.endPoints.count{
            getCoordData(for: index)
        }
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


extension MainViewController:UICollectionViewDelegateFlowLayout{
   
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize{
        return CGSize(width: 120, height: 120)
    }
    
}

