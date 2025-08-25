import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Device type enum
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

// Orientation enum
enum DeviceOrientation {
  portrait,
  landscape,
}

// Responsive data class
class ResponsiveData {
  final DeviceType deviceType;
  final DeviceOrientation orientation;
  final double screenWidth;
  final double screenHeight;
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final bool isPortrait;
  final bool isLandscape;

  ResponsiveData({
    required this.deviceType,
    required this.orientation,
    required this.screenWidth,
    required this.screenHeight,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    required this.isPortrait,
    required this.isLandscape,
  });

  // Convenience combination getters for device + orientation
  bool get isMobilePortrait => isMobile && isPortrait;
  bool get isMobileLandscape => isMobile && isLandscape;
  bool get isTabletPortrait => isTablet && isPortrait;
  bool get isTabletLandscape => isTablet && isLandscape;
  bool get isDesktopPortrait => isDesktop && isPortrait;
  bool get isDesktopLandscape => isDesktop && isLandscape;

  ResponsiveData copyWith({
    DeviceType? deviceType,
    DeviceOrientation? orientation,
    double? screenWidth,
    double? screenHeight,
    bool? isMobile,
    bool? isTablet,
    bool? isDesktop,
    bool? isPortrait,
    bool? isLandscape,
  }) {
    return ResponsiveData(
      deviceType: deviceType ?? this.deviceType,
      orientation: orientation ?? this.orientation,
      screenWidth: screenWidth ?? this.screenWidth,
      screenHeight: screenHeight ?? this.screenHeight,
      isMobile: isMobile ?? this.isMobile,
      isTablet: isTablet ?? this.isTablet,
      isDesktop: isDesktop ?? this.isDesktop,
      isPortrait: isPortrait ?? this.isPortrait,
      isLandscape: isLandscape ?? this.isLandscape,
    );
  }
}

// Responsive notifier class
class ResponsiveNotifier extends StateNotifier<ResponsiveData> {
  ResponsiveNotifier() : super(ResponsiveData(
    deviceType: DeviceType.mobile,
    orientation: DeviceOrientation.portrait,
    screenWidth: 0,
    screenHeight: 0,
    isMobile: true,
    isTablet: false,
    isDesktop: false,
    isPortrait: true,
    isLandscape: false,
  ));

  // Update responsive data based on MediaQuery
  void updateResponsiveData(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final orientation = mediaQuery.orientation;

    // Determine device type based on width
    DeviceType deviceType;
    bool isMobile, isTablet, isDesktop;

    if (size.width < 768) {
      deviceType = DeviceType.mobile;
      isMobile = true;
      isTablet = false;
      isDesktop = false;
    } else if (size.width < 1025) {
      deviceType = DeviceType.tablet;
      isMobile = false;
      isTablet = true;
      isDesktop = false;
    } else {
      deviceType = DeviceType.desktop;
      isMobile = false;
      isTablet = false;
      isDesktop = true;
    }

    // Determine orientation
    DeviceOrientation deviceOrientation;
    bool isPortrait, isLandscape;

    if (orientation == Orientation.portrait) {
      deviceOrientation = DeviceOrientation.portrait;
      isPortrait = true;
      isLandscape = false;
    } else {
      deviceOrientation = DeviceOrientation.landscape;
      isPortrait = false;
      isLandscape = true;
    }

    state = ResponsiveData(
      deviceType: deviceType,
      orientation: deviceOrientation,
      screenWidth: size.width,
      screenHeight: size.height,
      isMobile: isMobile,
      isTablet: isTablet,
      isDesktop: isDesktop,
      isPortrait: isPortrait,
      isLandscape: isLandscape,
    );
  }

  // Helper methods for common responsive checks
  bool get isMobilePortrait => state.isMobile && state.isPortrait;
  bool get isMobileLandscape => state.isMobile && state.isLandscape;
  bool get isTabletPortrait => state.isTablet && state.isPortrait;
  bool get isTabletLandscape => state.isTablet && state.isLandscape;
  bool get isDesktopPortrait => state.isDesktop && state.isPortrait;
  bool get isDesktopLandscape => state.isDesktop && state.isLandscape;

  // Get responsive layout type
  String get layoutType {
    if (state.isMobile) {
      return state.isPortrait ? 'mobile_portrait' : 'mobile_landscape';
    } else if (state.isTablet) {
      return state.isPortrait ? 'tablet_portrait' : 'tablet_landscape';
    } else {
      return state.isPortrait ? 'desktop_portrait' : 'desktop_landscape';
    }
  }
}

// Provider
final responsiveProvider = StateNotifierProvider<ResponsiveNotifier, ResponsiveData>((ref) {
  return ResponsiveNotifier();
});

// Convenience providers
final deviceTypeProvider = Provider<DeviceType>((ref) {
  return ref.watch(responsiveProvider).deviceType;
});

final orientationProvider = Provider<DeviceOrientation>((ref) {
  return ref.watch(responsiveProvider).orientation;
});

final isMobileProvider = Provider<bool>((ref) {
  return ref.watch(responsiveProvider).isMobile;
});

final isTabletProvider = Provider<bool>((ref) {
  return ref.watch(responsiveProvider).isTablet;
});

final isDesktopProvider = Provider<bool>((ref) {
  return ref.watch(responsiveProvider).isDesktop;
});

final isPortraitProvider = Provider<bool>((ref) {
  return ref.watch(responsiveProvider).isPortrait;
});

final isLandscapeProvider = Provider<bool>((ref) {
  return ref.watch(responsiveProvider).isLandscape;
});

final layoutTypeProvider = Provider<String>((ref) {
  return ref.read(responsiveProvider.notifier).layoutType;
});

// Responsive widget that automatically updates the provider
class ResponsiveWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const ResponsiveWrapper({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<ResponsiveWrapper> createState() => _ResponsiveWrapperState();
}

class _ResponsiveWrapperState extends ConsumerState<ResponsiveWrapper> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Update responsive data when screen metrics change (orientation, size, etc.)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(responsiveProvider.notifier).updateResponsiveData(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Update responsive data on build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(responsiveProvider.notifier).updateResponsiveData(context);
    });

    return widget.child;
  }
}

// Responsive builder widget for easy usage
class ResponsiveBuilder extends ConsumerWidget {
  final Widget Function(BuildContext context, ResponsiveData responsive) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = ref.watch(responsiveProvider);
    return builder(context, responsive);
  }
}

// Conditional responsive widget
class ResponsiveConditional extends ConsumerWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? mobilePortrait;
  final Widget? mobileLandscape;
  final Widget? tabletPortrait;
  final Widget? tabletLandscape;
  final Widget? desktopPortrait;
  final Widget? desktopLandscape;

  const ResponsiveConditional({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.mobilePortrait,
    this.mobileLandscape,
    this.tabletPortrait,
    this.tabletLandscape,
    this.desktopPortrait,
    this.desktopLandscape,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = ref.watch(responsiveProvider);

    // Check for specific device + orientation combinations first
    if (responsive.isMobilePortrait && mobilePortrait != null) {
      return mobilePortrait!;
    }
    if (responsive.isMobileLandscape && mobileLandscape != null) {
      return mobileLandscape!;
    }
    if (responsive.isTabletPortrait && tabletPortrait != null) {
      return tabletPortrait!;
    }
    if (responsive.isTabletLandscape && tabletLandscape != null) {
      return tabletLandscape!;
    }
    if (responsive.isDesktopPortrait && desktopPortrait != null) {
      return desktopPortrait!;
    }
    if (responsive.isDesktopLandscape && desktopLandscape != null) {
      return desktopLandscape!;
    }

    // Fall back to device type only
    if (responsive.isMobile) {
      return mobile;
    } else if (responsive.isTablet && tablet != null) {
      return tablet!;
    } else if (responsive.isDesktop && desktop != null) {
      return desktop!;
    }

    // Default fallback
    return mobile;
  }
}
