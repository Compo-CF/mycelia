import SwiftUI

struct ForestView: View {
    var body: some View {
        ZStack {
            Color.hollowBlack.ignoresSafeArea()

            VStack {
                HStack {
                    Text("FOREST FLOOR · 02:14")
                        .font(.specimen(11))
                        .tracking(2.2)
                        .foregroundStyle(Color.oldLeaf)
                    Spacer()
                    Text("▲ 0 SPORES")
                        .font(.specimen(11))
                        .tracking(2.2)
                        .foregroundStyle(Color.sporeDust)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                Spacer()
            }

            VStack {
                Spacer()
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Color.dampBark, Color(red: 0x2A/255, green: 0x1F/255, blue: 0x18/255)],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .frame(height: 28)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 130)
            }

            VStack {
                Spacer()
                LinearGradient(
                    colors: [.clear, Color.dampBark.opacity(0.5), Color.dampBark.opacity(0.8)],
                    startPoint: .top, endPoint: .bottom
                )
                .frame(height: 200)
            }
            .ignoresSafeArea()

            VStack {
                Spacer()
                HStack {
                    MoriView(state: .watching, size: 70)
                        .padding(.leading, 18)
                        .padding(.bottom, 24)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ForestView()
}
