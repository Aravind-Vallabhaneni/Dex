# Dex – A Modern Pokédex Built with SwiftUI

Dex is an iOS application developed using SwiftUI that allows users to browse, search, and manage Pokémon data via PokéAPI. The app supports offline functionality, dynamic UI based on Pokémon types, and Home Screen widgets for quick access to favorite Pokémon.

## Features

- Search and filter Pokémon by name or type with real-time updates.
- Mark Pokémon as favorites with swipe actions, backed by Core Data.
- Offline caching of Pokémon details with robust error handling.
- Type-based dynamic UI with responsive layouts and background visuals.
- Home Screen widget using WidgetKit and SwiftData to display favorites.

## Tech Stack

| Layer         | Technology            |
|---------------|------------------------|
| UI            | SwiftUI                |
| API           | PokéAPI                |
| Local Storage | Core Data, SwiftData   |
| Widget        | WidgetKit              |
| State Mgmt    | @State, @FetchRequest  |
| Error Handling| do-try-catch, fallback logic |

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/Dex.git
