import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/core/widgets/custom_snackbar.dart';
import 'package:select_sports/providers/responsive_provider.dart';
import 'package:toastification/toastification.dart';
import 'main_controller.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  DateTime? currentBackPressTime;
  bool canPopNow = false;
  int requiredSeconds = 2;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(mainControllerProvider);
    final controller = ref.read(mainControllerProvider.notifier);

    return Scaffold(
      body: PopScope(
        canPop: canPopNow,
        onPopInvoked: onPopInvoked,
        child: SizedBox(
          height: 100.h,
          width: 100.w,
          child: Stack(
            children: [
              controller.pages[selectedIndex],
              Positioned(
                bottom: 40,
                left: 2.5.w,
                child: Container(
                  width: 95.w,
                  padding: EdgeInsets.symmetric(vertical: 2.5.w),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlack,
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: controller.navItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return _buildNavItem(
                          item['icon'], item['label'], index, ref);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onPopInvoked(bool didPop) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) >
            Duration(seconds: requiredSeconds)) {
      currentBackPressTime = now;
      CustomSnackBar.showWarning("Press Again to exit..!");
      Future.delayed(
        Duration(seconds: requiredSeconds),
        () {
          setState(() {
            canPopNow = false;
          });
          toastification.dismissAll();
        },
      );
      // Ok, let user exit app on the next back press
      setState(() {
        canPopNow = true;
      });
    }
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    WidgetRef ref,
  ) {
    final isSelected = ref.watch(mainControllerProvider) == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(mainControllerProvider.notifier).updateIndex(index);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ref.watch(isTabletProvider) ? 1.5.w: 3.5.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? AppColors.lightGreenColor : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.darkText : Colors.grey,
                size: ref.watch(isTabletProvider) ? 17.sp : 18.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
