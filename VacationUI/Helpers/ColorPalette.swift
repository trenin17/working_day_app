//
//  ColorPalette.swift
//  VacationUI
//
//  Created by Nikita Erokhin on 4/19/23.
//

import SwiftUI

public struct ColorPalette {
    public static var activeControl: Color = Color(hex: 0x264D8C)
    public static var backgroundMinor: Color = Color(hex: 0xE1E4E7)
    public static var control: Color = Color(hex: 0xBCC9DC)
    public static var redAlert: Color = Color(hex: 0x8C2626)
    
    public struct Logo {
        public static var titleBlue: Color = Color(hex: 0x274E8F)
        public static var titleRed: Color = Color(hex: 0x8A241E)
    }
}

struct ColorPaletteExample: View {
    
    private struct ColorName {
        let name: String
        let color: Color
    }
    
    var body: some View {
        VStack {
            colorsExample
            logoExample
        }
    }
    
    private var colorsExample: some View {
        VStack {
            colorExample(name: "activeControl", color: ColorPalette.activeControl)
            colorExample(name: "control", color: ColorPalette.control)
            colorExample(name: "redAlert", color: ColorPalette.redAlert)
        }
    }
    
    private var logoExample: some View {
        HStack(spacing: 4) {
            Text("РАБОЧИЙ")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(ColorPalette.Logo.titleBlue)
            Text("ДЕНЬ")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(ColorPalette.Logo.titleRed)
        }
    }
    
    private func colorExample(name: String, color: Color) -> some View {
        HStack {
            Text(name)
                .font(.headline)
            color.frame(width: 40, height: 40)
        }
    }
    
    
}


struct ColorPaletteExample_Preview: PreviewProvider {
    
    static var previews: some View {
        ColorPaletteExample()
    }

}
