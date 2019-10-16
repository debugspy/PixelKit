//
//  PixelKitTests.swift
//  PixelKitTests
//
//  Created by Anton Heestand on 2019-10-16.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import XCTest
import LiveValues
import PixelKit

class PixelKitTests: XCTestCase {

    override func setUp() {
        PixelKit.main.render.engine.renderMode = .manual
    }

    override func tearDown() {}

    func testAveragePixGenerators() {
        
        /// 8bit at 128x128
        let averages: [AutoPIXGenerator: CGFloat] = [
            .arcpix: 0.017333984375,
            .circlepix: 0.197021484375,
            .colorpix: 1.0,
            .gradientpix: 0.5,
            .linepix: 0.0115966796875,
            .noisepix: 0.4617019952512588,
            .polygonpix: 0.16357421875,
            .rectanglepix: 0.19140625
        ]
        
        for average in averages {
        
            let pix = average.key.pixType.init(at: ._128)
                    
            let expect = XCTestExpectation()
            try! PixelKit.main.render.engine.manuallyRender {
                guard let pixels = pix.renderedPixels else {
                    XCTAssert(false);
                    expect.fulfill();
                    return
                }
                let lum = pixels.average.lum.cg
                XCTAssert(lum == average.value, "\(average.key.name) average should be \(average.value) and was \(lum)")
                expect.fulfill()
            }
            wait(for: [expect], timeout: 1.0)
            
            pix.destroy()
            
        }
        
    }

    func testHueSaturationPix() {
    
        let colorPix = ColorPIX(at: ._128)
        colorPix.color = .red
        
        let hueSaturationPix = HueSaturationPIX()
        hueSaturationPix.input = colorPix
        hueSaturationPix.hue = 0.5
        hueSaturationPix.saturation = 0.5
                
        let expect = XCTestExpectation()
        try! PixelKit.main.render.engine.manuallyRender {
            guard let pixels = hueSaturationPix.renderedPixels else {
                XCTAssert(false);
                expect.fulfill();
                return
            }
            let color = pixels.average
            let hue = color.hue.cg
            let sat = color.sat.cg
            let roundHue = round(hue * 100) / 100
            let roundSat = round(sat * 100) / 100
            XCTAssertEqual(roundHue, 0.5)
            XCTAssertEqual(roundSat, 0.5)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 1.0)
                
    }

    func testPerformanceExample() {
        measure {}
    }

}
