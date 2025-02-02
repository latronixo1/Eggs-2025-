//
//  SceneDelegate.swift
//  03. EggTimer
//
//  Created by MacBook on 16.01.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return } //создаем нашу сцену
        window = UIWindow(windowScene: windowScene) //инициализируем наш window с помощью windowScene
        window?.rootViewController = ViewController()   //делаем наш ViewController корневым
        window?.makeKeyAndVisible()     //делаем его видимым        
    }

}

