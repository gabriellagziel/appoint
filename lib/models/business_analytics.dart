class TimeSeriesPoint {
  TimeSeriesPoint({required this.date, required this.count});
  final DateTime date;
  final int count;
}

class ServiceDistribution {
  ServiceDistribution({required this.service, required this.bookings});
  final String service;
  final int bookings;
}

class RevenueByStaff {
  RevenueByStaff({required this.staff, required this.revenue});
  final String staff;
  final double revenue;
}
