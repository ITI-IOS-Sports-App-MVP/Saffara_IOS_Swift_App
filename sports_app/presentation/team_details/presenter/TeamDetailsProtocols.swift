//
//  TeamDetailsProtocols.swift
//  sports_app
//

protocol TeamDetailsViewProtocol: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func displayTeamHeader(name: String, logo: String?, sportAndLeague: String)
    func reloadPlayersList()
    func showError(message: String)
}

protocol TeamDetailsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func getPlayersCount() -> Int
    func getPlayer(at index: Int) -> Player
}
