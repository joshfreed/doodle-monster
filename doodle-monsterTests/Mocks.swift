//
// Created by Josh Freed on 2/11/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import UIKit
import EmitterKit
@testable import doodle_monster

class MainMenuViewMock: MainMenuView {
    var gameListWasUpdated = false

    func updateGameList() {
        gameListWasUpdated = true
    }
    
    func showServerError(_ err: Error) {
        
    }
}

class InviteByEmailViewMock: InviteByEmailView {
    var calledDisplayedSearchResults = false
    var calledSearchError = false
    
    func displaySearchResults() {
        calledDisplayedSearchResults = true
    }
    
    func displaySearchError() {
        calledSearchError = true
    }
}

class GameServiceMock: GameService {
    var activeGames: [Game] = []
    var createGameResult: Result<Game>?
    var calledCreateGame = false

    func setActiveGames(_ games: [Game]) {
        activeGames = games
    }

    // MARK: GameService

    func createGame(_ players: [Player], callback: @escaping (Result<Game>) -> ()) {
        calledCreateGame = true
        guard let result = createGameResult else {
            return
        }
        callback(result);
    }

    func getActiveGames(_ callback: @escaping (Result<[Game]>) -> ()) {
        callback(.success(activeGames))
    }

    func saveTurn(_ gameId: String, image: Data, letter: String, completion: @escaping (Result<Game>) -> ()) {

    }
    
    func loadImageData(_ gameId: String, completion: @escaping (Result<Data>) -> ()) {
        
    }
}

class SessionMock: SessionService {
    var currentPlayer: Player?
    var token: String?
    var loggedOut = false

    func hasSession() -> Bool {
        return false
    }

    func tryToLogIn(_ username: String, password: String, callback: @escaping (LoginResult) -> ()) {

    }

    func logout() {
        loggedOut = true
    }

    func resume() {

    }
    
    func setAuthToken(_ token: String, andPlayer playerDict: NSDictionary) {
        
    }
}

class MainMenuRouterMock: MainMenuRouter {
    var showedLoginScreen = false
    var showedNewMonsterScreen = false
    var showedGame: Game?

    func showNewMonsterScreen() {
        showedNewMonsterScreen = true
    }

    func showDrawingScreen(_ game: Game) {
        showedGame = game
    }

    func showLoginScreen() {
        showedLoginScreen = true
    }
}

class MainMenuViewModelListenerMock: MainMenuViewModelListener {
    override func startListening() {

    }

    override func stopListening() {

    }
}

class PlayerServiceMock: PlayerService {
    var lastSearchedFor: String?
    var nextResult: SearchResult?
    var players: [Player] = []

    func createUser(_ username: String, password: String, displayName: String, callback: @escaping (CreateUserResult) -> ()) {

    }

    func search(_ searchText: String, callback: @escaping (SearchResult) -> ()) {
        lastSearchedFor = searchText
        callback(nextResult!)
    }

    func playerBy(_ id: String) -> Player? {
        for player in players {
            if player.id == id {
                return player
            }
        }
        
        return nil
    }
}

class DoodleMonsterMock: DoodleMonster {
    var lastPlayerAdded: Player?
    
    // MARK:  Actions
    
    func createLobby() {
        
    }
    
    func cancelLobby() {
        
    }
    
    func addPlayer(_ player: Player) {
        lastPlayerAdded = player
    }
    
    func removePlayer(_ playerId: String) {
        
    }
    
    func startGame() {
        
    }
    
    func canStartGame() -> Bool {
        return false
    }
    
    // MARK: Events
    
    let playerAdded = Event<Player>()
    let playerRemoved = Event<Player>()
    let newGameStarted = Event<Game>()
}

class GraphicsContextMock: GraphicsContextService {
    var fullImageData: Data? {
        return nil
    }
    
    var currentImage: UIImage? {
        return nil
    }
    
    func setImageData(_ imageData: Data) {
        
    }
    
    func startDrawingLine(_ fromPoint: CGPoint, _ toPoint: CGPoint) {
        
    }
    
    func setNormalStroke() {
        
    }
    
    func setClearStroke() {
        
    }
    
    func endDrawingLine() {
        
    }
}

class StrokeHistoryMock: StrokeHistoryProtocol {
    var strokes: [Stroke] = []
    
    func addStroke(_ stroke: Stroke) {
        strokes.append(stroke)
    }
    
    func undo() {
        
    }
    
    func redo() {
        
    }
}

class FakeStroke: Stroke {
    var image: UIImage {
        return UIImage()
    }
}

class DrawingViewMock: DrawingView {
    var calledGoToMainMenu = false
    var calledShowCancelConfirmation = false
    
    func allowPanningAndZooming() -> Bool {
        return false
    }
    
    func switchToDrawMode() {
        
    }
    
    func switchToEraseMode() {
        
    }
    
    func showCancelConfirmation() {
        calledShowCancelConfirmation = true
    }
    
    func goToMainMenu() {
        calledGoToMainMenu = true
    }
    
    func showAlert(_ title: String, message: String) {
        
    }
    
    func showError(_ err: Error) {
        
    }
}

class DrawingServiceMock: DrawingServiceProtocol {
    var wasChanged = false
    
    var fullImageData: Data? {
        return nil
    }
    
    var drawingMode: DrawingMode
    
    init() {
        drawingMode = .draw
    }
    
    func setImageData(_ imageData: Data) {
        
    }
    func startDraw(_ currentPoint: CGPoint) {
        
    }
    func movePencilTo(_ currentPoint: CGPoint) {
        
    }
    func endDraw() {
        
    }
    func drawLineFrom(_ fromPoint: CGPoint, toPoint: CGPoint) {
        
    }
    func abortLine() {
        
    }
    func saveCurrentToHistory() {
        
    }
    func allowPanningAndZooming() -> Bool {
        return false
    }
    func hasMadeChanges() -> Bool {
        return wasChanged
    }
    func undo() {
        
    }
    func redo() {
        
    }
}




