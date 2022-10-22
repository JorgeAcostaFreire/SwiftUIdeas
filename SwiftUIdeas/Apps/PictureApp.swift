//
//  PictureApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 21/10/22.
//

import SwiftUI
import PhotosUI

struct PictureApp: View {
    @Environment (\.dismiss) var dismiss
    @StateObject var viewModel = ProfileModel()
    
    var body: some View {
        NavigationView {
            VStack {
                EditableCircularProfileImage(viewModel: viewModel)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                    }

                }
            }
        }
    }
}

struct PictureApp_Previews: PreviewProvider {
    static var previews: some View {
        PictureApp()
    }
}

class ProfileModel: ObservableObject {
    // MARK: - Profile Image
    
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    struct ProfileImage: Transferable {
        let image: Image
        
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
                let image = Image(uiImage: uiImage)
                return ProfileImage(image: image)
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
        return imageSelection.loadTransferable(type: ProfileImage.self) { result in
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

struct ProfileImage: View {
    let imageState: ProfileModel.ImageState
    
    var body: some View {
        switch imageState {
        case .success(let image):
            image.resizable()
        case .loading:
            ProgressView()
        case .empty:
            Image(systemName: "photo")
                .font(.system(size: 80))
                .foregroundColor(.white)
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}

struct CircularProfileImage: View {
    let imageState: ProfileModel.ImageState
    
    var body: some View {
        ProfileImage(imageState: imageState)
            .scaledToFill()
            .frame(width: size / 1.2, height: size / 1.2)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .background {
                RoundedRectangle(cornerRadius: 10).fill(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                ).padding()
            }
            .padding()
    }
}

struct EditableCircularProfileImage: View {
    @ObservedObject var viewModel: ProfileModel
    @State var isYFlipped : Bool = false
    @State var isXFlipped : Bool = false
    
    var body: some View {
        VStack {
            CircularProfileImage(imageState: viewModel.imageState)
                .rotation3DEffect(Angle(degrees: 180.0), axis: (x: isXFlipped ? 1.0 : 0.0, y: isYFlipped ? 1.0 : 0.0, z: 0.0))
            
            HStack {
                Button {
                    self.isYFlipped.toggle()
                } label: {
                    Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right.fill")
                    .font(.system(size: size / 5))
                    .foregroundColor(.accentColor)
                }
                PhotosPicker(selection: $viewModel.imageSelection,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Image(systemName: "plus.square.fill")
                        .font(.system(size: size / 4))
                        .foregroundColor(.accentColor)
                }
                Button {
                    self.isXFlipped.toggle()
                } label: {
                    Image(systemName: "arrow.up.and.down.righttriangle.up.righttriangle.down.fill")
                    .font(.system(size: size / 5))
                    .foregroundColor(.accentColor)
                }

            }
            
        }
    }
}
