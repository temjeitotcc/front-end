# Testando no iOS

Para rodar este app em iOS, use um Mac com Xcode instalado.

## Primeira vez no Mac

```bash
flutter doctor
sudo xcodebuild -license
flutter pub get
cd ios
pod install
cd ..
```

## Rodar no simulador

```bash
open -a Simulator
flutter run
```

Se aparecer mais de um dispositivo:

```bash
flutter devices
flutter run -d ID_DO_DISPOSITIVO
```

## Rodar em iPhone real

Abra o projeto no Xcode:

```bash
open ios/Runner.xcworkspace
```

No Xcode:

1. Clique em `Runner`.
2. Abra `Signing & Capabilities`.
3. Escolha seu Apple ID/Team.
4. Troque o Bundle Identifier se o Xcode pedir.
5. Conecte o iPhone e rode pelo Xcode ou use `flutter run`.

## Se der problema com Pods

```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
flutter run
```

## Observacoes

- Notificacoes no iOS precisam de permissao do usuario.
- Algumas notificacoes locais podem se comportar diferente no simulador e no iPhone real.
- O app ja esta configurado com deployment target iOS 13.0.
