//
//  ImageCropApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 18/1/23.
//

import SwiftUI
import PhotosUI

struct ImageCropApp: View {
    //@ObservedObject var vm : PictureVM
    var imageName : String = "altos"
    var myUIImage : UIImage = UIImage(imageLiteralResourceName: "mountain")
    @State var myCGImage : CGImage?
    @State var loadedImage : UnsplashPhoto?
    @State var tiles : [CGImage]?
    @State var pickerTapped : Bool = false
    @State var chosenPic : UIImage?
    @State var photosItem : PhotosPickerItem?
    @State var selectedPhotoData : Data?
    
    func convertImage(_ image : UIImage) -> CGImage {
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        var size : CGFloat {
            if imageWidth < 1000 || imageHeight < 1000 {
                return 600
            } else {
                return 1200
            }
        }
        let xCenter = imageWidth / 2
        let yCenter = imageHeight / 2
        //let largest = imageWidth < imageHeight
        //.cropping(to: CGRect(x: largest ? yCenter : xCenter + yCenter * 2, y: largest ? yCenter + xCenter : 0, width: 1500, height: 1500))
        return image.cgImage!.cropping(to: CGRect(origin: CGPoint(x: xCenter - size / 2, y: yCenter - size / 2), size: CGSize(width: size, height: size)))!
    }
    
    func makeTiles(_ image : CGImage, _ dim : Int) -> [CGImage] {
        var size : Int {
            if image.width < 700{
                switch dim {
                case 3:
                    return 200
                case 4:
                    return 150
                case 5:
                    return 120
                default:
                    return 120
                }
            } else {
                switch dim {
                case 3:
                    return 400
                case 4:
                    return 300
                case 5:
                    return 240
                default:
                    return 240
                }
            }
        }
        let tileSize = CGSize(width: size, height: size)
        var tiles = [CGImage]()
        
        for i in 0..<dim {
            for j in 0..<dim {
                let origin = CGPoint(x: j * size, y: i * size)
                if let tile = image.cropping(to: CGRect(origin: origin, size: tileSize)){
                    tiles.append(tile)
                }
            }
        }
        
        return tiles
    }
    
    func loadImage() async {
        guard let url = URL(string: "https://api.unsplash.com/photos/random") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let item = try JSONDecoder().decode(UnsplashPhoto.self, from: data)
            loadedImage = item
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        VStack{
            PhotosPicker(selection: self.$photosItem,
                          matching: .images,
                          photoLibrary: .shared()) {
                 Image(systemName: "plus.square.fill")
                     .font(.system(.title))
             }
              .onChange(of: photosItem) { newItem in
                  Task {
                      if let data = try? await newItem?.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                          selectedPhotoData = data
                          //self.tiles = self.makeTiles(self.convertImage(image), 3)
                          self.chosenPic = image
                          self.myCGImage = self.convertImage(image)
                          self.tiles = self.makeTiles(convertImage(image), 3)
                      }
                  }
              }
            if let tiles = self.tiles {
                HStack{
                    ForEach(0..<3) { i in
                        Image(tiles[i], scale: 3, label: Text(""))
                    }
                }
                HStack{
                    ForEach(3..<6) { i in
                        Image(tiles[i], scale: 3, label: Text(""))
                    }
                }
                HStack{
                    ForEach(6..<9) { i in
                        Image(tiles[i], scale: 3, label: Text(""))
                    }
                }
                /*
                 HStack{
                     ForEach(12..<16) { i in
                         Image(tiles[i], scale: 6, label: Text(""))
                     }
                 }
                 */
                /*
                 HStack{
                     ForEach(20..<25) { i in
                         Image(tiles[i], scale: 6, label: Text(""))
                     }
                 }
                 */
            }
            
            
            /*
             AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d"))
             .frame(width: 100, height: 100)
             .clipped()
             
             if let loadedImage = self.loadedImage{
             AsyncImage(url: URL(string: loadedImage.urls.first!.value))
             .frame(width: 100, height: 100)
             .clipped()
             }
             }
             .task {
             await loadImage()
             }
             */
        }
    }
}

struct ImageCropApp_Previews: PreviewProvider {
    static var previews: some View {
        ImageCropApp()
    }
}

struct UnsplashPhoto : Codable {
    var id : String
    var width : Int
    var height : Int
    var urls : [String : String]
}

struct PhotosURL : Codable {
    var raw : String
    var full : String
}

