import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mental_health/core/services/sqlite_helper.dart';
import 'package:mental_health/core/services/database_constants.dart';
import 'package:mental_health/core/theme.dart';
import 'package:mental_health/injection_container.dart' as di;
import 'package:intl/intl.dart';

class QuoteHistoriesScreen extends StatefulWidget {
  const QuoteHistoriesScreen({super.key});

  @override
  State<QuoteHistoriesScreen> createState() => _QuoteHistoriesScreenState();
}

class _QuoteHistoriesScreenState extends State<QuoteHistoriesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SqliteHelper _sqliteHelper;

  List<Map<String, dynamic>> _allQuotes = [];
  List<Map<String, dynamic>> _favoriteQuotes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _sqliteHelper = di.sl<SqliteHelper>();
    _loadQuotes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadQuotes() async {
    setState(() => _isLoading = true);

    try {
      final allQuotes = await _sqliteHelper.getAll(
        DatabaseConstants.emotionHistoriesTable,
        orderBy: '${DatabaseConstants.emotionHistoriesCreatedAt} DESC',
      );

      final favoriteQuotes = await _sqliteHelper.getFavoriteEmotionHistories();

      setState(() {
        _allQuotes = allQuotes;
        _favoriteQuotes = favoriteQuotes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải dữ liệu: $e')),
        );
      }
    }
  }

  Future<void> _toggleFavorite(int quoteId) async {
    try {
      await _sqliteHelper.toggleEmotionHistoryFavorite(quoteId);
      await _loadQuotes(); // Reload data

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã cập nhật trạng thái yêu thích!'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi cập nhật: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Lịch sử Quote',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: DefaultColors.serotonin,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: DefaultColors.serotonin,
          labelStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Đã thích'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildQuotesList(_allQuotes),
                _buildQuotesList(_favoriteQuotes),
              ],
            ),
    );
  }

  Widget _buildQuotesList(List<Map<String, dynamic>> quotes) {
    if (quotes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.format_quote,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'Chưa có quote nào',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Hãy thử tương tác với các cảm xúc để nhận quote!',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadQuotes,
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          final quote = quotes[index];
          return _buildQuoteItem(quote);
        },
      ),
    );
  }

  Widget _buildQuoteItem(Map<String, dynamic> quote) {
    final emotion = quote[DatabaseConstants.emotionHistoriesEmotion] ?? '';
    final quoteText = quote[DatabaseConstants.emotionHistoriesQuote] ?? '';
    final author = quote[DatabaseConstants.emotionHistoriesAuthor] ?? '';
    final timestamp = quote[DatabaseConstants.emotionHistoriesTimestamp] ?? '';
    final createdAt = quote[DatabaseConstants.emotionHistoriesCreatedAt] ?? 0;
    final isFavorite =
        (quote[DatabaseConstants.emotionHistoriesIsFavorite] ?? 0) == 1;
    final quoteId = quote[DatabaseConstants.emotionHistoriesId] ?? 0;

    // Parse date
    DateTime dateTime;
    try {
      if (timestamp.isNotEmpty) {
        dateTime = DateTime.parse(timestamp);
      } else {
        dateTime = DateTime.fromMillisecondsSinceEpoch(createdAt);
      }
    } catch (e) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(createdAt);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with emotion icon and date
          Row(
            children: [
              // Emotion icon
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: _getEmotionColor(emotion).withValues(alpha: 0.1),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    _getEmotionIcon(emotion),
                    width: 18.w,
                    height: 18.h,
                    colorFilter: ColorFilter.mode(
                      _getEmotionColor(emotion),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Date and time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      emotion,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: _getEmotionColor(emotion),
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy • HH:mm').format(dateTime),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Favorite button
              GestureDetector(
                onTap: () => _toggleFavorite(quoteId),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey[400],
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Quote text (max 2 lines)
          Text(
            '"$quoteText"',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          // Author
          Text(
            '- $author',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'mục tiêu':
        return DefaultColors.serotonin;
      case 'vận động':
        return DefaultColors.dopamine;
      case 'gắn kết':
        return DefaultColors.oxytocin;
      case 'tự tin':
        return DefaultColors.endorphin;
      default:
        return DefaultColors.serotonin;
    }
  }

  String _getEmotionIcon(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'mục tiêu':
        return 'assets/icons/target.svg';
      case 'vận động':
        return 'assets/icons/energy.svg';
      case 'gắn kết':
        return 'assets/icons/heart.svg';
      case 'tự tin':
        return 'assets/icons/galaxy-star.svg';
      default:
        return 'assets/icons/target.svg';
    }
  }
}
