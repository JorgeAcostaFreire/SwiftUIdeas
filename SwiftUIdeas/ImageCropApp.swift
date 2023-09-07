//
//  ImageCropApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 18/1/23.
//

import SwiftUI
import PhotosUI

struct ImageCropApp: View {
    @State var myCGImage : CGImage?
    @State var loadedImages : UnsplashPhoto?
    @State var tiles : [CGImage]?
    @State var pickerTapped : Bool = false
    @State var chosenPic : UIImage?
    @State var photosItem : PhotosPickerItem?
    @State var selectedPhotoData : Data?
    @State var urls : [String] = []
    @State var imageReel : [UIImage] = []
    var category : Category = .buildings
    
    func convertImage(_ image : UIImage) -> CGImage {
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let size : CGFloat = imageWidth > imageHeight ? imageHeight : imageWidth
        let xCenter = imageWidth / 2
        let yCenter = imageHeight / 2
        return image.cgImage!.cropping(to: CGRect(origin: CGPoint(x: xCenter - size / 2, y: yCenter - size / 2), size: CGSize(width: size, height: size)))!
    }
    
    func makeTiles(_ image : CGImage, _ dim : Int) -> [CGImage] {
        let size = Int(image.height / dim)
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
        let key = ""
        let string = "https://pixabay.com/api/?key=\(key)&category=\(category.name)&image_type=photo&per_page=10&safesearch=true"
        guard let url = URL(string: string) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let item = try JSONDecoder().decode(UnsplashPhoto.self, from: data)
            loadedImages = item
            for pic in loadedImages!.hits {
                //self.urls.append(pic.webformatURL)
                if let data = try? Data(contentsOf: URL(string: pic.webformatURL)!){
                    let image = UIImage(data: data)
                    self.imageReel.append(image!)
                }
            }
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        VStack{
            if !self.imageReel.isEmpty {
                ZStack {
                    Color.black.opacity(0.15)
                    ScrollView(.horizontal) {
                        HStack{
                            ForEach(imageReel, id: \.self) {image in
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .onTapGesture {
                                        self.chosenPic = image
                                        self.myCGImage = self.convertImage(self.chosenPic!)
                                        self.tiles = self.makeTiles(self.myCGImage!, 3)
                                    }
                                    .frame(width: 200, height: 180)
                                    .cornerRadius(10)
                                    .clipped()
                                    .padding(.horizontal, 5)
                            }
                        }
                    }
                }.frame(height: 250)
            } else {
                VStack {
                    ProgressView()
                    Text("Loading images...")
                        .font(.caption)
                }.padding(.vertical)
            }
            Spacer()
            
            
            
             
            if let tiles = self.tiles {
                HStack{
                    ForEach(0..<3) { i in
                        Image(tiles[i], scale: 6, label: Text(""))
                    }
                }
                HStack{
                    ForEach(3..<6) { i in
                        Image(tiles[i], scale: 6, label: Text(""))
                    }
                }
                HStack{
                    ForEach(6..<9) { i in
                        Image(tiles[i], scale: 6, label: Text(""))
                    }
                }
            }
        }
        .toolbar(content: {
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
        })
        .task {
            await loadImage()
        }
    }
}

struct ImageCropApp_Previews: PreviewProvider {
    static var previews: some View {
        ImageCropApp()
    }
}

struct UnsplashPhoto : Codable {
    var total: Int
    var totalHits : Int
    var hits : [Photo]
}

struct Photo : Codable {
    var webformatURL : String
    var imageWidth : Int
    var imageHeight : Int
}

enum Category {
    case background
    case fashion
    case science
    case nature
    case education
    case health
    case animals
    case industry
    case computer
    case food
    case sports
    case travel
    case music
    case buildings
    
    var name : String {
        switch self{
        case .animals:
            return "animals"
        case .buildings:
            return "buildings"
        case .background:
            return "background"
        case .computer:
            return "computer"
        case .education:
            return "education"
        case .fashion:
            return "fashion"
        case .food:
            return "food"
        case .health:
            return "health"
        case .industry:
            return "industry"
        case .music:
            return "music"
        case .nature:
            return "nature"
        case .science:
            return "science"
        case .sports:
            return "sports"
        case .travel:
            return "travel"
        }
    }
}
