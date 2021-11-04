//
//  JourneyMap.swift
//  ADAM_testes
//
//  Created by Pedro Cacique on 09/09/21.
//

import SwiftUI
import Foundation

@available(iOS 14, macOS 11.0, *)
public struct JourneyMap: View {
    
    var data: JourneyMapModel
    var gridColor: Color = Color(red: 196/255, green: 195/255, blue: 195/255)
    var connectionColor: Color = Color.black
    var textColor: Color = Color.black
    var size: CGFloat = 300
    var circleSize: CGFloat = 16
    var fontSize: CGFloat = 12
    
    public var body: some View{
        ZStack{
            Web(divisions: data.skills.count, levels: 6)
                        .stroke(gridColor,lineWidth: 1)
                .frame(width: size, height: size)
            ForEach(0..<data.skills.count){ i in
                Connections(skills: data.skills, size: size, lineWidth: circleSize/4, circleSize: circleSize)
                    .frame(width: size, height: size)
                Text(data.skills[i].name)
                    .foregroundColor(data.skills[i].color)
                    .offset(x: getPositionX(r: size/2 + 2*fontSize, skills: data.skills, i: i, isLabel: true) ,
                            y: getPositionY(r: size/2 + 2*fontSize, skills: data.skills, i: i, isLabel: true))
                    .font(.system(size: fontSize))
                    .multilineTextAlignment(.center)
                
                    
            }
        }
    }
}

@available(iOS 14, macOS 11.0, *)
func getPositionX(center: CGPoint = CGPoint(), r: CGFloat, skills: [Skill], i: Int, isLabel: Bool = false) -> CGFloat{
    let r2: CGFloat = (!isLabel) ? r * CGFloat(skills[i].value) : r
    let step: CGFloat = .pi * 2 / CGFloat(skills.count)
    return center.x + r2 * cos(CGFloat(i) * step - .pi/2)
}

@available(iOS 14, macOS 11.0, *)
func getPositionY(center: CGPoint = CGPoint(), r: CGFloat, skills: [Skill], i: Int, isLabel: Bool = false) -> CGFloat{
    let r2: CGFloat = (!isLabel) ? r * CGFloat(skills[i].value) : r
    let step: CGFloat = .pi * 2 / CGFloat(skills.count)
    return center.y + r2 * sin(CGFloat(i) * step - .pi/2)
}

@available(iOS 14, macOS 11.0, *)
struct Web: Shape {
    
    var divisions: Int
    var levels: Int = 5
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let step: CGFloat = .pi*2/CGFloat(divisions)
        var r: CGFloat = rect.width/2
        let stepLevel: CGFloat = r / CGFloat(levels)
        
        for _ in 0..<levels{
            path.move(to: CGPoint(x: rect.width/2, y: rect.height/2 - r))
            
            for i in 0..<divisions {
                
                let x: CGFloat = rect.width/2 + r * cos(CGFloat(i)*step - .pi/2)
                let y: CGFloat = rect.width/2 + r * sin(CGFloat(i)*step - .pi/2)
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            path.addLine(to: CGPoint(x: rect.width/2, y: rect.height/2 - r))
            r -= stepLevel
        }

        return path
    }
}

@available(iOS 14, macOS 11.0, *)
struct Connections: View {
    
    var skills: [Skill]
    var size: CGFloat
    var lineWidth: CGFloat
    var circleSize: CGFloat
    
    var body: some View{
        
        ForEach(0..<skills.count-1){ i in
            let p1 = getPosition(r: size/2, skills: skills, i: i)
            let p2 = getPosition(r: size/2, skills: skills, i: i + 1)
            
            Connection(p1: p1,
                       p2: p2,
                       offset: CGPoint(x: size/2, y: size/2))
                .stroke(Color.black, lineWidth: lineWidth)
            Circle()
                .fill(skills[i].color)
                .frame(width: circleSize, height: circleSize)
                .offset(x: p1.x ,
                        y: p1.y)
        }
        
        let p1 = getPosition(r: size/2, skills: skills, i: skills.count-1)
        let p2 = getPosition(r: size/2, skills: skills, i: 0)
        
        Connection(p1: p1,
                   p2: p2,
                   offset: CGPoint(x: size/2, y: size/2))
            .stroke(Color.black, lineWidth: lineWidth)
        Circle()
            .fill(skills[skills.count-1].color)
            .frame(width: circleSize, height: circleSize)
            .offset(x: p1.x ,
                    y: p1.y)
        Circle()
            .fill(skills[0].color)
            .frame(width: circleSize, height: circleSize)
            .offset(x: p2.x ,
                    y: p2.y)
        
    }
}

@available(iOS 14, macOS 11.0, *)
func getAngle(p1: CGPoint, p2: CGPoint) -> CGFloat{
    return atan2(p2.y - p1.y, p2.x - p1.x)
}

@available(iOS 14, macOS 11.0, *)
func getPosition(r: CGFloat, skills: [Skill], i: Int) -> CGPoint{
    return CGPoint(x: getPositionX(r: r, skills: skills, i: i), y: getPositionY(r: r, skills: skills, i: i))
}

@available(iOS 14, macOS 11.0, *)
struct Connection: Shape{
    var p1: CGPoint
    var p2: CGPoint
    var offset: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: p1.x + offset.x, y: p1.y + offset.y))
        path.addLine(to: CGPoint(x: p2.x + offset.x, y: p2.y + offset.y))
        return path
    }
}

@available(iOS 14, macOS 11.0, *)
struct ValuePoints: Shape {
    
    var skills: [Skill]
    var valueRadius: CGFloat = 4
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let step: CGFloat = .pi*2/CGFloat(skills.count)
        
        for i in 0..<skills.count {
            let r: CGFloat = rect.width/2 * CGFloat(skills[i].value)
            let x: CGFloat = rect.width/2 + r * cos(CGFloat(i)*step - .pi/2)
            let y: CGFloat = rect.width/2 + r * sin(CGFloat(i)*step - .pi/2)
            path.addEllipse(in: CGRect(x: x, y: y, width: valueRadius/2, height: valueRadius/2))
        }
        return path
    }
}

@available(iOS 14, macOS 11.0, *)
struct JourneyMap_Previews: PreviewProvider {
    static var journeyMapData: JourneyMapModel{
        let map: JourneyMapModel = JourneyMapModel(title: "Mapa Astral")
        map.addSkill(Skill(name: "Design", value: 0.7, color: Color(red: 89/255, green: 172/255, blue: 184/255)))
        map.addSkill(Skill(name: "Business", value: 0.5, color: Color(red: 84/255, green: 103/255, blue: 173/255)))
        map.addSkill(Skill(name: "CBL", value: 0.5, color: Color(red: 227/255, green: 154/255, blue: 83/255)))
        map.addSkill(Skill(name: "Technical Skills", value: 0.4, color: Color(red: 209/255, green: 86/255, blue: 62/255)))
        map.addSkill(Skill(name: "Success \nSkills", value: 0.6, color: Color(red: 165/255, green: 139/255, blue: 198/255)))
        return map
    }
    
    static var previews: some View {
        JourneyMap(data: self.journeyMapData)
    }
}
