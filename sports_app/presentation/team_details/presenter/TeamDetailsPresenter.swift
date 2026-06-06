import Foundation
import Combine

class TeamDetailsPresenter: TeamDetailsPresenterProtocol {
    
    private weak var view: TeamDetailsViewProtocol?
    private let getTeamDetailsUseCase: GetTeamDetailsUseCaseProtocol
    private let teamId: Int
    private let sport: String
    private let sportAndLeague: String
    
    private var players: [Player] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(view: TeamDetailsViewProtocol,
         getTeamDetailsUseCase: GetTeamDetailsUseCaseProtocol,
         teamId: Int,
         sport: String,
         sportAndLeague: String) {
        self.view = view
        self.getTeamDetailsUseCase = getTeamDetailsUseCase
        self.teamId = teamId
        self.sport = sport
        self.sportAndLeague = sportAndLeague
    }
    
    func viewDidLoad() {
        view?.showLoadingIndicator()
        
        getTeamDetailsUseCase.execute(sport: sport, teamId: teamId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.view?.hideLoadingIndicator()
                if case .failure(let error) = completion {
                    self.view?.showError(message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] teams in
                guard let self = self else { return }
                if let team = teams.first {
                    self.players = team.players ?? []
                    self.view?.displayTeamHeader(
                        name: team.displayTeamName,
                        logo: team.displayTeamLogo,
                        sportAndLeague: self.sportAndLeague
                    )
                    self.view?.reloadPlayersList()
                } else {
                    self.view?.showError(message: "Team details not found.")
                }
            })
            .store(in: &cancellables)
    }
    
    func getPlayersCount() -> Int {
        return players.count
    }
    
    func getPlayer(at index: Int) -> Player {
        return players[index]
    }
}
