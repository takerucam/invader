//
//  Entiry+Extension.swift
//  invader
//
//  Created by 三宅武将 on 2023/12/16.
//

import RealityKit

extension Entity {
    var modelComponent: ModelComponent? {
        get { components[ModelComponent.self] }
        set { components[ModelComponent.self] = newValue }
    }
    
    var descendentsWithModelComponent: [Entity] {
        var descendents = [Entity]()
        
        for child in children {
            if child.components[ModelComponent.self] != nil {
                descendents.append(child)
            }
            descendents.append(contentsOf: child.descendentsWithModelComponent)
        }
        return descendents
    }
}

extension Entity {
    func setMaterialParameterValues(parameter: String, value: MaterialParameters.Value) {
        let modelEntities = descendentsWithModelComponent
        for entity in modelEntities {
            if var modelComponent = entity.modelComponent {
               
                modelComponent.materials = modelComponent.materials.map {
                    
                    guard var material = $0 as? ShaderGraphMaterial else { return $0 }
                    if material.parameterNames.contains(parameter) {
                        do {
                            try material.setParameter(name: parameter, value: value)
                        } catch {
                            print("Error setting parameter: \(error.localizedDescription)")
                        }
                    }
                    return material
                }
                entity.modelComponent = modelComponent
            }
        }
    }
}
