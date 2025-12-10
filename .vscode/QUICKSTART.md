# VS Code Quick Start Guide

## Prerequisites
Make sure you have installed:
- Flutter SDK
- Dart SDK
- VS Code
- VS Code Extensions (will be suggested when opening the project)

## Getting Started

### 1. Install Recommended Extensions
When you open this project, VS Code will suggest installing recommended extensions. Click "Install All" or install them manually:
- Dart
- Flutter
- Flutter Riverpod Snippets
- Awesome Flutter Snippets
- Error Lens

### 2. Initial Setup
Use the Command Palette (`Ctrl/Cmd + Shift + P`) and run:
```
Tasks: Run Task → Setup: Full Setup
```

Or manually:
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Run the App

#### Option 1: F5 (Quick Debug)
Press `F5` to start debugging with default configuration

#### Option 2: Run & Debug Panel
1. Click the Run & Debug icon in the sidebar (or `Ctrl/Cmd + Shift + D`)
2. Select a configuration:
   - **Flutter: Run** - Debug mode (hot reload enabled)
   - **Flutter: Run (Profile)** - Performance testing
   - **Flutter: Run (Release)** - Production build
   - **Flutter: Run Chrome** - Web debugging

#### Option 3: Command Palette
`Ctrl/Cmd + Shift + P` → `Flutter: Select Device` → `Flutter: Run`

### 4. Hot Reload & Hot Restart
- **Hot Reload**: `r` in terminal or Save file (`Ctrl/Cmd + S`)
- **Hot Restart**: `R` in terminal or `Ctrl/Cmd + F5`

## Useful Commands

### Tasks (Ctrl/Cmd + Shift + P → Tasks: Run Task)
- `Flutter: Get Packages` - Install dependencies
- `Flutter: Clean` - Clean build files
- `Flutter: Build Runner (Build)` - Generate code once
- `Flutter: Build Runner (Watch)` - Watch for changes and regenerate
- `Flutter: Analyze` - Run static analysis
- `Flutter: Test` - Run tests
- `Flutter: Build APK/iOS/Web` - Build for platforms

### Code Actions
- `Ctrl/Cmd + .` - Show quick fixes and refactoring options
- `Ctrl/Cmd + Space` - Trigger suggestions
- `F2` - Rename symbol
- `Shift + Alt + F` - Format document

### Flutter Inspector
- Open with: `Ctrl/Cmd + Shift + P` → `Flutter: Open DevTools`
- Or in Debug mode, DevTools opens automatically

## Project Structure Navigation

```
lib/
├── main.dart                    # App entry point
├── core/
│   ├── api/                     # API clients
│   ├── models/                  # Data models
│   └── providers/               # Riverpod providers
├── features/
│   └── analytics/
│       ├── screens/             # Screen widgets
│       └── widgets/             # Feature widgets
└── shared/
    └── widgets/                 # Shared components
```

## Keyboard Shortcuts

### General
- `Ctrl/Cmd + P` - Quick Open File
- `Ctrl/Cmd + Shift + P` - Command Palette
- `Ctrl/Cmd + B` - Toggle Sidebar
- `Ctrl/Cmd + J` - Toggle Panel

### Flutter Specific
- `F5` - Start Debugging
- `Shift + F5` - Stop Debugging
- `Ctrl/Cmd + F5` - Hot Restart
- `Ctrl/Cmd + S` - Save & Hot Reload

### Code Navigation
- `F12` - Go to Definition
- `Alt + F12` - Peek Definition
- `Shift + F12` - Find All References
- `Ctrl/Cmd + Click` - Go to Definition

## Code Generation

After modifying models or API clients:

### One-time Generation
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Watch Mode (Auto-regenerate)
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

Or use Task: `Flutter: Build Runner (Watch)`

## Debugging Tips

1. **Breakpoints**: Click left of line number
2. **Conditional Breakpoints**: Right-click breakpoint → Edit Breakpoint
3. **Debug Console**: View variables and execute expressions
4. **Call Stack**: Navigate through function calls
5. **Widget Inspector**: Inspect widget tree in DevTools

## Common Issues

### Build Runner Conflicts
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Import Errors
- Use `Ctrl/Cmd + .` → "Organize Imports"
- Or Task: `Flutter: Analyze`

### Hot Reload Not Working
- Try Hot Restart (`R` or `Ctrl/Cmd + F5`)
- If still not working, restart the app

## Performance

### Profile Mode
Use "Flutter: Run (Profile)" configuration to:
- Test performance
- Profile with DevTools
- Identify bottlenecks

### Release Build
Use "Flutter: Run (Release)" for:
- Production-like performance
- Final testing before deployment

## Testing

Run tests:
- `Ctrl/Cmd + Shift + P` → `Flutter: Run Tests`
- Or Task: `Flutter: Test`
- Or in terminal: `flutter test`

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [VS Code Flutter Extension](https://dartcode.org)
