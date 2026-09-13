# Styling and Colors

- **Core Package Dependency**: UI colors and layout constants are overwhelmingly imported from the external package (`package:core/constants/app_colors.dart`).
- **Theme/Background**: The app utilizes a signature dark aesthetic heavily reliant on glowing radial gradients to create a premium feel.
- **Global Loading State**: Uses `loader_overlay` at the highest level to present a custom `CircularProgressIndicator` with `AppColors.primary`.
- **Screen Wrapper**: Instead of plain standard Scaffolds, main screens must be wrapped in `ScreenWrapper`. The wrapper provides the overarching dark purple/black gradient with signature radial "glow" spots (`topLeftGlow`, `topRightGlow`) in the background.
- **Status Bar**: `SystemUiOverlayStyle` is set globally in `App()` to be transparent with light icons (`Brightness.dark` for iOS, `Brightness.light` for Android icons).
- **Typography**: Text values are managed statically in `AppText` (`lib/core/constants/app_text.dart`). To ensure text scales correctly across devices, all font sizes must use `.sp` (e.g., `14.sp`).
