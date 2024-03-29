# CardFortress

[![codecov](https://codecov.io/github/RobertiOS/CardFortress/branch/development/graph/badge.svg?token=Q0NMPMGYAY)](https://codecov.io/github/RobertiOS/CardFortress)
[![Build and Test](https://github.com/RobertiOS/CardFortress/actions/workflows/build.yml/badge.svg?branch=development)](https://github.com/RobertiOS/CardFortress/actions/workflows/build.yml)

## Features
- [x] Secure storage using keychain
- [x] Vison kit to scan credit cards.
- [x] Sign-in and sign-out using firebase auth
- [x] Widgets
- [x] Login with biometrics
- [ ] Encrypt credit cards and store in remote server.
- [ ] Feature flags
- [ ] Analytics
- [ ] Omboarding
- [x] Deeplinking

### Suported deeplinks
- Sign in: `xcrun simctl openurl booted "cardfortress://login?email=yourUser&password=yourPassword"`

## Todos
- [ ] Improve UI, app colors, styles, icons, etc.
- [ ] Implement some automations for localizable strings, assets, and colors accross all modules on the project.
- [ ] Organize files and make some minor clean ups to align with clean architecture accordingly.

### Architecture
#### MVVM + Coordinator

![image](https://github.com/RobertiOS/CardFortress/assets/93169254/43bafce4-314a-4b3a-9ac5-ec7003be55bf)


#### Clean architecture
![image](https://github.com/RobertiOS/CardFortress/assets/93169254/454b0a3a-fb25-4123-884b-89d8c50a2f5f)


#### Microapps architecture

![image](https://github.com/RobertiOS/CardFortress/assets/93169254/6a1c801b-1bde-4db8-a977-c194756d1ba4)



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
| ![Screenshot 2024-02-21 at 12 43 06 PM](https://github.com/RobertiOS/CardFortress/assets/93169254/4b625417-a86a-472c-93f1-2c9ffad8b680) | ![Screenshot 2023-10-20 at 10 56 24 PM](https://github.com/RobertiOS/CardFortress/assets/93169254/689b74c0-e9e3-4759-ab03-7976a86d6a28) |
| ![Screenshot 2023-10-20 at 10 56 10 PM](https://github.com/RobertiOS/CardFortress/assets/93169254/85f174ff-ccb2-453f-8ca4-0d97e458a16c) | ![Untitled-ezgif com-video-to-gif-converter](https://github.com/RobertiOS/CardFortress/assets/93169254/48a574a6-0807-44eb-8dde-87cad1c44bfc) |

