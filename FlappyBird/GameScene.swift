import Foundation
import SpriteKit
import SwiftUI
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    let player = SKSpriteNode(imageNamed: "frame-2")
    var playerAnimation = [SKTexture]()
    var touchesBegan = false
    var pipeTimer = Timer()
    var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    var score = 0
    
    let playerCategory: UInt32 = 1
    let pipeCategory: UInt32 = 2
    let scoreCategory: UInt32 = 4
    let backgroundCategory: UInt32 = 8
    
    var gameSpeed: CGFloat = 1.0
    
    override func didMove(to view: SKView) {
        self.size = CGSize(width: 812, height: 375)
        scene?.scaleMode = .fill
        anchorPoint = .zero
        physicsWorld.gravity = CGVector(dx: 0, dy: -3)
        physicsWorld.contactDelegate = self
        
       
        moveBackground(image: "map", y: 0, z: -5, duration: 10 * gameSpeed, needPhysics: false, size: self.size)
        moveBackground(image: "image2", y: 0, z: -2, duration: 10 * gameSpeed, needPhysics: false, size: CGSize(width: self.size.width, height: 300))
        moveBackground(image: "image3", y: 0, z: -2, duration: 10 * gameSpeed, needPhysics: false, size: CGSize(width: self.size.width, height: 100))
        moveBackground(image: "image4", y: 0, z: -2, duration: 10 * gameSpeed, needPhysics: false, size: CGSize(width: self.size.width, height: 100))
        moveBackground(image: "image5", y: 0, z: -2, duration: 10 * gameSpeed, needPhysics: false, size: CGSize(width: self.size.width, height: 100))
        
       
        player.setScale(0.1)
        player.position = CGPoint(x: player.size.width / 2, y: size.height / 2)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = pipeCategory | scoreCategory
        player.physicsBody?.collisionBitMask = pipeCategory
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.allowsRotation = false
        player.zPosition = 10
        addChild(player)
        
        let textureAtlas = SKTextureAtlas(named: "Sprites")
        for i in 1..<textureAtlas.textureNames.count {
            let name = "frame-\(i)"
            playerAnimation.append(textureAtlas.textureNamed(name))
        }
        
        player.run(SKAction.repeatForever(SKAction.animate(with: playerAnimation, timePerFrame: 0.14)))
        
       
        pipeTimer = Timer.scheduledTimer(timeInterval: 1.5 / gameSpeed, target: self, selector: #selector(spawnPipe), userInfo: nil, repeats: true)
        
       
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height - 40)
        scoreLabel.zPosition = 15
        scoreLabel.text = "Score: \(score)"
        addChild(scoreLabel)
        
     
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesBegan = true
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 200)
        
        
        run(SKAction.playSoundFileNamed("jump.wav", waitForCompletion: false))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesBegan = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        gameSpeed += 0.0001
        if player.position.y > size.height || player.position.y < 0 {
            gameOver()
        }
    }
    @objc func spawnPipe() {
        let pipeWidth: CGFloat = 60
        let pipeHeight: CGFloat = 400
        let pipeGap: CGFloat = 140
        let randomY = CGFloat(GKRandomDistribution(lowestValue: Int(pipeGap), highestValue: Int(size.height - pipeGap)).nextInt())
        
        let pipePair = SKNode()
        pipePair.position = CGPoint(x: self.frame.width + pipeWidth, y: 0)
        pipePair.zPosition = -10
        
        
        let topPipe = SKSpriteNode(imageNamed: "dad")
        topPipe.position = CGPoint(x: 0, y: randomY + pipeGap / 2 + pipeHeight / 2)
        topPipe.size = CGSize(width: pipeWidth, height: pipeHeight)
        topPipe.zPosition = 5
        topPipe.physicsBody = SKPhysicsBody(rectangleOf: topPipe.size)
        topPipe.physicsBody?.isDynamic = false
        topPipe.physicsBody?.categoryBitMask = pipeCategory
        topPipe.physicsBody?.contactTestBitMask = playerCategory
        topPipe.yScale = -1
        pipePair.addChild(topPipe)
        
       
        let bottomPipe = SKSpriteNode(imageNamed: "dad")
        bottomPipe.position = CGPoint(x: 0, y: randomY - pipeGap / 2 - pipeHeight / 2)
        bottomPipe.size = CGSize(width: pipeWidth, height: pipeHeight)
        bottomPipe.zPosition = 5
        bottomPipe.physicsBody = SKPhysicsBody(rectangleOf: bottomPipe.size)
        bottomPipe.physicsBody?.isDynamic = false
        bottomPipe.physicsBody?.categoryBitMask = pipeCategory
        bottomPipe.physicsBody?.contactTestBitMask = playerCategory
        pipePair.addChild(bottomPipe)
        
        
        let scoreNode = SKNode()
        scoreNode.position = CGPoint(x: topPipe.position.x + topPipe.size.width / 2, y: size.height / 2)  //
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeWidth, height: pipeGap))
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = scoreCategory
        scoreNode.physicsBody?.contactTestBitMask = playerCategory
        pipePair.addChild(scoreNode)
        
        let movePipes = SKAction.moveBy(x: -self.frame.width - pipeWidth, y: 0, duration: 3.5 / gameSpeed)
        let removePipes = SKAction.removeFromParent()
        let pipeSequence = SKAction.sequence([movePipes, removePipes])
        pipePair.run(pipeSequence)
        
        self.addChild(pipePair)
    }

    
    func moveBackground(image: String, y: CGFloat, z: CGFloat, duration: Double, needPhysics: Bool, size: CGSize) {
        for i in 0...1 {
            let node = SKSpriteNode(imageNamed: image)
            node.anchorPoint = .zero
            node.position = CGPoint(x: size.width * CGFloat(i), y: y)
            node.zPosition = z
            node.size = CGSize(width: size.width, height: size.height)
            
            if needPhysics {
                node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                node.physicsBody?.isDynamic = false
                node.physicsBody?.categoryBitMask = backgroundCategory
            }
            
            let move = SKAction.moveBy(x: -node.size.width, y: 0, duration: duration)
            let reset = SKAction.moveBy(x: node.size.width, y: 0, duration: 0)
            let wrap = SKAction.sequence([move, reset])
            let repeatAction = SKAction.repeatForever(wrap)
            node.run(repeatAction)
            addChild(node)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == scoreCategory) ||
            (contact.bodyA.categoryBitMask == scoreCategory && contact.bodyB.categoryBitMask == playerCategory) {
            score += 1
            scoreLabel.text = "Score: \(score)"
            
            
            run(SKAction.playSoundFileNamed("score.wav", waitForCompletion: false))
        } else if contact.bodyA.categoryBitMask == playerCategory || contact.bodyB.categoryBitMask == playerCategory {
          
            run(SKAction.playSoundFileNamed("hit.wav", waitForCompletion: false))
            gameOver()
        }
    }
    
    func gameOver() {
        pipeTimer.invalidate()
        player.removeAllActions()
        for node in self.children {
            node.removeAllActions()
        }
        
        
        run(SKAction.playSoundFileNamed("gameover.wav", waitForCompletion: false))
        
        
        let highScore = UserDefaults.standard.integer(forKey: "HighScore")
        if score > highScore {
            UserDefaults.standard.set(score, forKey: "HighScore")
        }
        
       
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "Game Over! Score: \(score)"
        gameOverLabel.fontSize = 32
        gameOverLabel.fontColor = SKColor.red
        gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        gameOverLabel.zPosition = 15
        addChild(gameOverLabel)
       
        let highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        highScoreLabel.text = "High Score: \(UserDefaults.standard.integer(forKey: "HighScore"))"
        highScoreLabel.fontSize = 24
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 40) // Slightly below the game over label
        highScoreLabel.zPosition = 15
        addChild(highScoreLabel)
        
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let newScene = GameScene(size: self.size)
                self.view?.presentScene(newScene, transition: transition)
            }
        ]))
    }
}
