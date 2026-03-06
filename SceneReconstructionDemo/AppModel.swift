//
//  AppModel.swift
//  SceneReconstructionDemo
//
//  Created by Igor Tarantino on 06/03/26.
//

import SwiftUI
import RealityKit

@Observable
class AppModel {

    static let immersiveSpaceID = "ImmersiveSpace"

    enum ImmersiveSpaceState { case closed, inTransition, open }
    var immersiveSpaceState: ImmersiveSpaceState = .closed

    var rootEntity: Entity?

    private var spheres: [Entity] = []

    func spawnSphere() {
        guard let root = rootEntity else {
            print("⚠️  rootEntity not set yet – is the immersive space open?")
            return
        }

        let radius: Float = 0.08
        let mesh = MeshResource.generateSphere(radius: radius)

        var material = SimpleMaterial()
        material.color    = .init(tint: .red)
        material.roughness = 1.0
        material.metallic  = 0.0

        let modelComponent = ModelComponent(mesh: mesh, materials: [material])

        let collisionShape  = ShapeResource.generateSphere(radius: radius)
        let collisionComponent = CollisionComponent(shapes: [collisionShape])

        let physicsMaterial = PhysicsMaterialResource.generate(
            friction:    0.6,
            restitution: 0.3
        )

        var physicsBody = PhysicsBodyComponent(
            shapes:   [collisionShape],
            mass:     0.2,
            material: physicsMaterial,
            mode:     .dynamic
        )
        
        physicsBody.isAffectedByGravity = true

        let sphere = Entity()
        sphere.components.set(modelComponent)
        sphere.components.set(collisionComponent)
        sphere.components.set(physicsBody)

        let randomX = Float.random(in: -0.3...0.3)
        sphere.position = SIMD3<Float>(randomX, 1.4, -1.0)
        
        var motion = PhysicsMotionComponent()
        motion.angularVelocity = SIMD3<Float>(
            Float.random(in: -1...1),
            Float.random(in: -0.5...0.5),
            Float.random(in: -1...1)
        )
        sphere.components.set(motion)

        root.addChild(sphere)
        spheres.append(sphere)

        print("✅ Spawned sphere #\(spheres.count) at x=\(randomX)")
    }

    func clearAll() {
        for sphere in spheres {
            sphere.removeFromParent()
        }
        spheres.removeAll()
        print("🗑️  Cleared all spheres")
    }
}
