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
    
    func convertImage(_ image : UIImage) -> CGImage? {
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let xCenter = imageWidth / 3
        let yCenter = imageHeight / 3
        let largest = imageWidth < imageHeight
        return image.cgImage?.cropping(to: CGRect(x: largest ? yCenter : xCenter + yCenter * 2, y: largest ? yCenter + xCenter : 0, width: 1500, height: 1500))
    }
    
    func makeTiles(_ image : CGImage, _ dim : Int) -> [CGImage] {
        var size : Int {
            switch dim {
            case 3:
                return 500
            case 4:
                return 375
            case 5:
                return 300
            default:
                return 360
            }
        }
        let tileSize = CGSize(width: size, height: size)
        var tiles = [CGImage]()
        
        for i in 0..<dim {
            for j in 0..<dim {
                let origin = CGPoint(x: j * size, y: i * size)
                let tile = image.cropping(to: CGRect(origin: origin, size: tileSize))
                tiles.append(tile!)
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
            /*
            Spacer()
            Image(systemName: "photo")
                .font(.system(.title))
                .fontWeight(.bold)
                .onTapGesture {
                    self.pickerTapped.toggle()
                }
                //.photosPicker(isPresented: self.$pickerTapped, selection: self.$photosItem)
                .photosPicker(isPresented: self.$pickerTapped, selection: self.$photosItem, photoLibrary: .shared())
            Spacer()
             */
            if let selectedPhotoData,
                let image = UIImage(data: selectedPhotoData) {
             
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipped()
             
            }
            PhotosPicker(selection: self.$photosItem,
                          matching: .images,
                          photoLibrary: .shared()) {
                 Image(systemName: "plus.square.fill")
                     .font(.system(.title))
             }
                          .onChange(of: photosItem) { newItem in
                              Task {
                                  if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                      selectedPhotoData = data
                                  }
                              }
                          }

             
            /*
            if let myCGImage = self.myCGImage {
                Image(myCGImage, scale: 6, label: Text(""))
            }
             */
            
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
                /*
                 HStack{
                     ForEach(6..<9) { i in
                         Image(tiles[i], scale: 6, label: Text(""))
                     }
                 }
                 */
                /*
                 HStack{
                     ForEach(6..<9) { i in
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
        .onAppear{
            self.myCGImage = convertImage(myUIImage)
            self.tiles = self.makeTiles(convertImage(myUIImage)!, 3)
            //print()
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

class PictureVM: ObservableObject {
    // MARK: - Profile Image
    
    enum ImageState : Equatable {
        static func == (lhs: PictureVM.ImageState, rhs: PictureVM.ImageState) -> Bool {
            return false
        }
        
        case empty
        case loading(Progress)
        case success(UIImage)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    struct FrameImage: Transferable {
        let image: UIImage
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
            #if canImport(AppKit)
                guard let nsImage = NSImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(nsImage: nsImage)
                return ProfileImage(image: image)
            #elseif canImport(UIKit)
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                //let image = Image(uiImage: uiImage)
                return FrameImage(image: uiImage)
            #else
                throw TransferError.importFailed
            #endif
            }
        }
    }
    
    @Published private(set) var imageState: ImageState = .empty
    
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: FrameImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(profileImage.image)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
}
