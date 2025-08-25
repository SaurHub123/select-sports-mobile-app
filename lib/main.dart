import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/core/network/shared_preferences_helper.dart';
import 'package:select_sports/features/about_us/presentation/about_us_screen.dart';
import 'package:select_sports/features/auth/presentation/forgot_page.dart';
import 'package:select_sports/features/auth/presentation/login_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:select_sports/features/auth/presentation/signup_page.dart';
import 'package:select_sports/features/auth/presentation/verifyOTP_page.dart';
import 'package:select_sports/features/available_slots/presentation/available_slots_screen.dart';
import 'package:select_sports/features/bookings/presentation/bookings_screen.dart';
import 'package:select_sports/features/main/presentation/main_screen.dart';
import 'package:select_sports/features/manage_teams/presentation/manage_teams_screen.dart';
import 'package:select_sports/features/need_help/presentation/need_help_screen.dart';
import 'package:select_sports/features/out_hosts/presentation/our_hosts_screen.dart';
import 'package:select_sports/features/profile/presentation/edit_profile_screen.dart';
import 'package:select_sports/features/profile/presentation/profile_screen.dart';
import 'package:select_sports/features/settings/presentation/reset_page.dart';
import 'package:select_sports/features/rewards/presentation/rewards_screen.dart';
import 'package:select_sports/features/settings/presentation/delete_account/delete_account_screen.dart';
import 'package:select_sports/features/settings/presentation/notification_preferences_screen.dart';
import 'package:select_sports/features/settings/presentation/settings_screen.dart';
import 'package:select_sports/features/settings/presentation/update_mobile_screen.dart';
import 'package:select_sports/features/splash/presentation/splash_screen.dart';
import 'package:select_sports/features/terms_and_conditions/presentation/terms_and_conditions_screen.dart';
import 'package:select_sports/features/upcoming_bookings/presentation/upcoming_bookings_screen.dart';
import 'package:select_sports/features/wallet/presentation/add_money_screen.dart';
import 'package:select_sports/features/wallet/presentation/wallet_screen.dart';
import 'package:select_sports/providers/navigator_key.dart';
import 'package:select_sports/providers/theme_provider.dart';
import 'package:select_sports/providers/responsive_provider.dart';
import 'package:toastification/toastification.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  await SharedPreferencesHelper.init();

  final platformBrightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  runApp(
    ProviderScope(
      overrides: [
        themeProvider.overrideWith((ref) => ThemeNotifier(platformBrightness)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final navigatorKey = ref.read(navigatorKeyProvider);

    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return ResponsiveWrapper(
        child: ToastificationWrapper(
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Select Sports',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            primaryColor: AppColors.lightGreenColor,
            primaryColorDark: AppColors.darkGreenColor,
            splashColor: Colors.transparent,
            scaffoldBackgroundColor: AppColors.lightBackground,
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            bottomSheetTheme: BottomSheetThemeData(
              dragHandleColor: Colors.pink,
            ),
            colorScheme: ColorScheme.light(
              primary: AppColors.lightGreenColor,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: AppColors.darkGreenColor,
            scaffoldBackgroundColor: AppColors.darkScaffoldBackground,
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            bottomSheetTheme: BottomSheetThemeData(
              dragHandleColor: Colors.pink,
            ),
            colorScheme: ColorScheme.dark(
              primary: AppColors.darkGreenColor,
              surface: AppColors.darkScaffoldBackground,
              onSurface: Colors.white,
            ),
          ),
          themeMode: themeMode,
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/login': (context) => LoginScreen(),
            '/signup': (context) => SignupScreen(),
            '/main': (context) => MainScreen(),
            '/join_a_game': (context) => AvailableSlotsScreen(),
            '/forgot': (context) => ForgotScreen(),
            '/verifyOTP': (context) => VerifyOTPScreen(),
            '/reset': (context) => ResetScreen(),
            '/profile': (context) => ProfileScreen(),
            '/wallet': (context) => WalletScreen(),
            '/upcoming_bookings': (context) => UpcomingBookingsScreen(),
            '/bookings': (context) => BookingsScreen(),
            '/addMoney': (context) => AddMoneyScreen(),
            '/need_help': (context) => NeedHelpScreen(),
            '/our_hosts': (context) => OurHostsScreen(),
            '/settings': (context) => SettingsScreen(),
            '/manage_teams': (context) => ManageTeamsScreen(),
            '/about_us': (context) => AboutUsScreen(),
            '/terms_and_conditions': (context) => TermsAndConditionsScreen(),
            '/notification_preferences': (context) =>
                NotificationPreferencesScreen(),
            '/delete_account': (context) => DeleteAccountScreen(),
            '/update_mobile': (context) => UpdateMobileScreen(),
            '/rewards': (context) => RewardsScreen(),
            '/update_profile': (context) => UpdateProfileScreen(),
          },
        ),
      ),
    );
    });
  }
}
