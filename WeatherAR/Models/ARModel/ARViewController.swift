//
//  ARViewController.swift
//  WeatherAR
//
//  Created by Sanjit Pandit on 09/08/23.
//

import Foundation
import RealityKit
import ARKit

final class ARViewController: ObservableObject{
    
    static var shared = ARViewController()
    private var weatherModelAnchor: AnchorEntity?
    @Published var arView:ARView
    
    init(){
        arView = ARView(frame: .zero)
    }
    public func startARSession(){
        startPlaneDetection()
        startTapDetection()
    }
    //mark -setup
    private func startPlaneDetection(){
        arView.automaticallyConfigureSession = true
        //configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        
        //start plane detection
        arView.session.run(configuration)
    }
    private func startTapDetection(){
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self,action: #selector(handleTap(recognizer:))))
    }
    private var weatherModelGenerator = WeatherARModelManager()
    private var isWeatherBallPlaced = false
    var receivedWeatherData:WeatherModel = WeatherModel(cityName: "kolkata", temperature: 25, conditionID: 2){
        didSet{
            updateModel(temperature: receivedWeatherData.temperature, condition: receivedWeatherData.conditionName)
        }
    }
    @objc
    private func handleTap(recognizer: UITapGestureRecognizer){
        //touch location
        let tapLocation = recognizer.location(in: arView)
        //Raycast (2D -> 3D pos)
        let results = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        //If plane detected
        if let firstResult = results.first {
            
            //3D pos (x,y,z)
            let worldPosition = simd_make_float3(firstResult.worldTransform.columns.3)
      
            if(isWeatherBallPlaced == false){
                //create 3d model
                let weatherBall = weatherModelGenerator.generateWeatherARModel(condition: receivedWeatherData.conditionName, temperature: receivedWeatherData.temperature)
                
                //place object
                placeObject(object:weatherBall, at: worldPosition)
                isWeatherBallPlaced = true
                
            }
     
        }
        
        //place object
    }
        private func placeObject(object modelEntity: ModelEntity,at position: SIMD3<Float>){
            //1. create anchor
            weatherModelAnchor = AnchorEntity(world: position)
            //2. Tie model to anchor
            weatherModelAnchor!.addChild(modelEntity)
            //3. Add anchor to scene
            arView.scene.addAnchor(weatherModelAnchor!)
        }
    private func updateModel(temperature:Double, condition: String){
        if let anchor = weatherModelAnchor{
            //delete the previous
            arView.scene.findEntity(named: "weatherBall")?.removeFromParent()
            //replace with new
            let newWeatherBall = weatherModelGenerator.generateWeatherARModel(condition: condition, temperature: temperature)
            anchor.addChild(newWeatherBall)
        }
    }
    
    
    
    }
