import SwiftUI

struct ScreenWrapper<Content: View>: View {
    @Binding var presentSideMenu: Bool
    let content: Content

    init(presentSideMenu: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._presentSideMenu = presentSideMenu
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                // Main content, padded to avoid overlap
                VStack {
                    content
                }
                .padding(.top, 72) // spacing below menu icon
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Menu icon — respects safe area
                HStack {
                    Button {
                        presentSideMenu.toggle()
                    } label: {
                        Image("menu")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, geometry.safeAreaInsets.top + 12) // dynamic top padding
            }
            .ignoresSafeArea(edges: .top)
        }
    }
}
