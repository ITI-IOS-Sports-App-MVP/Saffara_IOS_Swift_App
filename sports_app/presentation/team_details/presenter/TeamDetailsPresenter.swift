//
//  TeamDetailsPresenter.swift
//  sports_app
//

class TeamDetailsPresenter: TeamDetailsPresenterProtocol {
    
    private weak var view: TeamDetailsViewProtocol?
    private let getTeamDetailsUseCase: GetTeamDetailsUseCaseProtocol
    private let teamId: Int
    private let sport: String
    private let sportAndLeague: String
    
    private var players: [Player] = []
    
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
        
        getTeamDetailsUseCase.execute(sport: sport, teamId: teamId) { [weak self] result in
            guard let self = self else { return }
            self.view?.hideLoadingIndicator()
            
            switch result {
            case .success(let teams):
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
            case .failure(let error):
                self.view?.showError(message: error.localizedDescription)
            }
        }
    }
    
    func getPlayersCount() -> Int {
        return players.count
    }
    
    func getPlayer(at index: Int) -> Player {
        return players[index]
    }
}
