# Finance Flow

Sistema de gestão financeira responsivo para Android, iOS, Windows, macOS, Linux e Web com Flutter.

## Arquitetura

```text
lib/
├── core/
│   └── theme/
├── data/
│   ├── datasources/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── bloc/
│   ├── pages/
│   └── widgets/
└── main.dart
```

## Tecnologias

- Flutter
- Dart
- Clean Architecture
- BLoC
- fl_chart
- Material 3
- Intl
- Equatable

## Executar

```bash
flutter create .
flutter pub get
flutter run
```

Para desktop:

```bash
flutter run -d windows
```

Para web:

```bash
flutter run -d chrome
```

O datasource atual é local e em memória. A camada `data` está isolada para permitir trocar posteriormente por SQLite, Drift, Isar, Supabase, Firebase ou uma API REST sem alterar a camada de domínio.
