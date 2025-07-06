import 'package:flutter/material.dart';
import 'package:mental_health/features/meditation/presentation/pages/meditation_screen.dart';
import 'package:mental_health/features/meditation/presentation/pages/soul_tree_screen.dart';

class MeditationWrapperScreen extends StatefulWidget {
  const MeditationWrapperScreen({Key? key}) : super(key: key);

  @override
  State<MeditationWrapperScreen> createState() =>
      _MeditationWrapperScreenState();
}

class _MeditationWrapperScreenState extends State<MeditationWrapperScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  int _currentIndex = 0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (_isAnimating) return;

    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _navigateToPage(int index) {
    if (_isAnimating || _currentIndex == index) return;

    setState(() {
      _isAnimating = true;
    });

    _pageController
        .animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    )
        .then((_) {
      setState(() {
        _isAnimating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // PageView for swipe navigation
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: const [
              MeditationScreen(),
              SoulTreeScreen(),
            ],
          ),

          // Page indicator
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: _buildPageIndicator(),
          ),

          // Swipe hint overlay (only show initially)
          // if (_currentIndex == 0)
          //   Positioned(
          //     bottom: 120,
          //     right: 16,
          //     child: _buildSwipeHint(),
          //   ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withValues(alpha: 0.3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDot(0),
          const SizedBox(width: 8),
          _buildDot(1),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _navigateToPage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isActive ? 20 : 8,
        height: 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildSwipeHint() {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return AnimatedOpacity(
          opacity: _currentIndex == 0 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.black.withValues(alpha: 0.7),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.swipe_left,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Vuốt để xem Vườn Tâm Hồn',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
