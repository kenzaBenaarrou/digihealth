import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

/// A beautiful full-screen loading widget that appears while fetching dashboard data
/// 
/// Features:
/// - Dark blue futuristic background (Color(0xFF051024))
/// - Subtle dotted grid pattern
/// - Centered loading text
/// - Animated horizontal progress bar with cyan color and orange glow effect
/// - Shimmer animation for premium feel
class DashboardLoadingScreen extends StatefulWidget {
  /// The loading message to display
  final String? message;

  /// Whether to show as a full screen overlay (default) or inline
  final bool isFullScreen;

  const DashboardLoadingScreen({
    super.key,
    this.message,
    this.isFullScreen = true,
  });

  @override
  State<DashboardLoadingScreen> createState() => _DashboardLoadingScreenState();
}

class _DashboardLoadingScreenState extends State<DashboardLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for the progress bar
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(); // Repeat indefinitely

    // Create a smooth animation curve
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.isFullScreen ? double.infinity : null,
      decoration: const BoxDecoration(
        color: Color(0xFF051024), // Very dark blue background
      ),
      child: Stack(
        children: [
          // Dotted grid pattern background
          _buildDottedGridPattern(),
          
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Loading text
                Text(
                  widget.message ?? 'Chargement des données du tableau de bord...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 32.h),
                
                // Animated progress bar
                _buildAnimatedProgressBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the subtle dotted grid pattern for the background
  Widget _buildDottedGridPattern() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _DottedGridPainter(),
      ),
    );
  }

  /// Builds the animated horizontal progress bar with cyan and orange glow
  Widget _buildAnimatedProgressBar() {
    return Container(
      width: 280.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            size: Size(240.w, 4.h),
            painter: _ProgressBarPainter(
              progress: _animation.value,
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter for the dotted grid pattern background
class _DottedGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1.5;

    const double spacing = 30.0; // Space between dots

    // Draw vertical and horizontal dots
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(
          Offset(x, y),
          1.0, // Dot radius
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for the animated progress bar with glow effect
class _ProgressBarPainter extends CustomPainter {
  final double progress;

  _ProgressBarPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Background track
    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw background track
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      trackPaint,
    );

    // Calculate the animated position
    // Create a wave effect that moves across the bar
    final double centerPosition = size.width * progress;
    final double glowWidth = size.width * 0.3; // Width of the glowing section

    // Create gradient for the progress bar
    final Rect gradientRect = Rect.fromLTWH(
      math.max(0, centerPosition - glowWidth),
      0,
      glowWidth * 2,
      size.height,
    );

    final gradient = LinearGradient(
      colors: [
        const Color(0xFFFF9800).withOpacity(0.3), // Orange glow start
        const Color(0xFFFF9800), // Orange at the leading edge
        const Color(0xFF00BCD4), // Cyan
        const Color(0xFF00BCD4).withOpacity(0.5), // Fading cyan
      ],
      stops: const [0.0, 0.2, 0.6, 1.0],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(gradientRect)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw the visible portion of the progress bar
    final visibleStart = math.max(0.0, centerPosition - glowWidth);
    final visibleEnd = math.min(size.width, centerPosition + glowWidth);

    canvas.drawLine(
      Offset(visibleStart, size.height / 2),
      Offset(visibleEnd, size.height / 2),
      progressPaint,
    );

    // Add glow effect at the leading edge
    final glowPaint = Paint()
      ..color = const Color(0xFFFF9800).withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Draw glow circle at the current position
    if (centerPosition >= 0 && centerPosition <= size.width) {
      canvas.drawCircle(
        Offset(centerPosition, size.height / 2),
        6,
        glowPaint,
      );
    }

    // Add another layer of glow for more intensity
    final innerGlowPaint = Paint()
      ..color = const Color(0xFFFF9800).withOpacity(0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    if (centerPosition >= 0 && centerPosition <= size.width) {
      canvas.drawCircle(
        Offset(centerPosition, size.height / 2),
        3,
        innerGlowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressBarPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
