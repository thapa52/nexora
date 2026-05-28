import 'package:flutter_test/flutter_test.dart';
import 'package:nexora/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter.fromUnixTimestamp', () {
    test('converts unix timestamp to DateTime correctly', () {
      final result = DateFormatter.fromUnixTimestamp(1700000000);

      // Use UTC to avoid timezone differences
      final utcResult = result.toUtc();

      expect(utcResult.year, 2023);
      expect(utcResult.month, 11);
      expect(utcResult.day, 14);
    });

    test('converts zero timestamp to epoch starts', () {
      final result = DateFormatter.fromUnixTimestamp(0);

      // Use UTC to avoid timezone differences
      final utcResult = result.toUtc();

      expect(utcResult.year, 1970);
      expect(utcResult.month, 1);
      expect(utcResult.day, 1);
    });
  });

  group('DateFormatter.timeAgo', () {
    /// Helper to create a timestamp for "X seconds ago"
    int timestampSecondsAgo(int seconds) {
      return DateTime.now()
              .subtract(Duration(seconds: seconds))
              .millisecondsSinceEpoch ~/
          1000;
    }

    test('returns "Just now" for less than 60 seonds ago', () {
      final timestamp = timestampSecondsAgo(30);
      final result = DateFormatter.timeAgo(timestamp);
      expect(result, 'Just Now');
    });

    test('returns minutes ago for less than 60 minutes', () {
      final timestamp = timestampSecondsAgo(300); // 5 minutes
      final result = DateFormatter.timeAgo(timestamp);
      expect(result, '5 minutes ago');
    });

    test('returns singular minute', () {
      final timestamp = timestampSecondsAgo(60); // 1 minute
      final result = DateFormatter.timeAgo(timestamp);
      expect(result, '1 minute ago');
    });

    test('returns hours ago for less than 24 hours', () {
      final timestamp = timestampSecondsAgo(7200); // 2 hours
      final result = DateFormatter.timeAgo(timestamp);
      expect(result, '2 hours ago');
    });

    test('returns singular hour', () {
      final timestamp = timestampSecondsAgo(3600); // 1 hour
      final result = DateFormatter.timeAgo(timestamp);
      expect(result, '1 hour ago');
    });

    test('returns days ago for less than 7 days', () {
      final timestamp = timestampSecondsAgo(259200); //3 days
      final result = DateFormatter.timeAgo(timestamp);
      expect(result, '3 days ago');
    });

    test('returns singular day', () {
      final timestamp = timestampSecondsAgo(86400); // 1 day
      final result = DateFormatter.timeAgo(timestamp);
      expect(result, '1 day ago');
    });

    test('returns weeks ago for less thaN 30 days', () {
      final timestamp = timestampSecondsAgo(1209600); // 14 days = 2 weeks
      final result = DateFormatter.timeAgo(timestamp);
      expect(result, '2 weeks ago');
    });

    test('returns a singular week', () {
      final timestamp = timestampSecondsAgo(604800); // 7 days = 1 week
      final result = DateFormatter.timeAgo(timestamp);
      expect(result, '1 week ago');
    });

    test('returns months ago for less than 365 days', () {
      final timestamp = timestampSecondsAgo(7776000); // 90 days = 3 months
      final result = DateFormatter.timeAgo(timestamp);
      expect(result, '3 months ago');
    });

    test('returns years ago for more than 365 days', () {
      final timestamp = timestampSecondsAgo(63072000); // 730 days = 2 years
      final result = DateFormatter.timeAgo(timestamp);
      expect(result, '2 years ago');
    });
  });

  group('DateFormatter.formatDate', () {
    test('formats timestamp to readable date', () {
      // Use a timestamp and calculate expected date in LOCAL timezone to avoid timezone issues
      final datetime = DateFormatter.fromUnixTimestamp(1700000000);
      final result = DateFormatter.formatDate(1700000000);

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

      final expected =
          '${months[datetime.month - 1]} ${datetime.day}, ${datetime.year}';

      expect(result, expected);
    });

    test('formats January date correctly', () {
      final result = DateFormatter.formatDate(1704067200);

      expect(result, 'Jan 1, 2024');
    });

    test('formats epoch start correctly', () {
      // Use a timestamp and calculate expected date in LOCAL timezone to avoid timezone issues
      final datetime = DateFormatter.fromUnixTimestamp(0);
      final result = DateFormatter.formatDate(0);

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

      final expected =
          '${months[datetime.month - 1]} ${datetime.day}, ${datetime.year}';

      expect(result, expected);
    });
  });
}
