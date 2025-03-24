import Foundation
import Combine

class SessionViewModel: ObservableObject {
    @Published var currentSession: Session?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let sessionService: SessionService
    private var cancellables = Set<AnyCancellable>()
    
    init(service: SessionService = SessionService()) {
        self.sessionService = service
        fetchCurrentSession()
    }
    
    func fetchCurrentSession() {
        isLoading = true
        errorMessage = nil
        
        sessionService.fetchCurrentSession()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] session in
                self?.currentSession = session
            }
            .store(in: &cancellables)
    }
    
    func createSession(beginDate: Date, endDate: Date, commission: Int, fees: Int) {
        guard currentSession == nil else {
            errorMessage = "Une session est déjà en cours."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        sessionService.createSession(beginDate: beginDate, endDate: endDate, commission: commission, fees: fees)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] in
                self?.fetchCurrentSession()
            }
            .store(in: &cancellables)
    }
    
    func updateSession(id: Int, beginDate: Date?, endDate: Date?, commission: Int?, fees: Int?) {
        isLoading = true
        errorMessage = nil
        
        sessionService.updateSession(id: id, beginDate: beginDate, endDate: endDate, commission: commission, fees: fees)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] in
                self?.fetchCurrentSession()
            }
            .store(in: &cancellables)
    }
    
    func deleteSession(id: Int) {
        isLoading = true
        errorMessage = nil
        
        sessionService.deleteSession(id: id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] in
                self?.fetchCurrentSession()
            }
            .store(in: &cancellables)
    }
}
