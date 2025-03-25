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
                // Main content below the menu button
                VStack(spacing: 0) {
                    Spacer().frame(height: geometry.safeAreaInsets.top + 56) // leave space for button
                    content
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Floating menu button
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
                .padding(.top, geometry.safeAreaInsets.top + 12)
                .padding(.horizontal, 24)
            }
            .edgesIgnoringSafeArea(.top) // let button go into safe area, but not the content
        }
    }
}
