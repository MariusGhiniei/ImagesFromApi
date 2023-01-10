//
//  ViewController.swift
//  ImagesFromApi
//
//  Created by Marius Ghiniei on 09.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    var Data = [data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchImages(URL: "https://jsonplaceholder.typicode.com/photos") {
            result in self.Data = result
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    func fetchImages(URL atUrl: String, completion: @escaping ([data]) -> Void) {
        let url = URL(string: atUrl)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) {
            item, response, error in
            do{
                let fetchData = try JSONDecoder().decode([data].self, from: item!)
                completion(fetchData)
            } catch {
                print("Error on parsing data")
            }
        }
        
        dataTask.resume()
                        
    }

}

extension ViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            as! ImageCollectionViewCell
        
        let imageToDisplay: data = Data[indexPath.row]
        let url = URL(string: imageToDisplay.url)
        
        cell.apiImage.download(from: url!, contentMode: .scaleToFill)
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        
        self.imageTapped(image: cell.apiImage.image!)
        
    }
    
    func imageTapped(image: UIImage){
        
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeFullScreenMode))
        newImageView.addGestureRecognizer(tap)
           
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    @objc func closeFullScreenMode(_ sender: UITapGestureRecognizer) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    

}
extension UIImageView{
    
    func download(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        
        URLSession.shared.dataTask(with: url) { item, response, error in
            guard
                let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let item = item, error == nil,
                let image = UIImage(data: item)
            else { return }
            
            DispatchQueue.main.async {
                [weak self] in self?.image = image
            }
        }
        .resume()
    }
    
}

