class DashboardStats {
  DashboardStats({
    required this.totalAppointments,
    required this.completedAppointments,
    required this.pendingInvites,
    required this.revenue,
  });
  final int totalAppointments;
  final int completedAppointments;
  final int pendingInvites;
  final double revenue;
}
