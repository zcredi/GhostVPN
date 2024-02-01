//
//  SceneFactory.swift
//  GhostVPN
//
//  Created by Владислав on 05.01.2024.
//

import UIKit
import HomeScene

protocol SceneFactory {
    func makeLoginScene(with configurator: HomeConfigurator) -> UIViewController
}

final class DefaultSceneFactory: SceneFactory {
    func makeLoginScene(with configurator: HomeConfigurator) -> UIViewController {
        let vc = HomeViewController()
        return configurator.configured(vc)
    }
}
