import 'package:flutter/material.dart';
import 'package:mental_health/core/theme.dart';

/// Màn hình Kết nối với thiết kế glassmorphism hiện đại
class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  String? _selectedEmotion;
  int _currentPageIndex = 0;
  final PageController _pageController = PageController();

  // Mock data
  final List<Map<String, dynamic>> _emotions = [
    {'name': 'Vui vẻ', 'emoji': '😊', 'color': DefaultColors.serotonin},
    {'name': 'Buồn bã', 'emoji': '😢', 'color': DefaultColors.dopamine},
    {'name': 'Lo lắng', 'emoji': '😰', 'color': DefaultColors.endorphin},
    {'name': 'Tức giận', 'emoji': '😠', 'color': DefaultColors.oxytocin},
    {'name': 'Hạnh phúc', 'emoji': '😄', 'color': DefaultColors.serotoninNeon},
    {'name': 'Mệt mỏi', 'emoji': '😴', 'color': Colors.grey},
    {'name': 'Bối rối', 'emoji': '😕', 'color': DefaultColors.dopamineNeon},
    {'name': 'Yên bình', 'emoji': '😌', 'color': DefaultColors.oxytocinNeon},
  ];

  final List<Map<String, dynamic>> _mockUsers = [
    {
      'name': 'Minh Anh',
      'avatar': '👩‍💼',
      'emotion': 'Vui vẻ',
      'status': 'Đang online',
      'distance': '2.5km',
      'premium': false,
    },
    {
      'name': 'Hoàng Nam',
      'avatar': '👨‍💻',
      'emotion': 'Lo lắng',
      'status': 'Đang online',
      'distance': '1.2km',
      'premium': true,
    },
    {
      'name': 'Thu Hà',
      'avatar': '👩‍🎨',
      'emotion': 'Buồn bã',
      'status': 'Hoạt động 5 phút trước',
      'distance': '3.8km',
      'premium': false,
    },
  ];

  final List<Map<String, dynamic>> _mockDiaryEntries = [
    {
      'author': 'Linh Chi',
      'avatar': '👩‍🌾',
      'title': 'Hành trình vượt qua trầm cảm',
      'preview': 'Hôm nay tôi cảm thấy tốt hơn nhiều...',
      'emotion': 'Hạnh phúc',
      'price': 50000,
      'likes': 24,
      'time': '2 giờ trước',
      'isPremium': true,
    },
    {
      'author': 'Đức Minh',
      'avatar': '👨‍🎓',
      'title': 'Cách tôi đối phó với căng thẳng',
      'preview': 'Những kỹ thuật thở giúp tôi rất nhiều...',
      'emotion': 'Yên bình',
      'price': 30000,
      'likes': 18,
      'time': '4 giờ trước',
      'isPremium': true,
    },
    {
      'author': 'Mai Lan',
      'avatar': '👩‍🍳',
      'title': 'Tìm lại niềm vui trong cuộc sống',
      'preview': 'Việc nấu ăn đã giúp tôi...',
      'emotion': 'Vui vẻ',
      'price': 0,
      'likes': 32,
      'time': '1 ngày trước',
      'isPremium': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildModernAppBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
                children: [
                  _buildEmotionSelectionPage(),
                  _buildConnectionPage(),
                  _buildDiaryPage(),
                  _buildProfilePage(),
                ],
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildModernAppBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.15),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
          width: 1,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  DefaultColors.oxytocin.withValues(alpha: 0.3),
                  DefaultColors.oxytocinNeon.withValues(alpha: 0.1),
                ],
              ),
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: DefaultColors.oxytocinNeon,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kết nối cảm xúc', style: TextPresets.subTitle),
                Text('Tìm kiếm sự đồng cảm và chia sẻ',
                    style: TextPresets.title),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withValues(alpha: 0.1),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.15),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.mood, 'Cảm xúc'),
          _buildNavItem(1, Icons.chat_bubble_outline, 'Kết nối'),
          _buildNavItem(2, Icons.book_outlined, 'Nhật ký'),
          _buildNavItem(3, Icons.person_outline, 'Cá nhân'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentPageIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentPageIndex = index;
        });
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    DefaultColors.endorphin.withValues(alpha: 0.3),
                    DefaultColors.endorphinNeon.withValues(alpha: 0.1),
                  ],
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? DefaultColors.endorphinNeon
                  : Colors.black.withValues(alpha: 0.6),
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextPresets.labelSmall.copyWith(
                color: isSelected
                    ? DefaultColors.endorphin
                    : Colors.black.withValues(alpha: 0.6),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionSelectionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.12),
                  Colors.white.withValues(alpha: 0.04),
                ],
              ),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  spreadRadius: 0,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        DefaultColors.dopamine.withValues(alpha: 0.3),
                        DefaultColors.dopamineNeon.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
                    color: DefaultColors.dopamineNeon,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Bạn đang cảm thấy thế nào?', style: TextPresets.title),
                const SizedBox(height: 8),
                Text(
                  'Chọn cảm xúc hiện tại để tìm kiếm những người có cùng trạng thái',
                  style: TextPresets.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Chọn cảm xúc của bạn', style: TextPresets.subTitle),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: _emotions.length,
            itemBuilder: (context, index) {
              final emotion = _emotions[index];
              final isSelected = _selectedEmotion == emotion['name'];
              return _buildEmotionCard(emotion, isSelected);
            },
          ),
          if (_selectedEmotion != null) ...[
            const SizedBox(height: 24),
            _buildFindConnectionButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildEmotionCard(Map<String, dynamic> emotion, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedEmotion = isSelected ? null : emotion['name'];
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [
                    emotion['color'].withValues(alpha: 0.3),
                    emotion['color'].withValues(alpha: 0.1),
                  ]
                : [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.05),
                  ],
          ),
          border: Border.all(
            color: isSelected
                ? emotion['color'].withValues(alpha: 0.5)
                : Colors.black.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emotion['emoji'],
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              emotion['name'],
              style: TextPresets.bodyMedium.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? emotion['color'] : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFindConnectionButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _currentPageIndex = 1;
          });
          _pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: DefaultColors.endorphinNeon,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ).copyWith(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                DefaultColors.endorphin.withValues(alpha: 0.8),
                DefaultColors.endorphinNeon.withValues(alpha: 0.6),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: DefaultColors.endorphin.withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Tìm kiếm kết nối với cảm xúc "$_selectedEmotion"',
                style: TextPresets.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  DefaultColors.serotonin.withValues(alpha: 0.2),
                  DefaultColors.serotoninNeon.withValues(alpha: 0.1),
                ],
              ),
              border: Border.all(
                color: DefaultColors.serotonin.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.people_rounded,
                  color: DefaultColors.serotoninNeon,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text('Những người cùng cảm xúc', style: TextPresets.title),
                if (_selectedEmotion != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: DefaultColors.serotonin.withValues(alpha: 0.3),
                    ),
                    child: Text(
                      'Cảm xúc: $_selectedEmotion',
                      style: TextPresets.label.copyWith(
                        color: DefaultColors.serotonin,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Người dùng gần bạn', style: TextPresets.subTitle),
          const SizedBox(height: 16),
          ..._mockUsers.map((user) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildUserCard(user),
              )),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  DefaultColors.dopamine.withValues(alpha: 0.3),
                  DefaultColors.dopamineNeon.withValues(alpha: 0.1),
                ],
              ),
            ),
            child: Center(
              child: Text(
                user['avatar'],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user['name'],
                      style: TextPresets.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (user['premium']) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              DefaultColors.oxytocin,
                              DefaultColors.oxytocinNeon,
                            ],
                          ),
                        ),
                        child: Text(
                          'PRO',
                          style: TextPresets.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: DefaultColors.endorphin.withValues(alpha: 0.2),
                      ),
                      child: Text(
                        user['emotion'],
                        style: TextPresets.labelSmall.copyWith(
                          color: DefaultColors.endorphin,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '📍 ${user['distance']}',
                      style: TextPresets.bodySmall.copyWith(
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: user['status'] == 'Đang online'
                            ? DefaultColors.serotonin
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      user['status'],
                      style: TextPresets.bodySmall.copyWith(
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      DefaultColors.serotonin.withValues(alpha: 0.2),
                      DefaultColors.serotoninNeon.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: DefaultColors.serotoninNeon,
                  size: 16,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      DefaultColors.oxytocin.withValues(alpha: 0.2),
                      DefaultColors.oxytocinNeon.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.person_add_outlined,
                  color: DefaultColors.oxytocinNeon,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiaryPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  DefaultColors.oxytocin.withValues(alpha: 0.2),
                  DefaultColors.oxytocinNeon.withValues(alpha: 0.1),
                ],
              ),
              border: Border.all(
                color: DefaultColors.oxytocin.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.book_rounded,
                  color: DefaultColors.oxytocinNeon,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text('Nhật ký cảm xúc cộng đồng', style: TextPresets.title),
                const SizedBox(height: 8),
                Text(
                  'Khám phá những câu chuyện và trải nghiệm từ cộng đồng',
                  style: TextPresets.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Nhật ký nổi bật', style: TextPresets.subTitle),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      DefaultColors.endorphin.withValues(alpha: 0.2),
                      DefaultColors.endorphinNeon.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add,
                      color: DefaultColors.endorphinNeon,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Viết nhật ký',
                      style: TextPresets.labelSmall.copyWith(
                        color: DefaultColors.endorphin,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._mockDiaryEntries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildDiaryCard(entry),
              )),
        ],
      ),
    );
  }

  Widget _buildDiaryCard(Map<String, dynamic> entry) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      DefaultColors.dopamine.withValues(alpha: 0.3),
                      DefaultColors.dopamineNeon.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    entry['avatar'],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          entry['author'],
                          style: TextPresets.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (entry['isPremium']) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                colors: [
                                  DefaultColors.oxytocin,
                                  DefaultColors.oxytocinNeon,
                                ],
                              ),
                            ),
                            child: Text(
                              'PREMIUM',
                              style: TextPresets.labelSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      entry['time'],
                      style: TextPresets.bodySmall.copyWith(
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (entry['price'] > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: DefaultColors.endorphin.withValues(alpha: 0.2),
                  ),
                  child: Text(
                    '${entry['price']}đ',
                    style: TextPresets.labelSmall.copyWith(
                      color: DefaultColors.endorphin,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            entry['title'],
            style: TextPresets.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            entry['preview'],
            style: TextPresets.bodyMedium.copyWith(
              color: Colors.black.withValues(alpha: 0.7),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: DefaultColors.serotonin.withValues(alpha: 0.2),
                ),
                child: Text(
                  entry['emotion'],
                  style: TextPresets.labelSmall.copyWith(
                    color: DefaultColors.serotonin,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(
                    Icons.favorite_border,
                    color: DefaultColors.oxytocin,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${entry['likes']}',
                    style: TextPresets.bodySmall.copyWith(
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          DefaultColors.dopamine.withValues(alpha: 0.2),
                          DefaultColors.dopamineNeon.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    child: Text(
                      entry['price'] > 0 ? 'Mua để đọc' : 'Đọc miễn phí',
                      style: TextPresets.labelSmall.copyWith(
                        color: DefaultColors.dopamine,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  DefaultColors.endorphin.withValues(alpha: 0.2),
                  DefaultColors.endorphinNeon.withValues(alpha: 0.1),
                ],
              ),
              border: Border.all(
                color: DefaultColors.endorphin.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        DefaultColors.endorphin.withValues(alpha: 0.3),
                        DefaultColors.endorphinNeon.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '👤',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Trang cá nhân của bạn', style: TextPresets.title),
                const SizedBox(height: 8),
                Text(
                  'Quản lý nhật ký cảm xúc và kết nối với cộng đồng',
                  style: TextPresets.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Actions
          Text('Hành động nhanh', style: TextPresets.subTitle),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'Viết nhật ký',
                  Icons.edit_note,
                  DefaultColors.serotonin,
                  () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  'Chia sẻ cảm xúc',
                  Icons.share,
                  DefaultColors.oxytocin,
                  () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // My Diary Entries
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Nhật ký của tôi', style: TextPresets.subTitle),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      DefaultColors.dopamine.withValues(alpha: 0.2),
                      DefaultColors.dopamineNeon.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.visibility,
                      color: DefaultColors.dopamineNeon,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Xem tất cả',
                      style: TextPresets.labelSmall.copyWith(
                        color: DefaultColors.dopamine,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // My Diary Cards
          _buildMyDiaryCard(
            'Hành trình tự chăm sóc bản thân',
            'Hôm nay tôi đã học được cách yêu thương bản thân nhiều hơn...',
            'Hạnh phúc',
            '2 giờ trước',
            25000,
            12,
          ),
          const SizedBox(height: 12),
          _buildMyDiaryCard(
            'Vượt qua những ngày khó khăn',
            'Chia sẻ những phương pháp giúp tôi vượt qua stress...',
            'Yên bình',
            '1 ngày trước',
            0,
            8,
          ),
          const SizedBox(height: 24),

          // Settings
          Text('Cài đặt', style: TextPresets.subTitle),
          const SizedBox(height: 16),
          _buildSettingItem('Quyền riêng tư', Icons.privacy_tip, () {}),
          _buildSettingItem('Thông báo', Icons.notifications, () {}),
          _buildSettingItem('Tài khoản Premium', Icons.star, () {}),
          _buildSettingItem('Hỗ trợ', Icons.help, () {}),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.2),
              color.withValues(alpha: 0.1),
            ],
          ),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextPresets.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyDiaryCard(String title, String preview, String emotion,
      String time, int price, int likes) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextPresets.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (price > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: DefaultColors.endorphin.withValues(alpha: 0.2),
                  ),
                  child: Text(
                    '${price}đ',
                    style: TextPresets.labelSmall.copyWith(
                      color: DefaultColors.endorphin,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            preview,
            style: TextPresets.bodyMedium.copyWith(
              color: Colors.black.withValues(alpha: 0.7),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: DefaultColors.serotonin.withValues(alpha: 0.2),
                ),
                child: Text(
                  emotion,
                  style: TextPresets.labelSmall.copyWith(
                    color: DefaultColors.serotonin,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: TextPresets.bodySmall.copyWith(
                  color: Colors.black.withValues(alpha: 0.6),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(
                    Icons.favorite_border,
                    color: DefaultColors.oxytocin,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$likes',
                    style: TextPresets.bodySmall.copyWith(
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.08),
              Colors.white.withValues(alpha: 0.04),
            ],
          ),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black.withValues(alpha: 0.7),
              size: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextPresets.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black.withValues(alpha: 0.4),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
