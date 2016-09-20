//
// Created by Josh Freed on 2/5/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import Foundation

class ViewModelFactory {
    weak fileprivate(set) var appDelegate: AppDelegate?

    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }

    func loginByEmailPresenter(_ view: LoginByEmailView) -> LoginByEmailPresenter {
        return LoginByEmailPresenter(view: view, session: appDelegate!.session)
    }

    func newMonsterViewModel(_ vc: NewMonsterViewController) -> NewMonsterViewModel {
        return NewMonsterViewModel(view: vc,
            session: appDelegate!.session,
            router: NewMonsterRouterImpl(vc: vc, vmFactory: self),
            applicationLayer: appDelegate!.doodleMonsterApp
        )
    }

    func mainMenuViewModel(_ vc: MainMenuViewController) -> MainMenuViewModel {
        return MainMenuViewModel(view: vc,
            gameService: appDelegate!.gameService,
            session: appDelegate!.session,
            router: MainMenuRouterImpl(vc: vc, vmFactory: self),
            listener: MainMenuViewModelListener(),
            applicationLayer: appDelegate!.doodleMonsterApp
        )
    }

    func drawingViewModel(_ game: Game, view: DrawingView) -> DrawingViewModel {
        return DrawingViewModel(view: view, game: game, gameService: appDelegate!.gameService)
    }

    func inviteByEmailViewModel(_ vc: InviteByEmailViewController) -> InviteByEmailViewModel {
        return InviteByEmailViewModel(view: vc, playerService: appDelegate!.playerService, session: appDelegate!.session, applicationLayer: appDelegate!.doodleMonsterApp)
    }
}
