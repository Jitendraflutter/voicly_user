import 'dart:ui';

import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 🟢 Added import
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:voicly/controller/home_controller.dart';
import 'package:voicly/controller/popup_controller.dart';
import 'package:voicly/core/constant/app_assets.dart';
import 'package:voicly/core/route/routes.dart';
import 'package:voicly/features/home/widget/animate_pulse_widget.dart';
import 'package:voicly/features/home/widget/match_dialog.dart';
import 'package:voicly/features/home/widget/profile_sheet.dart';
import 'package:voicly/model/caller_model.dart';
import 'package:voicly/networks/auth_services.dart';
import 'package:voicly/widget/screen_wrapper.dart';

import '../../controller/banner_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = Get.put(HomeController());
  final BannerController _bannerController = Get.put(BannerController());
  final popupController = Get.find<PopupController>();
  final authService = Get.find<AuthService>();

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 1500)).then((value) {
      popupController.checkBalanceAndCall(
        authService.currentUser.value?.points.toInt() ?? 0,
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 80.0.h,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 15,
                  sigmaY: 15,
                ), // Kept absolute for crisp blur
                child: FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  title: _buildAppBarContent(authService),
                ),
              ),
            ),
          ),

          Obx(() {
            if (_bannerController.isLoading.value ||
                _bannerController.currentBanner.value == null) {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }

            final banner = _bannerController.currentBanner.value!;

            return SliverToBoxAdapter(
              child: AnimatedPulseWidget(
                visible: banner.isActive,
                banner: banner,
                onTap: () {
                  if (banner.targetScreen == "/matching_screen") {
                    MatchDialog.show(_controller.callers);
                  } else {
                    Get.toNamed(AppRoutes.COIN);
                  }
                },
              ),
            );
          }),

          _buildHistoryButton("Your Companions"),

          Obx(() => _buildListView(_controller.callers)),
          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      ),
    );
  }

  Widget _buildAppBarContent(AuthService auth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(AppAssets.appName, height: 25.h, fit: BoxFit.fitHeight),

        Row(
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Get.toNamed(AppRoutes.COIN),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(7.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withValues(alpha: 0.4),
                            blurRadius: 8.r,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        AppAssets.vp,
                        width: 20.w,
                        height: 20.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Obx(() {
                      final user = auth.currentUser.value;
                      return Text(
                        (auth.currentUser.value?.points ?? 0).toString(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onBackground,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Obx(() {
              final user = auth.currentUser.value;

              return Hero(
                tag: "profile_pic",
                child: VoiclyAvatar(
                  radius: 14.r,
                  borderWidth: 1.0, // Kept absolute for crisp border
                  imageUrl: user?.profilePic ?? AppAssets.userUrl,
                  showStatus: false,
                  onTap: () => Get.toNamed(AppRoutes.PROFILE),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildListView(List<CallerModel> caller) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final caller = _controller.callers[index];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: GlassContainer(
            child: Row(
              children: [
                VoiclyAvatar(
                  radius: 35.r,
                  imageUrl: caller.profilePic.isNotEmpty
                      ? caller.profilePic
                      : AppAssets.userUrl,
                  isOnline: caller.isOnline ?? false,
                  onTap: () => Get.bottomSheet(
                    FractionallySizedBox(
                      heightFactor: 3 / 4,
                      child: ProfileSheet(callerModel: caller),
                    ),
                  ),
                ),
                SizedBox(width: 15.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        caller.fullName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: AppColors.onBackground,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        Helpers.ageFormatter(caller.dob.toString()),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryPeach,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        caller.isOnline == true
                            ? caller.callStatus == "active"
                                  ? "Busy"
                                  : "Online"
                            : "Offline",
                        style: TextStyle(
                          color: caller.isOnline == true
                              ? caller.callStatus == "active"
                                    ? Colors.red
                                    : Colors.green
                              : AppColors.grey,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 3.w),
                Row(
                  children: [
                    CallButton(
                      icon: CupertinoIcons.phone_fill,
                      color: caller.isOnline == true
                          ? AppColors.onPrimary
                          : Colors.grey.shade600,
                      onTap: caller.isOnline == false
                          ? () {
                              Fluttertoast.showToast(
                                msg: "The user is currently offline",
                              );
                            }
                          : () {
                              if (caller.callStatus == "active") {
                                Fluttertoast.showToast(
                                  msg: "The user is currently Busy",
                                );
                                return;
                              }
                              _controller.startCall(caller);
                            },
                    ),
                    SizedBox(width: 4.w),
                    CallButton(
                      icon: CupertinoIcons.videocam_fill,
                      color:
                          (caller.isOnline == true &&
                              caller.isVideoEnable == true)
                          ? AppColors.onPrimary
                          : Colors.grey.shade600,
                      onTap: () {
                        if (caller.isOnline == false) {
                          Fluttertoast.showToast(
                            msg: "The user is currently offline",
                          );
                          return;
                        }
                        if (caller.isVideoEnable == false) {
                          Fluttertoast.showToast(
                            msg: "This user has disabled video calls",
                          );
                          return;
                        }
                        if (caller.callStatus == "active") {
                          Fluttertoast.showToast(
                            msg: "The user is currently Busy",
                          );
                          return;
                        }
                        _controller.startCall(caller, isVideo: true);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }, childCount: _controller.callers.length),
    );
  }

  Widget _buildHistoryButton(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.onBackground.withValues(alpha: 0.8),
              ),
            ),
            const Spacer(),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Get.toNamed(AppRoutes.HISTORY);
              },
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  CupertinoIcons.clock,
                  color: AppColors.onBackground,
                  size: 20.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
