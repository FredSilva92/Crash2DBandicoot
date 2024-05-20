import SpriteKit

class ButtonNode: SKSpriteNode {
    
    var labelNode: SKLabelNode!
    var action: ((_ touches: Set<UITouch>) -> Void)?
    
    init(size: CGSize, labelText: String, position: CGPoint) {
        super.init(texture: nil, color: .clear, size: size)
        
        // Set up label
        labelNode = SKLabelNode(text: labelText)
        labelNode.text = labelText
        labelNode.fontName = "Arial"
        labelNode.fontSize = 20
        labelNode.fontColor = UIColor.white
        labelNode.position = position
        labelNode.horizontalAlignmentMode = .left
        labelNode.verticalAlignmentMode = .top
        self.position = position
        self.addChild(labelNode)
        
        self.isUserInteractionEnabled = true
    }

    init(name: String, size: CGSize, position: CGPoint) {
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: .clear, size: size)
        self.position = position
        self.isUserInteractionEnabled = true
    }
    
    init(name: String, position: CGPoint) {
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: .clear, size: texture.size())
        self.position = position
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Highlight the button when touched
        self.alpha = 0.8
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Call action when the button is released
        self.alpha = 1.0
        if let action = action {
            action(touches)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Reset button alpha if touch is cancelled
        self.alpha = 1.0
    }
}
