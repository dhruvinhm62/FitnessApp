import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/exercise_details_controller.dart';
import 'package:fitness_app/core/widgets/custom_back_button.dart';

class ExerciseDetailsView extends GetView<ExerciseDetailsController> {
  const ExerciseDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.black,
          elevation: 0,
          centerTitle: true,
          leading: CustomBackButton(color: AppColors.white),
          title: const Text(
            'EXERCISE DETAILS',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.white,
            labelColor: AppColors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Instructions'),
              Tab(text: 'Details'),
              Tab(text: 'Notes'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_InstructionsTab(), _DetailsTab(), _NotesTab()],
        ),
      ),
    );
  }
}

class _InstructionsTab extends GetView<ExerciseDetailsController> {
  const _InstructionsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Video Player
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Container(
              color: AppColors.black,
              child: Obx(() {
                if (controller.isVideoInitialized.value &&
                    controller.chewieController != null) {
                  return _CustomVideoPlayer(
                    chewieController: controller.chewieController!,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.white),
                  );
                }
              }),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                    border: const Border(
                      left: BorderSide(color: AppColors.black, width: 4),
                    ),
                  ),
                  child: Text(
                    controller.exercise.name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.black,
                      height: 1.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildExpandableSection(
                  title: 'Setting up',
                  isExpanded: controller.isSettingUpExpanded,
                  onToggle: controller.toggleSettingUp,
                  children: [
                    _buildNumberedText(
                      '1',
                      'While standing under a pull-up bar, reach up and grab it with a slightly wider than shoulder-width overhand grip.',
                    ),
                    _buildNumberedText(
                      '2',
                      'Take your feet off the floor and hang with your arms straight.',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildExpandableSection(
                  title: 'Exercise technique',
                  isExpanded: controller.isTechniqueExpanded,
                  onToggle: controller.toggleTechnique,
                  children: [
                    _buildNumberedText(
                      '1',
                      'Keeping your legs straight, engage your core and raise your legs up in front of you.',
                    ),
                    _buildNumberedText(
                      '2',
                      'Raise your legs until they form a 90-degree angle with your torso.',
                    ),
                    _buildNumberedText(
                      '3',
                      'Slowly lower your legs back to the starting position.',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required RxBool isExpanded,
    required VoidCallback onToggle,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(
                    () => Icon(
                      isExpanded.value
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: isExpanded.value
                  ? Column(
                      children: [
                        Divider(height: 1, color: Colors.grey[200]),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: children,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(width: double.infinity, height: 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedText(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.black,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsTab extends GetView<ExerciseDetailsController> {
  const _DetailsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
              border: const Border(
                left: BorderSide(color: AppColors.black, width: 4),
              ),
            ),
            child: Text(
              controller.exercise.name,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.black,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Target Muscles',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildMuscleCard('Abs', 'Primary')),
              const SizedBox(width: 16),
              Expanded(child: _buildMuscleCard('Obliques', 'Secondary')),
            ],
          ),

          const SizedBox(height: 24),
          const Text(
            'Support Equipment',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildEquipmentCard(Icons.fitness_center, 'Straight Pull-Up Bar'),
          const SizedBox(height: 12),
          _buildEquipmentCard(
            Icons.fitness_center_outlined,
            'Multi-Grip Pull-Up Bar',
          ),
          const SizedBox(height: 24),
          const Text(
            'Details',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            Icons.fitness_center,
            'Difficulty Level',
            'Intermediate',
            'Requires a basic level of core strength and stability.',
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.repeat,
            'Suggested Reps',
            '8 - 12',
            'Perform 8 to 12 repetitions per set for optimal hypertrophy.',
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.timer_outlined,
            'Suggested Rest',
            '60s',
            'Rest for 60 seconds between sets to allow muscle recovery.',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMuscleCard(String name, String type) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.accessibility_new, color: AppColors.black),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                type,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentCard(IconData icon, String name) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.black),
          const SizedBox(width: 16),
          Text(
            name,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(icon, color: Colors.grey[600], size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      value,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesTab extends GetView<ExerciseDetailsController> {
  const _NotesTab();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          if (controller.notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_document, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                    'No notes yet',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your\nfirst note for this exercise.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20).copyWith(bottom: 100),
            itemCount: controller.notes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final note = controller.notes[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      note.description,
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${note.date.day}/${note.date.month}/${note.date.year}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          );
        }),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            onPressed: () => _showAddNoteDialog(),
            backgroundColor: AppColors.black,
            child: const Icon(Icons.add, color: AppColors.white),
          ),
        ),
      ],
    );
  }

  void _showAddNoteDialog() {
    final titleController = TextEditingController();
    final noteController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        backgroundColor: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Add Note',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: titleController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Title is required'
                      : null,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: noteController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Note is required'
                      : null,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('CANCEL'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            controller.addNote(
                              titleController.text,
                              noteController.text,
                            );
                            Get.back();
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('SAVE'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomVideoPlayer extends StatefulWidget {
  final ChewieController chewieController;
  final bool isFullScreenRoute;

  const _CustomVideoPlayer({
    required this.chewieController,
    this.isFullScreenRoute = false,
  });

  @override
  State<_CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<_CustomVideoPlayer> {
  bool _showControls = true;
  Timer? _hideTimer;

  VideoPlayerController get _controller =>
      widget.chewieController.videoPlayerController;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_videoListener);
    _startHideTimer();
  }

  void _videoListener() {
    if (mounted) {
      final value = _controller.value;
      if (value.position >= value.duration && value.duration > Duration.zero) {
        _showControls = true;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _hideTimer?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _controller.value.isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls && _controller.value.isPlaying) {
      _startHideTimer();
    } else {
      _hideTimer?.cancel();
    }
  }

  void _skip(int seconds) {
    final position = _controller.value.position;
    _controller.seekTo(position + Duration(seconds: seconds));
    _startHideTimer();
  }

  void _togglePlay() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      setState(() => _showControls = true);
      _hideTimer?.cancel();
    } else {
      _controller.play();
      _startHideTimer();
    }
  }

  void _toggleMute() {
    final isMuted = _controller.value.volume == 0;
    _controller.setVolume(isMuted ? 1.0 : 0.0);
    _startHideTimer();
  }

  void _toggleFullscreen(BuildContext context) {
    if (widget.isFullScreenRoute) {
      // If we are already in the fullscreen route, pop it
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      // Enter fullscreen: push a new instance of the player so state works perfectly
      Navigator.of(context, rootNavigator: true).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                child: Center(
                  child: _CustomVideoPlayer(
                    chewieController: widget.chewieController,
                    isFullScreenRoute: true,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
    _startHideTimer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        children: [
          Chewie(controller: widget.chewieController),
          AnimatedOpacity(
            opacity: _showControls ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              color: Colors.black45,
              child: Stack(
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.replay_10,
                            color: AppColors.white,
                            size: 40,
                          ),
                          onPressed: _showControls ? () => _skip(-10) : null,
                        ),
                        IconButton(
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            color: AppColors.white,
                            size: 60,
                          ),
                          onPressed: _showControls ? _togglePlay : null,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.forward_10,
                            color: AppColors.white,
                            size: 40,
                          ),
                          onPressed: _showControls ? () => _skip(10) : null,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 20,
                    right: 10,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                _controller.value.volume == 0
                                    ? Icons.volume_off
                                    : Icons.volume_up,
                                color: AppColors.white,
                                size: 28,
                              ),
                              onPressed: _showControls ? _toggleMute : null,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                colors: const VideoProgressColors(
                                  playedColor: AppColors.white,
                                  bufferedColor: Colors.white24,
                                  backgroundColor: Colors.white10,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                widget.isFullScreenRoute
                                    ? Icons.fullscreen_exit
                                    : Icons.fullscreen,
                                color: AppColors.white,
                                size: 28,
                              ),
                              onPressed: _showControls
                                  ? () => _toggleFullscreen(context)
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
