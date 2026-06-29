import SwiftUI

extension Color {
    static let hollowBlack  = Color(red: 0x0B/255, green: 0x10/255, blue: 0x0D/255)
    static let mossShadow   = Color(red: 0x1A/255, green: 0x21/255, blue: 0x1C/255)
    static let lichen       = Color(red: 0x2A/255, green: 0x33/255, blue: 0x2B/255)
    static let dampBark     = Color(red: 0x3D/255, green: 0x2F/255, blue: 0x25/255)
    static let oldLeaf      = Color(red: 0x7A/255, green: 0x6B/255, blue: 0x55/255)
    static let sporeDust    = Color(red: 0xD6/255, green: 0xC9/255, blue: 0xA8/255)
    static let foxfireTeal  = Color(red: 0x5B/255, green: 0xC9/255, blue: 0xB0/255)
    static let amanita      = Color(red: 0x8C/255, green: 0x2A/255, blue: 0x2A/255)
}

extension Font {
    static func display(_ size: CGFloat, italic: Bool = true) -> Font {
        var f = Font.custom("Cochin", size: size)
        if italic { f = f.italic() }
        return f
    }

    static func specimen(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .monospaced)
    }
}
