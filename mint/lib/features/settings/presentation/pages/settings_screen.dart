import 'package:flutter/material.dart';
import 'package:mental_health/features/settings/presentation/pages/theme_test_screen.dart';

/// Màn hình Cài đặt
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _darkModeEnabled = true;
  double _reminderFrequency = 3.0; // hours

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Cài đặt',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile section
            _buildProfileSection(context),

            const SizedBox(height: 20),

            // Settings options
            Expanded(
              child: _buildSettingsOptions(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Card(
      color: Colors.black.withValues(alpha: 0.7),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Akuro',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'akuro@example.com',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _showEditProfile(context),
              icon: const Icon(Icons.edit, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOptions(BuildContext context) {
    return ListView(
      children: [
        // Thông báo
        _buildSettingsSection(
          context,
          'Thông báo',
          [
            _buildSwitchTile(
              'Bật thông báo',
              'Nhận thông báo nhắc nhở và cập nhật',
              Icons.notifications,
              _notificationsEnabled,
              (value) => setState(() => _notificationsEnabled = value),
            ),
            _buildSliderTile(
              'Tần suất nhắc nhở',
              'Nhắc nhở thực hiện nhiệm vụ hàng ngày',
              Icons.schedule,
              _reminderFrequency,
              1.0,
              12.0,
              (value) => setState(() => _reminderFrequency = value),
              '${_reminderFrequency.round()} giờ',
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Âm thanh & Hiển thị
        _buildSettingsSection(
          context,
          'Âm thanh & Hiển thị',
          [
            _buildSwitchTile(
              'Âm thanh',
              'Bật/tắt âm thanh trong ứng dụng',
              Icons.volume_up,
              _soundEnabled,
              (value) => setState(() => _soundEnabled = value),
            ),
            _buildSwitchTile(
              'Chế độ tối',
              'Sử dụng giao diện tối',
              Icons.dark_mode,
              _darkModeEnabled,
              (value) => setState(() => _darkModeEnabled = value),
            ),
            _buildActionTile(
              'Test Theme',
              'Kiểm tra chế độ sáng/tối',
              Icons.palette,
              () => _openThemeTest(context),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Tài khoản
        _buildSettingsSection(
          context,
          'Tài khoản',
          [
            _buildActionTile(
              'Đổi mật khẩu',
              'Cập nhật mật khẩu của bạn',
              Icons.lock,
              () => _showChangePassword(context),
            ),
            _buildActionTile(
              'Sao lưu dữ liệu',
              'Sao lưu dữ liệu lên cloud',
              Icons.backup,
              () => _showBackupOptions(context),
            ),
            _buildActionTile(
              'Xuất dữ liệu',
              'Tải xuống dữ liệu cá nhân',
              Icons.download,
              () => _exportData(context),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Hỗ trợ
        _buildSettingsSection(
          context,
          'Hỗ trợ',
          [
            _buildActionTile(
              'Trung tâm trợ giúp',
              'Câu hỏi thường gặp và hướng dẫn',
              Icons.help,
              () => _showHelpCenter(context),
            ),
            _buildActionTile(
              'Liên hệ hỗ trợ',
              'Gửi phản hồi hoặc báo lỗi',
              Icons.contact_support,
              () => _showContactSupport(context),
            ),
            _buildActionTile(
              'Về ứng dụng',
              'Thông tin phiên bản và điều khoản',
              Icons.info,
              () => _showAboutApp(context),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Đăng xuất
        _buildLogoutButton(context),
      ],
    );
  }

  Widget _buildSettingsSection(
      BuildContext context, String title, List<Widget> children) {
    return Card(
      color: Colors.black.withValues(alpha: 0.6),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon,
      bool value, Function(bool) onChanged) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle,
          style: const TextStyle(color: Colors.white54, fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }

  Widget _buildSliderTile(
      String title,
      String subtitle,
      IconData icon,
      double value,
      double min,
      double max,
      Function(double) onChanged,
      String displayValue) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: Colors.white70),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          subtitle: Text(subtitle,
              style: const TextStyle(color: Colors.white54, fontSize: 12)),
          trailing:
              Text(displayValue, style: const TextStyle(color: Colors.white70)),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          onChanged: onChanged,
          activeColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildActionTile(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle,
          style: const TextStyle(color: Colors.white54, fontSize: 12)),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutConfirmation(context),
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  void _showEditProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng đang phát triển')),
    );
  }

  void _showChangePassword(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng đang phát triển')),
    );
  }

  void _showBackupOptions(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng đang phát triển')),
    );
  }

  void _exportData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng đang phát triển')),
    );
  }

  void _showHelpCenter(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng đang phát triển')),
    );
  }

  void _showContactSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng đang phát triển')),
    );
  }

  void _showAboutApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text('Về ứng dụng', style: TextStyle(color: Colors.white)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mental Health App',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Phiên bản: 1.0.0', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 8),
            Text('Ứng dụng hỗ trợ chăm sóc sức khỏe tâm thần',
                style: TextStyle(color: Colors.white70)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?',
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Thực hiện đăng xuất
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã đăng xuất')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
                const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _openThemeTest(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ThemeTestScreen(),
      ),
    );
  }
}
