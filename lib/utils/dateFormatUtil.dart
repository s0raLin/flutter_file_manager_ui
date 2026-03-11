/// 日期格式化工具类
class DateFormatUtil {
  /// 将 DateTime 转换为友好的英文日期格式
  /// 例如: "Mar 11, 2026" 或 "Mar 11, 2026 07:08"
  static String formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final month = months[date.month - 1];
    final day = date.day;
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$month $day, $year $hour:$minute';
  }

  /// 相对时间格式（更简洁）
  /// 如果是今天显示时间，如果是今年显示 "Mar 11"，否则显示完整日期
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateDay = DateTime(date.year, date.month, date.day);

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final month = months[date.month - 1];
    final day = date.day;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    // 如果是今天
    if (dateDay == today) {
      return 'Today $hour:$minute';
    }

    // 如果是昨天
    final yesterday = today.subtract(const Duration(days: 1));
    if (dateDay == yesterday) {
      return 'Yesterday $hour:$minute';
    }

    // 如果是今年
    if (date.year == now.year) {
      return '$month $day, $hour:$minute';
    }

    // 其他情况显示完整日期
    return '$month $day, ${date.year}';
  }
}
