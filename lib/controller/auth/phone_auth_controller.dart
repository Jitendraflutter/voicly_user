import 'dart:async';
import 'dart:math';

import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voicly/core/route/routes.dart';
import 'package:voicly/core/utils/local_storage.dart';
import 'package:voicly/features/auth/verify_otp_screen.dart';
import 'package:voicly/model/user_model.dart';
import 'package:voicly/networks/user_service.dart';
// import 'package:voicly/core/route/routes.dart'; // Adjust to your routes

class PhoneAuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepo = Get.find<UserRepository>();
  var isLoading = false.obs;
  var verificationId = ''.obs;
  var mobileNumber = '';

  // 🟢 Add these for the timer
  var timerSeconds = 60.obs;
  var canResend = false.obs;
  Timer? _countdownTimer;

  // 🟢 Call this right after codeSent is triggered in verifyPhoneNumber()
  void startTimer() {
    timerSeconds.value = 60;
    canResend.value = false;
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        canResend.value = true;
        _countdownTimer?.cancel();
      }
    });
  }

  @override
  void onClose() {
    _countdownTimer?.cancel(); // Clean up memory when closing
    super.onClose();
  }

  // 1. Send the OTP to the phone number
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    try {
      isLoading.value = true;
      mobileNumber = phoneNumber;
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _signInWithCredential(credential);
        },

        verificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          Get.snackbar(
            "Error",
            e.message ?? "Verification failed",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        },

        // Triggered when the SMS is successfully sent
        codeSent: (String verId, int? resendToken) {
          isLoading.value = false;
          verificationId.value = verId;

          // 🟢 Start the 60-second timer
          startTimer();

          // 🟢 Close the bottom sheet and open the OTP screen
          Get.to(() => OtpVerificationScreen(phoneNumber: phoneNumber));
        },

        // Timeout for auto-retrieval
        codeAutoRetrievalTimeout: (String verId) {
          verificationId.value = verId;
        },
      );
    } catch (e) {
      isLoading.value = false;
      errorSnack(e.toString());
    }
  }

  Future<void> verifyOTP(String otp) async {
    try {
      isLoading.value = true;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );
      await _signInWithCredential(credential);
    } catch (e) {
      isLoading.value = false;
      warningSnack("Invalid OTP,Please enter the correct code.");
    }
  }

  // 3. Complete the Sign In
  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      int randomDigits = Random().nextInt(99999);
      String randomName = "Voicly_$randomDigits";

      // Optional: Using a free API to generate a cool random avatar based on their random name!
      String randomAvatar =
          "https://firebasestorage.googleapis.com/v0/b/voicly-15ec0.firebasestorage.app/o/male_avatar%2Favatar.webp?alt=media&token=ca1b8001-6349-4d55-a6ea-01090c8a19d8";

      User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        UserModel newUser = UserModel(
          uid: firebaseUser.uid,
          fullName: randomName,
          email: "",
          mobile: mobileNumber,
          profilePic: randomAvatar,
          gender: "Male", // To be filled by user
          points: 45, // Default points for new users
          isActive: true,
          bio: "Hey there! I am using Voicly.",
        );

        await _userRepo.createUserIfNotExist(newUser);
        final user = await _userRepo.watchUser(firebaseUser.uid).first;
        final token = await FirebaseMessaging.instance.getToken();
        _userRepo.updateUserData(user.uid, {"fcmToken": token});
        _saveUserToLocal(user);
        Get.offAllNamed(AppRoutes.HOME);
      }
    } on FirebaseAuthException catch (e) {
      errorSnack(e.message ?? "Unknown error occurred.");
    } finally {
      isLoading.value = false;
    }
  }

  void _saveUserToLocal(UserModel user) {
    LocalStorage.setUid(user.uid);
    LocalStorage.setEmail(user.email ?? "");
    LocalStorage.setFirstName(user.fullName); // You can split name if needed
    LocalStorage.setProfileUrl(user.profilePic);
    LocalStorage.setPoints(user.points);
    LocalStorage.setAccessToken(user.uid);
  }
}
