import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/core/widgets/common_bottom_sheet.dart';
import 'package:select_sports/features/bookings/presentation/bookings_screen.dart';
import 'package:select_sports/features/home/presentation/home_controller.dart';
import 'package:gradient_slide_to_act/gradient_slide_to_act.dart';
import 'package:select_sports/features/home/presentation/razorpay_controller.dart';
import 'package:select_sports/features/main/presentation/main_controller.dart';
import 'package:select_sports/providers/navigator_key.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void paymentBottomSheet(
  BuildContext context,
  bool isDarkMode,
  HomeController homeController,
  String slotId,
) {
  CommonBottomSheets.customDraggableBottomSheet(
    context,
    (controller) => Consumer(builder: (context, ref, child) {
      print(slotId);
      return Container(
        height: 75.h,
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 5.w),
                width: 60.0,
                height: 6.0,
                decoration: BoxDecoration(
                  color: AppColors.darkGreenColor,
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              SizedBox(height: 5.w),
              Text(
                "In-App Payment",
                style: AppTextStyles.subheading.copyWith(
                  color: isDarkMode
                      ? AppColors.lightGreenColor
                      : AppColors.darkGreenColor,
                ),
              ),
              Divider(
                color: isDarkMode
                    ? AppColors.darkGreyColor
                    : AppColors.lightestGreyColorV3,
              ),
              SizedBox(height: 5.w),
              // Container(
              //   padding:
              //       EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 1.5.w),
              //   decoration: BoxDecoration(
              //     color: isDarkMode
              //         ? AppColors.darkGreyColor
              //         : AppColors.lightText,
              //     borderRadius: BorderRadius.circular(2.5.w),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       _buildModeTabs(isDarkMode, ref, 0, "Wallet"),
              //       _buildModeTabs(isDarkMode, ref, 1, "Card"),
              //       _buildModeTabs(isDarkMode, ref, 2, "UPI"),
              //     ],
              //   ),
              // ),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Slide to pay',
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    speed: Duration(milliseconds: 100),
                  ),
                ],
                repeatForever: true,
                pause: Duration(milliseconds: 500),
                isRepeatingAnimation: true,
              ),
              SizedBox(height: 4.h),
              GradientSlideToAct(
                dragableIcon: Icons.credit_card,
                submittedIcon: Icons.done,
                text: 'Pay using Card / UPI / Online',
                width: 70.0.w,
                dragableIconBackgroundColor: Colors.greenAccent,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                ),
                backgroundColor: Colors.grey,
                onSubmit: () async {
                  var a = await homeController.initiatePayment(slotId, false);
                  print(a);

                  final razorpayController =
                      ref.read(razorpayControllerProvider);
                  razorpayController.openCheckout(a, slotId, false);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => RazorpayScreen(razorpayOptions: a,useWallet: false, slotId: slotId,),
                  //   ),
                  // );
                  // if (a.status == 200) {
                  // } else if (a.status == 402) {
                  //   print(a.status);
                  //   print(a.data);
                  // }
                },
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0Xff11998E),
                    Color(0Xff38EF7D),
                  ],
                ),
                iconSize: 12.sp,
              ),
              SizedBox(height: 4.h),
              GradientSlideToAct(
                dragableIcon: Icons.wallet,
                text: 'Pay using Wallet Balance',
                width: 70.w,
                dragableIconBackgroundColor: Colors.greenAccent,
                submittedIcon: Icons.done,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                ),
                iconSize: 12.sp,
                backgroundColor: Colors.grey,
                onSubmit: () async {
                  var a = await homeController.initiatePayment(slotId, true);
                  print(a);

                  final razorpayController =
                      ref.read(razorpayControllerProvider);
                  razorpayController.openCheckout(a, slotId, true);

                  final mainController =
                      ref.read(mainControllerProvider.notifier);
                  mainController.updateIndex(4); // Update to the 4th index
                  Navigator.pushReplacement(
                    ref.read(navigatorKeyProvider).currentContext!,
                    MaterialPageRoute(builder: (context) => BookingsScreen()),
                  );
                },
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0Xff11998E),
                    Color(0Xff38EF7D),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }),
  );
}

Widget _buildModeTabs(
  bool isDarkMode,
  WidgetRef ref,
  int index,
  String title,
) {
  return Consumer(
    builder: (context, ref, child) {
      final selectedPaymentMode = ref.watch(
          homeControllerProvider.select((state) => state.selectedPaymentMode));
      final bool isSelected = selectedPaymentMode == index;

      return Expanded(
        child: InkWell(
          onTap: () => ref
              .read(homeControllerProvider.notifier)
              .updatePaymentMode(index),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.5.w),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.darkGreenColor : Colors.transparent,
              borderRadius: BorderRadius.circular(2.5.w),
            ),
            child: Center(
              child: Text(
                title,
                style: AppTextStyles.body.copyWith(
                  color: isSelected
                      ? AppColors.lightText
                      : (isDarkMode
                          ? AppColors.lightGreyColor
                          : AppColors.darkText),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
