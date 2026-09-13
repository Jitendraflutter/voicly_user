# Reusable Widgets

**1. ScreenWrapper (`lib/widget/screen_wrapper.dart`)**
- Always use this to wrap main screens instead of a bare `Scaffold` to maintain background theme consistency.
- **Properties**:
  - `child` (Widget): The main content of the screen.
  - `title` (String?): Optional app bar title text.
  - `visibleAppBar` (bool): Defaults to false. If true, displays a transparent `AppBar` with a back button.
- **Features**: Always includes `MiniCallOverlay()` floating at the bottom for handling active background calls globally.

**2. VoiclyAvatar (`lib/widget/voicly_avatar.dart`)**
- A specialized circular avatar widget for displaying profile images with an optional online status indicator and premium gradient border.
- **Properties**:
  - `imageUrl` (String): The network URL image to load via `CachedNetworkImageProvider`.
  - `isOnline` (bool): If true, displays a green status dot indicating presence; else grey.
  - `radius` (double): Default `40`.
  - `showStatus` (bool): Default `true`. Toggle the visibility of the status dot.
  - `borderWidth` (double): Adjusts the premium gradient border thickness.

**3. MiniCallOverlay (`lib/features/call/mini_call_overlay.dart`)**
- Represents a minimized active call view. It is embedded directly within the `ScreenWrapper` to guarantee it persists across all screen navigations.
