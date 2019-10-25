//
//  SwiftExtensions.swift
//  PullToRefreshAnimation
//
//  Created by Larry Natalicio on 4/25/16.
//  Copyright © 2016 Larry Natalicio. All rights reserved.
//

import UIKit

typealias Body = @convention(block) (CGPathElement) -> Void

extension CGPath {
    func forEach( body: @escaping Body){
        
        
        
        
        func callback(info: UnsafeMutableRawPointer?, element: UnsafePointer<CGPathElement>) {
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        
        
        
        
        // 转化来，转化去，干嘛呢？
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        apply(info: unsafeBody, function: callback)
    }
}








/*
 
 Finds the first point in a path. Uses the CGPath extension created above.
 
 This is used to add the flying-saucer image at the beginning of
 the path it will animate on.
 
 */


// 把飞碟，放到动画路径的，第一个点上面

extension UIBezierPath {
    func firstPoint() -> CGPoint? {
        var firstPoint: CGPoint? = nil
        
        cgPath.forEach { element in
            // Just want the first one, but we have to look at everything.
            guard firstPoint == nil else { return }
            assert(element.type == .moveToPoint, "Expected the first point to be a move")
            
            
            firstPoint = element.points.pointee
        }
        return firstPoint
    }
}

