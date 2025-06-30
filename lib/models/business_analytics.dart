class TimeSeriesPoint {
  final DateTime date;
  final int count;

  TimeSeriesPoint({required this.date, required this.count});
}

class ServiceDistribution {
  final String service;
  final int bookings;

  ServiceDistribution({required this.service, required this.bookings});
}

class RevenueByStaff {
  final String staff;
  final double revenue;

  RevenueByStaff({required this.staff, required this.revenue});
}
