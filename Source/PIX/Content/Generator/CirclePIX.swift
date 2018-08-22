//
//  CirclePIX.swift
//  Pixels
//
//  Created by Hexagons on 2018-08-07.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import UIKit

public class CirclePIX: PIXGenerator, PIXofaKind {
    
    var kind: PIX.Kind = .circle
    
    override var shader: String { return "contentGeneratorCirclePIX" }
    override var shaderNeedsAspect: Bool { return true }
    
    public var radius: CGFloat = 0.25 { didSet { setNeedsRender() } }
    public var position: CGPoint = .zero { didSet { setNeedsRender() } }
    public var edgeRadius: CGFloat = 0 { didSet { setNeedsRender() } } // CHECK radius is not diameter
    public var color: UIColor = .white { didSet { setNeedsRender() } }
    public var edgeColor: UIColor = .gray { didSet { setNeedsRender() } }
    public var bgColor: UIColor = .black { didSet { setNeedsRender() } }
    public var premultiply: Bool = true { didSet { setNeedsRender() } }
    enum CircleCodingKeys: String, CodingKey {
        case radius; case position; case edgeRadius; case color; case edgeColor; case bgColor; case premultiply
    }
    override var uniforms: [CGFloat] {
        var vals = [radius, position.x, position.y, edgeRadius]
        vals.append(contentsOf: PIX.Color(color).list)
        vals.append(contentsOf: PIX.Color(edgeColor).list)
        vals.append(contentsOf: PIX.Color(bgColor).list)
        vals.append(premultiply ? 1 : 0)
        return vals
    }
    
    // MARK: JSON
    
    required convenience init(from decoder: Decoder) throws {
        self.init(res: ._128) // CHECK
        let container = try decoder.container(keyedBy: CircleCodingKeys.self)
        radius = try container.decode(CGFloat.self, forKey: .radius)
        position = try container.decode(CGPoint.self, forKey: .position)
        edgeRadius = try container.decode(CGFloat.self, forKey: .edgeRadius)
        color = try container.decode(PIX.Color.self, forKey: .color).ui
        edgeColor = try container.decode(PIX.Color.self, forKey: .edgeColor).ui
        bgColor = try container.decode(PIX.Color.self, forKey: .bgColor).ui
        premultiply = try container.decode(Bool.self, forKey: .premultiply)
        setNeedsRender()
    }
    
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CircleCodingKeys.self)
        try container.encode(radius, forKey: .radius)
        try container.encode(position, forKey: .position)
        try container.encode(edgeRadius, forKey: .edgeRadius)
        try container.encode(PIX.Color(color), forKey: .color)
        try container.encode(PIX.Color(edgeColor), forKey: .edgeColor)
        try container.encode(PIX.Color(bgColor), forKey: .bgColor)
        try container.encode(premultiply, forKey: .premultiply)
    }
    
}
