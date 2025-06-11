class Analytics {
  final int totalUsers;
  final int totalOrgs;
  final int activeAppointments;

  Analytics({
    required this.totalUsers,
    required this.totalOrgs,
    required this.activeAppointments,
  });

  factory Analytics.fromMap(Map<String, dynamic> map) {
    return Analytics(
      totalUsers: (map['totalUsers'] as num?)?.toInt() ?? 0,
      totalOrgs: (map['totalOrgs'] as num?)?.toInt() ?? 0,
      activeAppointments: (map['activeAppointments'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalUsers': totalUsers,
      'totalOrgs': totalOrgs,
      'activeAppointments': activeAppointments,
    };
  }
}
