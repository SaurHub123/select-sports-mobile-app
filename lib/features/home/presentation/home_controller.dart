import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:select_sports/core/models/cancel_booking_model.dart';
import 'package:select_sports/core/models/slot_model.dart';
import 'package:select_sports/core/models/venue_model.dart';
import 'package:select_sports/features/home/data/home_repository.dart';
import 'package:select_sports/utils/app_logger.dart';

// A StateNotifier to manage currentImage and previousImage states
class HomeController extends StateNotifier<HomeControllerState> {
  final HomeRepository homeRepository;

  HomeController(this.homeRepository) : super(HomeControllerState());

  void updateCurrentImage(int index) {
    state = state.copyWith(
      currentImage: index,
      previousImage: state.currentImage,
    );
  }

  void updatePaymentMode(int index) {
    state = state.copyWith(selectedPaymentMode: index);
  }

  Future<List<Venue>> fetchVenues() async {
    return await homeRepository.getVenues();
  }

  Future<Venue?> fetchVenueDetail(String id) async {
    return await homeRepository.getVenueDetail(id);
  }

  Future initiatePayment(String slotId, bool useWallet) async {
    return await homeRepository.initiatePayment(slotId, useWallet);
  }

  Future verifyPayment(
    String slotId,
    String paymentId,
    String orderId,
    String signature,
    bool useWallet,
  ) async {
    var verifyDetail = await homeRepository.verifyPayment(
        slotId, paymentId, orderId, signature, useWallet);
    await fetchSlotDetail(slotId);
    return verifyDetail;
  }

  Future<int> cancelBooking(String id) async {
    try {
      state = state.copyWith(isCancelBookingProcessRunning: true);
      await homeRepository.cancelBooking(id);
      return 1;
    } catch (err, stack) {
      logger.e(
        "Home Controller Error [Cancel Booking]",
        error: err,
        stackTrace: stack,
      );
      return 0;
    } finally {
      state = state.copyWith(isCancelBookingProcessRunning: false);
    }
  }

  Future<void> fetchSlotDetail(String id) async {
    try {
      final slot = await homeRepository.getSlotDetail(id);
      state = state.copyWith(
        slotDetail: slot,
      );
    } catch (err, stack) {
      logger.e("Home Controller Error [Slot Detail]",
          error: err, stackTrace: stack);
    }
  }

  // Getter to determine if swipe direction is to the right
  bool get isSwipeRight => state.currentImage > state.previousImage;
}

// State class to encapsulate current and previous image indices
class HomeControllerState {
  final int currentImage;
  final int previousImage;
  final Slot? slotDetail;
  final int selectedPaymentMode;
  final bool isCancelBookingProcessRunning;

  HomeControllerState({
    this.currentImage = 0,
    this.previousImage = 0,
    this.selectedPaymentMode = 0,
    this.slotDetail,
    this.isCancelBookingProcessRunning = false,
  });

  // CopyWith method for immutability
  HomeControllerState copyWith({
    int? currentImage,
    int? previousImage,
    int? selectedPaymentMode,
    Slot? slotDetail,
    BookingCancellation? cancelbooking,
    bool? isCancelBookingProcessRunning,
  }) {
    return HomeControllerState(
      currentImage: currentImage ?? this.currentImage,
      previousImage: previousImage ?? this.previousImage,
      selectedPaymentMode: selectedPaymentMode ?? this.selectedPaymentMode,
      slotDetail: slotDetail,
      isCancelBookingProcessRunning: isCancelBookingProcessRunning ?? this.isCancelBookingProcessRunning,
    );
  }
}

final homeControllerProvider =
    StateNotifierProvider<HomeController, HomeControllerState>((ref) {
  final homeRepository = ref.read(homeRepositoryProvider);
  return HomeController(homeRepository);
});
