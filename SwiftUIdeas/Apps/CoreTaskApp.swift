//
//  CoreTaskApp.swift
//  SwiftUIdeas
//
//  Created by Jorge Acosta Freire on 22/10/22.
//

import SwiftUI
import CoreData

struct CoreTaskApp: View {
    @Environment (\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State var addTask : Bool = false
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left").foregroundColor(.white).fontWeight(.black).font(.system(size: size / 15))
                    }
                    Spacer()
                    Button {
                        self.addTask = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .fontWeight(.bold)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    EditButton().buttonStyle(EditButtonStyle())
                }.padding(.horizontal)
                List {
                    ForEach(items) { item in
                        ListRowItemView(item: item)
                    }
                    .onDelete(perform: deleteItems)
                }.scrollContentBackground(.hidden)
            }
            .background {
                LinearGradient(
                    colors: [.accentColor, .yellow, .white],
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()
            }
            if self.addTask{
                BlankView().onTapGesture { self.addTask = false }
                TaskView(addTask: self.$addTask)
            }
        }
    }
}

struct CoreTaskApp_Previews: PreviewProvider {
    static var previews: some View {
        CoreTaskApp().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct TaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State var task : String = ""
    @Binding var addTask : Bool
    private var isButtonDisabled : Bool {return task.isEmpty}
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = self.task
            newItem.completion = false
            newItem.id = UUID()

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    var body: some View {
        VStack {
            //Spacer()
            VStack(spacing : 16){
                TextField("", text: self.$task)
                    .padding()
                    .background (
                        Color(UIColor.systemGray6)
                    )
                    .cornerRadius(10)
                    .padding(.top)
                Button {
                    addItem()
                    self.task = ""
                    self.addTask = false
                } label: {
                    Spacer()
                    Image(systemName: "plus").font(.system(.largeTitle, design: .rounded, weight: .black))
                    Spacer()
                }
                .disabled(self.isButtonDisabled)
                .padding()
                .font(.headline)
                .foregroundColor(.white)
                .background(self.isButtonDisabled ? Color.gray : Color.accentColor)
                .cornerRadius(10)
                
            }
            .padding()
            .background {
                colorScheme == .dark ? Color.black : Color.white
            }
            .cornerRadius(10)
            .padding()
            .shadow(radius: 20)
        }
    }
}

struct ListRowItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var item : Item
    
    var body: some View {
        Toggle(isOn: $item.completion) {
                Text(item.task ?? "")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
                .foregroundColor(item.completion ? .accentColor : .primary)
        }
        .toggleStyle(CheckBoxToggleStyle())
        .onReceive(item.objectWillChange) { _ in
            if self.viewContext.hasChanges {
                try? self.viewContext.save()
            }
        }
    }
}

struct CheckBoxToggleStyle : ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack{
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .accentColor : .primary)
                .font(.system(.title, design: .rounded))
                .fontWeight(.semibold)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}

struct BackgroundImageView: View {
    var img : String
    
    var body: some View {
        Image(self.img)
            .antialiased(true)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
}

struct BlankView : View {
    var body: some View{
        VStack{Spacer()}
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background {Color.black}
        .opacity(0.2)
        .edgesIgnoringSafeArea(.all)
    }
}

struct EditButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack{
            Image(systemName: "pencil.circle")
                .fontWeight(.bold)
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.horizontal)
        }
        
    }
}
