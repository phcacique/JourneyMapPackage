//
//  JourneyMap.swift
//  ADAM_testes
//
//  Created by Pedro Cacique on 09/09/21.
//

import Foundation
import SwiftUI

@available(iOS 14, macOS 11.0, *)
public class JourneyMapModel{
    
    public var title: String
    private(set) var skills: [Skill] 
    
    public init(title: String){
        self.title = title
        skills = []
    }
    
    public func addSkill(_ skill: Skill){
        skills.append(skill)
    }
    
}

@available(iOS 14, macOS 11.0, *)
public struct Skill{
    var name: String
    var value: Float
    var color: Color
}
