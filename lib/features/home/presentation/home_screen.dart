import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:select_sports/core/constants/paths.dart';
import 'package:select_sports/core/constants/shared_preferences_keys.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/core/models/venue_model.dart';
import 'package:select_sports/core/network/shared_preferences_helper.dart';
import 'package:select_sports/core/widgets/visibility_widgets.dart';
import 'package:select_sports/core/widgets/frosted_glass.dart';
import 'package:select_sports/features/home/presentation/home_controller.dart';
import 'package:select_sports/features/home/presentation/playground_details_screen.dart';
import 'package:select_sports/providers/theme_provider.dart';
import 'package:select_sports/providers/responsive_provider.dart';
import '../../main/presentation/main_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<List<Venue>> _venuesFuture;

  @override
  void initState() {
    super.initState();
    final homeController = ref.read(homeControllerProvider.notifier);
    _venuesFuture = homeController.fetchVenues();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Landing Section
              _buildLandingSection(isDarkMode),
              SizedBox(height: 5.w),
              // Actions Section
              _buildActionsSection(ref, context),
              SizedBox(height: 10.w),
              // Our Playgrounds Section
              _buildPlaygroundsSection(isDarkMode),
              SizedBox(height: 10.w),
              // Box So that the data behind the bottom bar must be visible..
              VisibilityWidgets.bottomNavBarVisibleWidget(height: 150),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaygroundsSection(
    bool isDarkMode,
  ) {
    return Container(
      padding: EdgeInsets.only(left: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Our Playgrounds",
            textAlign: TextAlign.start,
            style: AppTextStyles.subheading.copyWith(
              color: isDarkMode ? AppColors.lightText : AppColors.darkText,
            ),
          ),
          SizedBox(height: ref.watch(isTabletProvider) ? 1.w : 2.5.w),
          SizedBox(
            height: 35.h,
            width: 100.w,
            child: FutureBuilder<List<Venue>>(
                future: _venuesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error fetching venues"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No venues available",
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.lightGreyColor,
                        ),
                      ),
                    );
                  }

                  final venues = snapshot.data!;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: venues.length,
                    itemBuilder: (context, index) {
                      final venue = venues[index];
                      final venueAddress = venue.address;

                      return Row(
                        children: [
                          SizedBox(width: index == 0 ? 2.5.w : 0),
                          Hero(
                            tag: "Hero${venue.id}",
                            // flightShuttleBuilder: (flightContext, animation,
                            //     direction, fromContext, toContext) {
                            //   return Center(child: CircularProgressIndicator());
                            // },
                            transitionOnUserGestures: true,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PlaygroundDetailsScreen(
                                      playgroundId: venue.id,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height:
                                    ref.watch(isTabletProvider) ? 32.h : 300,
                                width:
                                    ref.watch(isTabletProvider) ? 32.h : 75.w,
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? AppColors.darkScaffoldBackground
                                      : Color(0xFFF9F9F9),
                                  borderRadius: BorderRadius.circular(2.5.w),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isDarkMode
                                          ? AppColors.lightGreenColor
                                              .withValues(alpha: 0.15)
                                          : AppColors.darkText
                                              .withValues(alpha: 0.15),
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: ref.watch(isTabletProvider) ? 17.5.h : 200,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(2.5.w),
                                          topRight: Radius.circular(2.5.w),
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            Paths.homeHudlePlaygroundImage,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: 100.w,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 3.5.w,
                                          vertical: 2.5.w,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            // Container(
                                            //   padding: EdgeInsets.symmetric(
                                            //       horizontal: 3.5.w, vertical: 2.5.w),
                                            //   decoration: BoxDecoration(
                                            //     color: AppColors.darkGreenColor,
                                            //     borderRadius: BorderRadius.circular(100.w),
                                            //   ),
                                            //   child: Row(
                                            //     mainAxisSize: MainAxisSize.min,
                                            //     children: [
                                            //       Icon(
                                            //         Icons.sports_football,
                                            //         color: AppColors.lightText,
                                            //         size: 15.sp,
                                            //       ),
                                            //       SizedBox(width: 2.5.w),
                                            //       Text(
                                            //         "Football",
                                            //         style: AppTextStyles.body.copyWith(
                                            //           fontSize: 12.sp,
                                            //           fontWeight: FontWeight.bold,
                                            //           color: Colors.white,
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                            SizedBox(height: ref.watch(isTabletProvider) ? 1.w : 2.5.w),
                                            Text(
                                              venue.name,
                                              textAlign: TextAlign.start,
                                              style:
                                                  AppTextStyles.body.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.sp,
                                                color: isDarkMode
                                                    ? AppColors.lightText
                                                    : Color(0xFF020202),
                                              ),
                                            ),
                                            SizedBox(height: ref.watch(isTabletProvider) ? 1.w : 2.5.w),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.pin_drop_sharp,
                                                  size: 15.sp,
                                                  color: isDarkMode
                                                      ? AppColors.lightText
                                                      : AppColors
                                                          .mediumGreyColor,
                                                ),
                                                SizedBox(width: ref.watch(isTabletProvider) ? 1.5.w : 2.5.w),
                                                Expanded(
                                                  child: Text(
                                                    "${venueAddress.street}, ${venueAddress.city}, ${venueAddress.state}, ${venueAddress.postalCode}, ${venueAddress.country}",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.start,
                                                    style: AppTextStyles.body
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13.sp,
                                                      color: isDarkMode
                                                          ? AppColors.lightText
                                                          : AppColors
                                                              .mediumGreyColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5.w),
                        ],
                      );
                    },
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget _buildLandingSection(bool isDarkMode) {
    return Container(
      height: 60.h,
      width: 100.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5.w),
          bottomRight: Radius.circular(5.w),
        ),
      ),
      child: Stack(
        children: [
          Container(
            height: 60.h,
            width: 100.w,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Paths.homePlaygroundImage,
                ),
                opacity: isDarkMode ? 0.4 : 1,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5.w),
                bottomRight: Radius.circular(5.w),
              ),
            ),
          ),
          Container(
            height: 60.h,
            width: 100.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.darkGreenColor.withValues(alpha: 0.4),
                  AppColors.darkGreenColor.withValues(alpha: 0.2),
                  Colors.transparent,
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5.w),
                bottomRight: Radius.circular(5.w),
              ),
            ),
          ),
          Positioned(
            bottom: 0.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 5.h,
                            width: 5.h,
                            padding: EdgeInsets.all(7.5),
                            decoration: BoxDecoration(
                              color: AppColors.darkGreenColor,
                              borderRadius: BorderRadius.circular(2.5.w),
                            ),
                            child: SvgPicture.asset(
                              Paths.homeFootballPlayerIcon,
                              height: 2.5.h,
                              width: 2.5.h,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          // Text(
                          //   'Playing techniques',
                          //   style: AppTextStyles.subheading.copyWith(
                          //     color: AppColors.lightText,
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'Hello,',
                        style: AppTextStyles.largeHeading.copyWith(
                          color: AppColors.lightText,
                        ),
                      ),
                      Text(
                        SharedPreferencesHelper.get(
                                SharedPreferencesKeys.name) ??
                            "---",
                        style: AppTextStyles.largeHeading.copyWith(
                          color: AppColors.lightText,
                        ),
                      ),
                      SizedBox(height: 2.5.w),
                      Text(
                        'Welcome to your Playground.!',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.lightText,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.h),
                FrostedGlassBox(
                  width: 100.w,
                  height: 70,
                  clipRectBorder: BorderRadius.only(
                    bottomLeft: Radius.circular(5.w),
                    bottomRight: Radius.circular(5.w),
                  ),
                  containerBorder: BorderRadius.only(
                    bottomLeft: Radius.circular(5.w),
                    bottomRight: Radius.circular(5.w),
                  ),
                  child: Row(
                    children: [],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(WidgetRef ref, BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 5.w),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/join_a_game');
            },
            child: Container(
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                color: AppColors.darkGreenColor,
                borderRadius: BorderRadius.circular(2.5.w),
              ),
              child: Column(
                children: [
                  Container(
                    height: 12.h,
                    width: 100.w,
                    padding: EdgeInsets.symmetric(
                        horizontal: 7.5.w, vertical: 2.5.w),
                    child: SvgPicture.asset(
                      Paths.homeJoinGameImage,
                      color: AppColors.lightText,
                      height: 5.h,
                      width: 5.h,
                    ),
                  ),
                  Text(
                    "Join a Game",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.lightText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: GestureDetector(
            onTap: () {
              ref.read(mainControllerProvider.notifier).updateIndex(0);
            },
            child: Container(
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                color: AppColors.darkGreenColor,
                borderRadius: BorderRadius.circular(2.5.w),
              ),
              child: Column(
                children: [
                  Container(
                    height: 12.h,
                    width: 100.w,
                    padding: EdgeInsets.symmetric(
                        horizontal: 7.5.w, vertical: 2.5.w),
                    child: SvgPicture.asset(
                      Paths.homeBecomeMemberImage,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Become a Member",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.lightText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 5.w),
      ],
    );
  }
}
