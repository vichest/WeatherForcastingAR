//  ContentView.swift
//  WeatherAR
//
//  Created by Sanjit Pandit on 06/08/23.
//

import SwiftUI
import ARKit
import RealityKit

struct ContentView: View {
    @State var cityName: String = "London"
    @State var isSearchBarVisible:Bool = true
    //debug
    @State var temp:Double = 0
    @State var condition:String = ""
    @ObservedObject var weatherManager = WeatherNetworkManager()
    var body: some View {
        ZStack{
            //ARview
            ARViewDisplay()
            //ui controls
            VStack{
                if(isSearchBarVisible){
                    //search bar
                    searchBar(cityName: $cityName)
                        .transition(.scale)
                }
                
                Spacer()
                //search toggle
                searchToggle(isSearchToggle: $isSearchBarVisible)
            }
            .onChange(of: cityName, perform: {value in
                weatherManager.fetchData(cityName:cityName)
            })
            .onReceive(weatherManager.$receivedWeatherData, perform: {
                (receivedData) in
                if let latestData = receivedData{
                    //pass to AR viewControler
                    ARViewController.shared.receivedWeatherData = latestData
                    
                }
                
            })
            
        }
        
        
 
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
// Mark - search stuff
struct searchBar: View {
    @State var searchText:String = ""
    @Binding var cityName:String
    var body: some View {
        HStack{
            //Search icon
            Image(systemName: "magnifyingglass")
                .font(.system(size: 30))
            //Search text
            TextField("Search",text:$searchText) {(value)in
                print("typing in progress")
            } onCommit: {
                cityName = searchText
            }
        }
        .frame(maxWidth:500)
        .padding(.all)
        .background(Color.black.opacity(0.15))
        
    }
}
struct searchToggle: View {
    @Binding var isSearchToggle:Bool
    var body: some View {
        Button(action: {
            withAnimation{
                //Toggle the search bar
                isSearchToggle = !isSearchToggle
            }
        }, label: {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 30))
                .foregroundColor(Color.black)
               })
    }
}
//mark ar views
struct ARViewDisplay: View{
    var body: some View{
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

// AR - views
struct ARViewContainer: UIViewRepresentable{
    typealias UIViewType = ARView
    func makeUIView(context: Context) -> ARView {
            
        ARViewController.shared.startARSession()
        return ARViewController.shared.arView
        }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

