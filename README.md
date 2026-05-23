# trabalhomobilep2

Guia completo para configurar e rodar este projeto Flutter.

## 1. Pre-requisitos

Instale:

- Flutter SDK
- Android Studio (com Android SDK)
- Java (normalmente via Android Studio)
- VS Code (opcional)

Depois valide:

```powershell
flutter doctor
```

Se aparecer pendencia de licencas Android:

```powershell
flutter doctor --android-licenses
```

## 2. Entrar na pasta do projeto

```powershell
cd C:\Users\gabri\OneDrive\Documentos\trabalhomobilep2
```

## 3. Instalar dependencias

```powershell
flutter pub get
```

## 4. Rodar no Android (emulador)

### 4.1 Listar emuladores

```powershell
flutter emulators
```

### 4.2 Iniciar o emulador

Exemplo com o seu emulador:

```powershell
flutter emulators --launch Medium_Phone_API_36.1
```

### 4.3 Verificar dispositivos conectados

```powershell
flutter devices
```

### 4.4 Rodar o app no emulador

```powershell
flutter run -d emulator-5554
```

Se quiser deixar o Flutter escolher automaticamente:

```powershell
flutter run
```

## 5. Rodar no Android (celular fisico)

1. Ative Opcoes do desenvolvedor no celular.
2. Ative Depuracao USB.
3. Conecte por cabo USB.
4. Aceite a autorizacao RSA no celular.
5. Rode:

```powershell
flutter devices
flutter run -d <id_do_celular>
```

## 6. Rodar no Windows (desktop)

```powershell
flutter run -d windows
```

## 7. Rodar na Web

```powershell
flutter run -d chrome
```

Ou no Edge:

```powershell
flutter run -d edge
```

## 8. Comandos uteis durante o desenvolvimento

```powershell
flutter clean
flutter pub get
flutter analyze
flutter test
```

## 9. Problemas comuns

### Nenhum dispositivo encontrado

```powershell
flutter devices
flutter emulators
flutter emulators --launch <id_do_emulador>
```

### Build travou no Gradle

```powershell
flutter clean
flutter pub get
flutter run -d emulator-5554
```

### Diagnostico completo

```powershell
flutter doctor -v
```

## 10. Build para distribuicao

APK (Android):

```powershell
flutter build apk --release
```

App Bundle (Play Store):

```powershell
flutter build appbundle --release
```

Web:

```powershell
flutter build web
```

Windows:

```powershell
flutter build windows
```

## 11. Estrutura principal do projeto

- `lib/main.dart`: ponto de entrada
- `lib/models/`: modelos de dados
- `lib/screens/`: telas
- `lib/widgets/`: componentes reutilizaveis

---

Se quiser, posso adicionar uma versao curta deste README so com o fluxo minimo (3 comandos) para uso rapido no dia a dia.
