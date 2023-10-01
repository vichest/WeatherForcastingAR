//
//  WeatherARModelManager.swift
//  WeatherAR
//
//  Created by Sanjit Pandit on 13/08/23.
//

import Foundation
import RealityKit
import ARKit

public class WeatherARModelManager {
    public func generateWeatherARModel(condition: String,temperature: Double) -> ModelEntity{
        //Ball and text
        let conditionModel = weatherConditionModel(condition: condition)
        let temperatureText = createWeatherText(with: temperature)
        //place text on top of ball
        conditionModel.addChild(temperatureText)
        temperatureText.setPosition(SIMD3<Float>(x: -0.07, y: 0.05, z: 0), relativeTo: conditionModel)
        //Name
        conditionModel.name = "weatherBall"
        return conditionModel
        
    }
    //ball create (condition)
    private func weatherConditionModel(condition:String) -> ModelEntity{
        //mesh
        let ballMesh = MeshResource.generateBox(size: 0.1)
        //video material
        let videoItem = createVideoItem(with: condition)
        let videoMaterial = createVideoMaterial(with: videoItem!)
        //Model Entity
        let ballModel = ModelEntity(mesh: ballMesh,materials: [videoMaterial])
        return ballModel
    }
    private func createVideoItem(with fileName:String) -> AVPlayerItem? {
        //url
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp4") else {return nil}
        
        //video item
        let asset = AVURLAsset(url:url)
        let videoItem = AVPlayerItem(asset: asset)
        return videoItem
    }
    private func createVideoMaterial(with videoItem:AVPlayerItem)-> VideoMaterial {
        
        //video player
        let player = AVPlayer()
        //video material
        let videoMaterial = VideoMaterial(avPlayer: player)
        //Play video
        player.replaceCurrentItem(with: videoItem)
        player.play()
        return videoMaterial
    }
    //text create temperature
    private func createWeatherText(with temperature:Double)->ModelEntity{
        let mesh = MeshResource.generateText("\(temperature)ºC",extrusionDepth: 0.1, font: .systemFont(ofSize: 2),containerFrame: .zero, alignment: .left, lineBreakMode: .byTruncatingTail)
        let material = SimpleMaterial(color: .white, isMetallic : false)
        let textEntity = ModelEntity(mesh: mesh,materials:[material])
        textEntity.scale = SIMD3<Float>(x: 0.03, y: 0.03, z:0.1)
        return textEntity
    }
}
