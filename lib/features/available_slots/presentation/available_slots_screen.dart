import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:select_sports/core/constants/paths.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/core/models/slot_model.dart';
import 'package:select_sports/core/widgets/common_appbar.dart';
import 'package:select_sports/core/widgets/visibility_widgets.dart';
import 'package:select_sports/features/available_slots/presentation/available_slots_controller.dart';
import 'package:select_sports/features/home/presentation/playground_details_screen.dart';
import 'package:select_sports/providers/theme_provider.dart';
import 'package:select_sports/utils/common_functions.dart';

class AvailableSlotsScreen extends ConsumerStatefulWidget {
  const AvailableSlotsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AvailableSlotsScreenState();
}

class _AvailableSlotsScreenState extends ConsumerState<AvailableSlotsScreen> {
  late Future<List<Slot>> _slotsFuture;

  @override
  void initState() {
    super.initState();
    final slotsController = ref.read(availableSlotsControllerProvider);
    _slotsFuture = slotsController.fetchAvailableSlots();
  }

  @override
  Widget build(BuildContext context) {
    // Check if the current theme mode is dark
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkScaffoldBackground
          : AppColors.lightestGreyColorV2,
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Column(
          children: [
            VisibilityWidgets.statusBarVisibleWidget(context: context),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: CommonAppbar.appbarWithoutLeading(
                context,
                isDarkMode,
                "Available Games slot",
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Slot>>(
                future: _slotsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error fetching slots"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No slots available for now",
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.lightText
                              : AppColors.darkText,
                        ),
                      ),
                    );
                  }

                  final slots = snapshot.data!;

                  return ListView.builder(
                    itemCount: slots.length,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final slot = slots[index];
                      final slotVenueAddress = slot.venue.address;
                      print(slot.bookings.length);

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PlaygroundDetailsScreen(
                                      playgroundId: slot.venueId,
                                      slotId: slot.id,
                                      onlyPlayground: false,
                                    ),
                                  ),
                                );
                              },
                              child: _buildSlotSection(
                                isDarkMode: isDarkMode,
                                venueImage: slot.venue.images[0],
                                venueName:
                                    "${slot.venue.name}, ${slotVenueAddress.street}",
                                venueLocation:
                                    "${slotVenueAddress.street}, ${slotVenueAddress.city}, ${slotVenueAddress.state}, ${slotVenueAddress.postalCode}, ${slotVenueAddress.country}",
                                gameDate:
                                    CommonFunctions.formatDateInDayDateMon(
                                        slot.startTime),
                                gameTime:
                                    CommonFunctions.formatTimeIn24HourMinAMPM(
                                        slot.startTime),
                                actualPrice: slot.price,
                                discountedPrice: slot.discountedPrice,
                                maxPlayer: slot.maxPlayer,
                                slotsLeft: slot.bookings.length,
                              ),
                            ),
                            SizedBox(height: 5.w),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotSection({
    required bool isDarkMode,
    required String venueImage,
    required String venueName,
    required String venueLocation,
    double venueRating = 3.78,
    int venueRaters = 96,
    required String gameDate,
    required String gameTime,
    required double actualPrice,
    required double discountedPrice,
    required int maxPlayer,
    required int slotsLeft,
  }) {
    return Container(
      height: 400,
      width: 100.w,
      padding: EdgeInsets.all(1.5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.w),
        color: isDarkMode
            ? AppColors.darkestBackgroundV2
            : AppColors.lightBackground,
        boxShadow: [
          isDarkMode
              ? BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: Offset(
                    0,
                    4,
                  ),
                )
              : BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  blurRadius: 7,
                  spreadRadius: -3,
                  offset: Offset(
                    0,
                    3,
                  ),
                ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            width: 100.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.w),
              image: DecorationImage(
                image: NetworkImage(
                  venueImage,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.w),
                // Name and Price Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                gameDate,
                                style: AppTextStyles.body.copyWith(
                                  color: isDarkMode
                                      ? AppColors.lightText
                                      : AppColors.darkText,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Container(
                                height: 20,
                                width: 1.5,
                                color: AppColors.lightGreyColor,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                gameTime,
                                style: AppTextStyles.body.copyWith(
                                  color: isDarkMode
                                      ? AppColors.lightText
                                      : AppColors.darkText,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            child: Text(
                              venueName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body.copyWith(
                                color: isDarkMode
                                    ? AppColors.lightText
                                    : AppColors.mediumGreyColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${CommonAppText.rupeeIcon} ${discountedPrice.toString()}",
                            style: AppTextStyles.body.copyWith(
                              color: isDarkMode
                                  ? AppColors.lightText
                                  : AppColors.darkText,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          Text(
                            "${CommonAppText.rupeeIcon} ${actualPrice.toString()}",
                            style: AppTextStyles.body.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: isDarkMode
                                  ? AppColors.lightText
                                  : AppColors.darkText,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                // Text(
                //   venueLocation,
                //   maxLines: 2,
                //   overflow: TextOverflow.ellipsis,
                //   style: AppTextStyles.body.copyWith(
                //     color: isDarkMode
                //         ? AppColors.lightText
                //         : AppColors.mediumGreyColor,
                //   ),
                // ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    _buildChips(
                      isDarkMode,
                      Paths.homeFootballPlayerIcon,
                      "$maxPlayer Max Player",
                    ),
                    SizedBox(width: 2.5.w),
                    _buildChips(
                      isDarkMode,
                      Paths.homeFootballPlayerIcon,
                      "${calculateSlotsLeft(maxPlayer, slotsLeft)} Slots left",
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  int calculateSlotsLeft(int maxPlayer, int bookings) {
    if (bookings >= maxPlayer) {
      return 0;
    } else if (bookings < (maxPlayer / 2)) {
      return (maxPlayer / 2).ceil();
    } else {
      return maxPlayer - bookings;
    }
  }


  Widget _buildChips(bool isDarkMode, String icon, String action) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 2.w),
      // width: 100.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.w),
        color: isDarkMode ? AppColors.darkGreyColor : AppColors.darkGreenColor,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              height: 15,
              width: 15,
            ),
            SizedBox(width: 2.5.w),
            Text(
              action,
              style: AppTextStyles.body.copyWith(
                color: AppColors.lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
