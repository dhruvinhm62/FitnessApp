import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../../home/presentation/controllers/exercise_tab_controller.dart';

class ExerciseNote {
  final String title;
  final String description;
  final DateTime date;

  ExerciseNote({
    required this.title,
    required this.description,
    required this.date,
  });
}

class ExerciseDetailsController extends GetxController {
  late final Exercise exercise;

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  final isVideoInitialized = false.obs;

  final isSettingUpExpanded = true.obs;
  final isTechniqueExpanded = true.obs;

  final notes = <ExerciseNote>[].obs;

  void toggleSettingUp() => isSettingUpExpanded.value = !isSettingUpExpanded.value;
  void toggleTechnique() => isTechniqueExpanded.value = !isTechniqueExpanded.value;

  void addNote(String title, String description) {
    notes.add(ExerciseNote(title: title, description: description, date: DateTime.now()));
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Exercise) {
      exercise = Get.arguments as Exercise;
    } else {
      exercise = Exercise(
        id: '0',
        name: 'Hanging Straight Leg Raise',
        imageUrl: 'https://via.placeholder.com/150',
      );
    }
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    // Dummy video URL for demo (using official flutter test video to avoid 403s)
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
    );
    await videoPlayerController!.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      aspectRatio: 3 / 4,
      autoPlay: false,
      looping: false,
      showControls: false,
    );
    isVideoInitialized.value = true;
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.onClose();
  }
}
