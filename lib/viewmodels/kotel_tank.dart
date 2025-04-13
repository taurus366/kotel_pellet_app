import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

class KotelTank extends StatefulWidget {
  final double percentage; // 0.0 - 100.0
  final double height;

  const KotelTank({required this.percentage, required this.height, super.key});

  @override
  State<KotelTank> createState() => _KotelTankState();
}

class _KotelTankState extends State<KotelTank> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Инициализираме анимацията
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Анимацията на височината на водата, в зависимост от процента
    _animation = Tween<double>(begin: 0, end: widget.percentage).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Стартираме анимацията
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant KotelTank oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.percentage != oldWidget.percentage) {
      // Ако процентът се промени, стартираме отново анимацията
      _controller.reset();
      _controller.forward();
      _animation = Tween<double>(begin: oldWidget.percentage, end: widget.percentage).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Анимирана вълна, която променя височината според процента
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return SizedBox(
                height: 200 * (_animation.value / 100),
                width: double.infinity,
                child: WaveWidget(
                  config: CustomConfig(
                    gradients: [
                      [Colors.blue, Colors.blueAccent],
                    ],
                    durations: [3500],
                    heightPercentages: [-0.06],
                  ),
                  waveAmplitude: 0,
                  size: const Size(double.infinity, double.infinity),
                ),
              );
            },
          ),
          Center(
            heightFactor: 1.5,
            child: Text(
              '${widget.percentage.toStringAsFixed(1)}%\n${widget.height.toStringAsFixed(1)} cm',
              style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black87, fontSize: 15.0),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
