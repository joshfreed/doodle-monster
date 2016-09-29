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

class SessionMock: DoodMonSession {
    var me: Player?
    var token: String?
    var loggedOut = false
    
    func logout() {
        loggedOut = true
    }
    
    func hasSession() -> Bool {
        return false
    }
    
    func setSession(token: String, player: Player) {
        
    }
    
    func resume() {
        
    }
}

class ApiServiceMock: DoodMonApi {
    var lastSearchedFor: String?
    var nextResult: SearchResult?
    var players: [Player] = []
    
    var activeGames: [Game] = []
    var createGameResult: Result<Game>?
    var calledCreateGame = false
    
    func setActiveGames(_ games: [Game]) {
        activeGames = games
    }

    // MARK: - Auth
    
    func tryToLogIn(_ username: String, password: String, callback: @escaping (LoginResult) -> ()) {
        
    }
    
    func loginByFacebook(withToken accessToken: String, completion: @escaping (Result<Bool>) -> ()) {
        
    }
    
    // MARK: - Player
    
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
    
    // MARK: Game
    
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




