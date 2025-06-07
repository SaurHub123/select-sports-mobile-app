import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:select_sports/core/constants/shared_preferences_keys.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/core/models/address_model.dart';
import 'package:select_sports/core/models/slot_model.dart';
import 'package:select_sports/core/models/venue_model.dart';
import 'package:select_sports/core/network/shared_preferences_helper.dart';
import 'package:select_sports/core/widgets/common_bottom_sheet.dart';
import 'package:select_sports/core/widgets/custom_buttons.dart';
import 'package:select_sports/core/widgets/custom_snackbar.dart';
import 'package:select_sports/features/home/presentation/components/payment_bottom_sheet.dart';
import 'package:select_sports/providers/theme_provider.dart';
import 'package:select_sports/utils/common_functions.dart';
import 'home_controller.dart';

class PlaygroundDetailsScreen extends ConsumerStatefulWidget {
  final String playgroundId;
  final String? slotId;
  final bool onlyPlayground;

  const PlaygroundDetailsScreen({
    super.key,
    required this.playgroundId,
    this.slotId,
    this.onlyPlayground = true,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlaygroundDetailsScreenState();
}

class _PlaygroundDetailsScreenState
    extends ConsumerState<PlaygroundDetailsScreen> {
  late Future<Venue?> _venueFuture;

  @override
  void initState() {
    super.initState();
    final homeController = ref.read(homeControllerProvider.notifier);
    _venueFuture = homeController.fetchVenueDetail(widget.playgroundId);

    if (widget.slotId != null) {
      homeController.fetchSlotDetail(widget.slotId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
    final homeState = ref.watch(homeControllerProvider);
    final homeController = ref.read(homeControllerProvider.notifier);

    return Scaffold(
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: FutureBuilder<Venue?>(
          future: _venueFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error fetching venue"));
            } else if (!snapshot.hasData || snapshot.data == null) {
              // Show toast message and navigate back
              WidgetsBinding.instance.addPostFrameCallback((_) {
                CustomSnackBar.showError("Playground doesn't exist!");
                Navigator.pop(context);
              });

              return SizedBox();
            }

            final Venue playgroundData = snapshot.data!;
            final List<String> playgroundImages = playgroundData.images;
            final List<String> venueAmenities = playgroundData.amenities;
            final bool isSlotBookedByMe = homeState.slotDetail != null &&
                homeState.slotDetail!.bookings.any(
                  (booking) =>
                      booking.userId ==
                          SharedPreferencesHelper.get(
                              SharedPreferencesKeys.userId) &&
                      booking.status == "CONFIRMED",
                );
            // print('Home State Slot');
            // print(homeState.slotDetail?.id);
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Hero(
                              tag: "Hero${widget.playgroundId}",
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                // transitionBuilder: (child, animation) {
                                //   final offsetAnimation = Tween<Offset>(
                                //     begin: homeController.isSwipeRight
                                //         ? const Offset(1, 0)
                                //         : const Offset(-1, 0),
                                //     end: Offset.zero,
                                //   ).animate(animation);
                                //   return SlideTransition(
                                //     position: offsetAnimation,
                                //     child: child,
                                //   );
                                // },
                                transitionBuilder: (child, animation) {
                                  final offsetAnimation = Tween<Offset>(
                                    begin: homeController.isSwipeRight
                                        ? const Offset(1, 0)
                                        : const Offset(-1, 0),
                                    end: Offset.zero,
                                  ).animate(animation);
                                  return Stack(
                                    children: [
                                      // Keeps the previous image visible during the animation
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(2.5.w),
                                              topRight: Radius.circular(2.5.w),
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                playgroundImages[
                                                    homeState.previousImage],
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // The new image with sliding animation
                                      SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      ),
                                    ],
                                  );
                                },
                                child: Container(
                                  key: ValueKey<int>(homeState.currentImage),
                                  height: 40.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(2.5.w),
                                      topRight: Radius.circular(2.5.w),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        playgroundImages[
                                            homeState.currentImage],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 7.5.h,
                              left: 5.w,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.5.w,
                                    vertical: 2.5.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGreenColor,
                                    borderRadius: BorderRadius.circular(2.5.w),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: AppColors.darkText,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.5.w),
                        _buildImageScroller(isDarkMode, playgroundImages,
                            homeController, homeState),
                        SizedBox(height: 2.5.w),
                        _buildMainSection(isDarkMode, playgroundData),
                        SizedBox(height: 5.w),
                        _buildDescriptionSection(
                            isDarkMode, playgroundData.description),
                        SizedBox(height: 5.w),
                        _buildAmenitiesSection(isDarkMode, venueAmenities)
                      ],
                    ),
                  ),
                ),
                if (!widget.onlyPlayground)
                  Container(
                    width: 100.w,
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: CustomButtons.fullWidthFilledButton(
                      buttonText:
                          isSlotBookedByMe ? "Already Booked" : "Book Now",
                      ref: ref,
                      onClick: () {
                        // If User already booked this slot then it must not perform any action
                        if (!isSlotBookedByMe) {
                          paymentBottomSheet(context, isDarkMode,
                              homeController, homeState.slotDetail!.id);
                        }
                      },
                      customDarkColor: AppColors.darkGreenColor,
                    ),
                  ),
                if (isSlotBookedByMe)
                  Container(
                    width: 100.w,
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: CustomButtons.fullWidthFilledButton(
                      buttonText: "Cancel Booking",
                      ref: ref,
                      onClick: () async {
                        homeController.fetchSlotDetail(widget.slotId!);
                        Booking userBooking = homeState.slotDetail!.bookings
                            .firstWhere((e) =>
                                e.userId ==
                                    SharedPreferencesHelper.get(
                                        SharedPreferencesKeys.userId) &&
                                e.status == "CONFIRMED");

                        print(userBooking.status);
                        if (userBooking.status == "CANCELLED") {
                          return CustomSnackBar.showError(
                              "Your Booking is Already Cancelled..!");
                        }

                        int response =
                            await homeController.cancelBooking(userBooking.id);
                        if (response == 1) {
                          CustomSnackBar.showSuccess(
                            "Booking is Cancelled Successfully..!",
                          );
                        } else {
                          CustomSnackBar.showSuccess(
                            "Booking Cancellation failed. Please try again..!",
                          );
                        }
                      },
                      customDarkColor: AppColors.redColor,
                      customLightColor: AppColors.redColor,
                    ),
                  ),
                SizedBox(height: 25),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(bool isDarkMode, String description) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonAppText.detailHeading("Description", isDarkMode),
          SizedBox(height: 2.5.w),
          Text(
            description,
            textAlign: TextAlign.justify,
            style: AppTextStyles.body.copyWith(
              color: isDarkMode
                  ? AppColors.lightGreyColor
                  : AppColors.darkGreyColor,
              fontSize: 14.5.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageScroller(
    bool isDarkMode,
    List<String> playgroundImages,
    HomeController homeController,
    HomeControllerState homeState,
  ) {
    return Container(
      height: 75,
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: playgroundImages.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              homeController.updateCurrentImage(index);
            },
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
            child: Container(
              margin: EdgeInsets.only(right: 2.5.w),
              width: 20.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5.w),
                image: DecorationImage(
                  image: NetworkImage(playgroundImages[index]),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: isDarkMode ? AppColors.lightText : AppColors.darkText,
                ),
              ),
              child: index == homeState.currentImage
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.5.w),
                        color: AppColors.darkText.withValues(alpha: 0.5),
                      ),
                    )
                  : SizedBox(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainSection(bool isDarkMode, Venue playgroundData) {
    final Address playgroundAddress = playgroundData.address;
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 3.w),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.darkGreenColor
              : AppColors.lightestGreyColorV2,
          borderRadius: BorderRadius.circular(2.5.w),
        ),
        padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_city_rounded,
                  color: isDarkMode ? AppColors.lightText : AppColors.darkText,
                  size: 18.sp,
                ),
                SizedBox(width: 1.5.w),
                Expanded(
                  child: Text(
                    playgroundData.name,
                    // "Sports Hub Gurugram | Sector-48",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.subheading.copyWith(
                      color:
                          isDarkMode ? AppColors.lightText : AppColors.darkText,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.location_pin,
                  color: isDarkMode
                      ? AppColors.lightGreyColor
                      : AppColors.mediumGreyColor,
                  size: 17.sp,
                ),
                SizedBox(width: 1.5.w),
                Expanded(
                  child: Text(
                    "${playgroundAddress.street}, ${playgroundAddress.city}, ${CommonFunctions.capitalizeFirst(playgroundAddress.state)}, ${playgroundAddress.postalCode}, ${playgroundAddress.country}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.subheading.copyWith(
                      color: isDarkMode
                          ? AppColors.lightGreyColor
                          : AppColors.mediumGreyColor,
                      fontSize: 14.5.sp,
                    ),
                  ),
                ),
              ],
            ),
            if (playgroundAddress.nearBy != null)
              Row(
                children: [
                  Icon(
                    Icons.near_me_outlined,
                    color: isDarkMode
                        ? AppColors.lightGreyColor
                        : AppColors.mediumGreyColor,
                    size: 17.sp,
                  ),
                  SizedBox(width: 1.5.w),
                  Text(
                    "Nearby: ",
                    maxLines: 2,
                    style: AppTextStyles.subheading.copyWith(
                      color: isDarkMode
                          ? AppColors.lightGreyColor
                          : AppColors.mediumGreyColor,
                      fontSize: 14.5.sp,
                    ),
                  ),
                  Text(
                    playgroundAddress.nearBy ?? "",
                    maxLines: 2,
                    style: AppTextStyles.subheading.copyWith(
                      color: isDarkMode
                          ? AppColors.lightGreyColor
                          : AppColors.darkText,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenitiesSection(bool isDarkMode, List<String> venueAmenities) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonAppText.detailHeading("Amenities", isDarkMode),
          SizedBox(height: 2.5.w),
          SizedBox(
            height: venueAmenities.length * 30, // Adjust Amenities height
            width: 100.w,
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 9 / 2,
              children: List.generate(
                venueAmenities.length,
                (index) {
                  return Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/venue/${venueAmenities[index].toLowerCase()}.svg",
                        height: 20,
                        width: 20,
                        color: isDarkMode
                            ? AppColors.lightText
                            : AppColors.darkText,
                      ),
                      SizedBox(width: 2.5.w),
                      Text(
                        CommonFunctions.capitalizeFirst(
                          venueAmenities[index]
                              .replaceAll("_", " ")
                              .toLowerCase(),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 14.sp,
                          color: isDarkMode
                              ? AppColors.lightText
                              : AppColors.darkText,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
