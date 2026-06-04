import XCTest
import Combine
@testable import sports_app

final class NetworkServiceTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        cancellables = []
    }

    override func tearDownWithError() throws {
        cancellables = nil
    }

    func testLeagueModelDecoding() throws {
        // Arrange
        let jsonString = """
        {
            "success": 1,
            "result": [
                {
                    "league_key": 4,
                    "league_name": "UEFA Europa League",
                    "country_key": 1,
                    "country_name": "eurocups",
                    "league_logo": "https://apiv2.allsportsapi.com/logo/logo_leagues/4_uefa_europa_league.png",
                    "league_year": "2023/2024"
                }
            ]
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        // Act
        let response = try decoder.decode(AllSportsResponse<League>.self, from: jsonData)
        
        // Assert
        XCTAssertEqual(response.success, 1)
        XCTAssertEqual(response.result?.count, 1)
        let league = response.result?.first
        XCTAssertEqual(league?.leagueKey, 4)
        XCTAssertEqual(league?.leagueName, "UEFA Europa League")
        XCTAssertEqual(league?.leagueCountry, "eurocups")
        XCTAssertEqual(league?.leagueLogo, "https://apiv2.allsportsapi.com/logo/logo_leagues/4_uefa_europa_league.png")
    }
    
    func testEventModelDecoding() throws {
        // Arrange
        let jsonString = """
        {
            "success": 1,
            "result": [
                {
                    "event_key": 123,
                    "event_date": "2026-06-05",
                    "event_time": "20:00",
                    "event_home_team": "Home",
                    "event_away_team": "Away",
                    "home_team_logo": "home.png",
                    "away_team_logo": "away.png",
                    "event_final_result": "2 - 1"
                }
            ]
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Act
        let response = try decoder.decode(AllSportsResponse<Event>.self, from: jsonData)
        
        // Assert
        XCTAssertEqual(response.result?.count, 1)
        let event = response.result?.first
        XCTAssertEqual(event?.eventKey, 123)
        XCTAssertEqual(event?.eventHomeTeam, "Home")
        XCTAssertEqual(event?.displayHomeScore, "2")
        XCTAssertEqual(event?.displayAwayScore, "1")
    }
}
