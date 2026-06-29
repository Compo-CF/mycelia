import SwiftUI

enum MoriState {
    case watching, attentive, listening, concerned, pleased, asleep
}

struct MoriView: View {
    var state: MoriState = .watching
    var size: CGFloat = 80

    var body: some View {
        ZStack {
            if state == .pleased {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.foxfireTeal.opacity(0.55), .clear],
                            center: .center, startRadius: 0, endRadius: size * 0.55
                        )
                    )
                    .frame(width: size * 1.5, height: size * 1.5)
                    .opacity(pulseOpacity)
            }

            mushroomBody
                .rotationEffect(.degrees(rotationDegrees))
                .offset(y: state == .asleep ? size * 0.03 : 0)

            eyes
        }
        .frame(width: size, height: size * 1.4)
        .onAppear { pulseOpacity = 1.0 }
    }

    @State private var pulseOpacity: Double = 0.55

    private var rotationDegrees: Double {
        switch state {
        case .concerned: return -12
        case .asleep:    return 6
        default:         return 0
        }
    }

    private var mushroomBody: some View {
        ZStack {
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [Color(red: 0x5C/255, green: 0x47/255, blue: 0x38/255),
                                 Color(red: 0x2C/255, green: 0x21/255, blue: 0x1A/255)],
                        center: UnitPoint(x: 0.5, y: 0.35),
                        startRadius: 0, endRadius: size * 0.55
                    )
                )
                .overlay(honeycombDots)
                .frame(width: size * 0.76, height: size * 0.96)
                .offset(y: -size * 0.18)

            stipe
                .fill(
                    RadialGradient(
                        colors: [Color.sporeDust, Color.oldLeaf],
                        center: UnitPoint(x: 0.5, y: 0.4),
                        startRadius: 0, endRadius: size * 0.4
                    )
                )
                .frame(width: size * 0.4, height: size * 0.6)
                .offset(y: size * 0.4)

            Circle()
                .fill(Color.foxfireTeal.opacity(0.5))
                .frame(width: size * 0.05, height: size * 0.05)
                .offset(x: size * 0.27, y: -size * 0.05)
                .opacity(pulseOpacity)
        }
        .animation(
            .easeInOut(duration: 2.4).repeatForever(autoreverses: true),
            value: pulseOpacity
        )
    }

    private var honeycombDots: some View {
        Canvas { ctx, sz in
            let rows = 10, cols = 6
            for r in 0..<rows {
                for c in 0..<cols {
                    let xOffset = (r % 2 == 0) ? 0.0 : sz.width / Double(cols) / 2.0
                    let x = Double(c) * sz.width / Double(cols) + xOffset
                    let y = Double(r) * sz.height / Double(rows)
                    let rect = CGRect(x: x, y: y, width: sz.width / Double(cols) * 0.7, height: sz.height / Double(rows) * 0.55)
                    ctx.fill(
                        Path(ellipseIn: rect),
                        with: .color(Color(red: 0x1A/255, green: 0x14/255, blue: 0x0F/255).opacity(0.55))
                    )
                }
            }
        }
        .mask(Ellipse())
    }

    private func stipe(in rect: CGRect) -> Path {
        Path { p in
            let w = rect.width, h = rect.height
            p.move(to: CGPoint(x: w * 0.1, y: 0))
            p.addQuadCurve(to: CGPoint(x: w * 0.2, y: h),
                           control: CGPoint(x: -w * 0.05, y: h * 0.55))
            p.addLine(to: CGPoint(x: w * 0.8, y: h))
            p.addQuadCurve(to: CGPoint(x: w * 0.9, y: 0),
                           control: CGPoint(x: w * 1.05, y: h * 0.55))
            p.closeSubpath()
        }
    }

    private var eyes: some View {
        HStack(spacing: size * 0.16) {
            eye
            eye
        }
        .offset(y: size * 0.48)
    }

    @ViewBuilder
    private var eye: some View {
        switch state {
        case .watching, .pleased:
            Ellipse()
                .fill(Color.hollowBlack)
                .frame(width: size * 0.07, height: size * 0.09)
        case .attentive:
            Ellipse()
                .fill(Color.hollowBlack)
                .frame(width: size * 0.085, height: size * 0.105)
        case .listening:
            Capsule()
                .fill(Color.hollowBlack)
                .frame(width: size * 0.10, height: size * 0.025)
        case .concerned:
            Ellipse()
                .fill(Color.hollowBlack)
                .frame(width: size * 0.06, height: size * 0.075)
        case .asleep:
            Path { p in
                p.move(to: .zero)
                p.addQuadCurve(to: CGPoint(x: size * 0.10, y: 0),
                               control: CGPoint(x: size * 0.05, y: size * 0.018))
            }
            .stroke(Color.hollowBlack, lineWidth: 1.6)
            .frame(width: size * 0.10, height: size * 0.025)
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        MoriView(state: .watching)
        MoriView(state: .attentive)
        MoriView(state: .listening)
        MoriView(state: .concerned)
        MoriView(state: .pleased)
        MoriView(state: .asleep)
    }
    .padding()
    .background(Color.hollowBlack)
}
