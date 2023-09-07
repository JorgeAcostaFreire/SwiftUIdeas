//
//  AppModel.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 7/9/23.
//

import SwiftUI
import CoreData

enum DemoApp: CustomStringConvertible, Identifiable, Hashable, CaseIterable {
    case slider, gauge, picture, lorem, fruit, coretask, christmas
    case converter, wiki, git, currency, flag, imagecrop, none
    
    var description: String {
        switch self {
        case .slider:
            return "SliderApp"
        case .gauge:
            return "GaugeApp"
        case .picture:
            return "PictureApp"
        case .lorem:
            return "LoremApp"
        case .fruit:
            return "StackNav"
        case .coretask:
            return "TaskApp"
        case .christmas:
            return "ChristmasApp"
        case .converter:
            return "ConverterApp"
        case .wiki:
            return "WikiApp"
        case .git:
            return "GitApp"
        case .currency:
            return "CurrencyApp"
        case .flag:
            return "FlagQuizApp"
        case .imagecrop:
            return "CropApp"
        case .none:
            return "None"
        }
    }
    
    func name(_ isDark: Bool) -> String {
        switch self {
        case .lorem, .fruit, .christmas, .converter, .git:
            return isDark ? self.description.appending("Dark") : self.description
        default:
            return self.description
        }
    }
    
    func view(context: NSManagedObjectContext) -> some View {
        switch self {
        case .slider:
            return SliderApp()
        case .gauge:
            return GaugeApp()
        case .picture:
            return PictureApp()
        case .lorem:
            return LoremApp()
        case .fruit:
            return FruitApp()
        case .coretask:
            return CoreTaskApp().environment(\.managedObjectContext, context)
        case .christmas:
            return ChristmasApp()
        case .converter:
            return ConverterApp()
        case .wiki:
            return WikiApp()
        case .git:
            return GitApp()
        case .currency:
            return CurrencyApp()
        case .flag:
            return FlagQuizApp()
        case .imagecrop:
            return ImageCropApp()
        case .none:
            return EmptyView()
        }
    }
    
    var id: Self {self}
}

var size : CGFloat {return UIScreen.main.bounds.width}
let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

