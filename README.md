# CardFortress

[![codecov](https://codecov.io/github/RobertiOS/CardFortress/branch/development/graph/badge.svg?token=Q0NMPMGYAY)](https://codecov.io/github/RobertiOS/CardFortress)
[![Build and Test](https://github.com/RobertiOS/CardFortress/actions/workflows/build.yml/badge.svg?branch=development)](https://github.com/RobertiOS/CardFortress/actions/workflows/build.yml)


## Features
- [x] Secure storage using keychain3
- [x] Vison kit to scan credit cards.
- [x] Sign-in and sign-out using firebase auth
- [x] Widgets
- [x] Login with biometrics
- [ ] Clean architecture
- [ ] Encrypt credit cards and store in remote server.
- [ ] Feature flags
- [ ] Analytics
- [ ] Ombording
- [ ] Deeplink

## Todos
- [ ] Improve UI, app colors, styles, icons, etc.
- [ ] Implement some automations for localizable strings, assets, and colors accross all modules on the project.
- [ ] Organize files and make some minor clean ups to align with clean architecture accordingly.

### Architecture
MVVM + Coordinator

### Design patterns
- Coordinator
- Factory
- Repository
- Dependency injection

### External Dependencies
- Firebase auth: to handle authentication
- Firebase firestore: to store user's account information
- Swinject: Dependency injection

I know the UI is not the best part of the app, but that's not my goal on this project.

## Screenshots

|  |  |
|- | - |
| ![Screenshot 2023-10-20 at 10 56 13 PM](https://github.com/RobertiOS/CardFortress/assets/93169254/b2dad9e1-f5de-4c9a-a803-2217752903c6) | ![Screenshot 2023-10-20 at 10 56 24 PM](https://github.com/RobertiOS/CardFortress/assets/93169254/df5094f0-9de3-4a35-87fe-19b6181fb0e0) |
| ![Screenshot 2023-10-20 at 10 56 10 PM](https://github.com/RobertiOS/CardFortress/assets/93169254/f93d78d7-e8ab-4bbc-8f97-4d6e90e2892b) | ![Screenshot 2023-10-20 at 10 58 29 PM](https://github.com/RobertiOS/CardFortress/assets/93169254/cc81363c-fd86-4bec-b521-63c9a296426b) |
