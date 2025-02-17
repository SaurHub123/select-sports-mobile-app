import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:select_sports/core/models/venue_model.dart';
import 'package:select_sports/features/home/data/home_repository.dart';

// A StateNotifier to manage currentImage and previousImage states
class HomeController extends StateNotifier<HomeControllerState> {
  final HomeRepository homeRepository;

  HomeController(this.homeRepository) : super(HomeControllerState());

  void updateCurrentImage(int index) {
    state = HomeControllerState(
      currentImage: index,
      previousImage: state.currentImage,
    );
  }

  Future<List<Venue>> fetchVenues() async {
    return await homeRepository.getVenues();
  }

  Future<Venue?> fetchVenueDetail(String id) async {
    return await homeRepository.getVenueDetail(id);
  }

  // Getter to determine if swipe direction is to the right
  bool get isSwipeRight => state.currentImage > state.previousImage;
}

// State class to encapsulate current and previous image indices
class HomeControllerState {
  final int currentImage;
  final int previousImage;

  HomeControllerState({
    this.currentImage = 0,
    this.previousImage = 0,
  });
}

final homeControllerProvider =
    StateNotifierProvider<HomeController, HomeControllerState>((ref) {
  final homeRepository = ref.read(homeRepositoryProvider);
  return HomeController(homeRepository);
});
