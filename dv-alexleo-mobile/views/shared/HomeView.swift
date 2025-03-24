import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        VStack {
            // Main content
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .orange))

                } else if let error = viewModel.errorMessage {
                    ErrorView(error: error)

                } else if let session = viewModel.currentSession {
                    ActiveSessionView(session: session)

                } else {
                    NoSessionView()
                }
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal, 24)

            Spacer()
        }
    }
}
