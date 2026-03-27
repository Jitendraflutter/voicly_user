# Agora WebRTC and Core Rules
-keep class io.agora.** { *; }
-dontwarn io.agora.**

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}