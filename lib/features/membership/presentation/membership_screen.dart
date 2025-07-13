import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:select_sports/core/widgets/visibility_widgets.dart';
import 'package:select_sports/features/membership/presentation/membership_controller.dart';
import 'package:select_sports/features/membership/presentation/membership_form_screen.dart';
import 'package:select_sports/features/membership/presentation/no_data_screen.dart';
import 'package:select_sports/features/membership/presentation/pending_application_screen.dart';

class MembershipScreen extends ConsumerWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membershipState = ref.watch(membershipControllerProvider);

    // Show loading indicator while checking host status
    if (membershipState.isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Logic based on host status and application status
    if (!membershipState.isHost) {
      // User is not a host - show form to apply
      return MembershipFormScreen();
    } else {
      // User is a host - check their application status
      final hostStatus = membershipState.hostStatus;
      
      if (hostStatus == "APPROVED") {
        // Application approved - show no data screen
        return NoDataScreen();
      } else {
        // Application pending or other status - show pending screen
        return PendingApplicationScreen();
      }
    }
  }
}
