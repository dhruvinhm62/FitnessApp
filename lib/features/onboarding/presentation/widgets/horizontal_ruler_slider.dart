import 'package:flutter/material.dart';

class HorizontalRulerSlider extends StatefulWidget {
  final int min;
  final int max;
  final int initialValue;
  final ValueChanged<int> onChanged;

  const HorizontalRulerSlider({
    super.key,
    required this.min,
    required this.max,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<HorizontalRulerSlider> createState() => _HorizontalRulerSliderState();
}

class _HorizontalRulerSliderState extends State<HorizontalRulerSlider> {
  late ScrollController _scrollController;
  final double itemWidth = 10.0;
  late int currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
    double initialOffset = (currentValue - widget.min) * itemWidth;
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          int index = (notification.metrics.pixels / itemWidth).round();
          int newValue = widget.min + index;
          if (newValue < widget.min) newValue = widget.min;
          if (newValue > widget.max) newValue = widget.max;
          if (newValue != currentValue) {
            setState(() {
              currentValue = newValue;
            });
            widget.onChanged(newValue);
          }
        }
        if (notification is ScrollEndNotification) {
          // snap to nearest
          double targetOffset = (currentValue - widget.min) * itemWidth;
          Future.microtask(() {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                targetOffset,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
              );
            }
          });
        }
        return true;
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 2 - (itemWidth / 2)),
            itemCount: (widget.max - widget.min) + 1,
            itemBuilder: (context, index) {
              int value = widget.min + index;
              bool isMajor = value % 10 == 0;
              bool isMedium = value % 5 == 0 && !isMajor;

              return Container(
                width: itemWidth,
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isMajor)
                      Text(
                        value.toString(),
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    if (!isMajor) const SizedBox(height: 14),
                    const SizedBox(height: 4),
                    Container(
                      width: 2,
                      height: isMajor ? 30 : (isMedium ? 20 : 15),
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              );
            },
          ),
          // Center green line indicator
          Container(
            width: 2,
            height: 60,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
