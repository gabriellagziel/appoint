class UserRewards {
  final String id;
  final int points;

  UserRewards({required this.id, required this.points});

  factory UserRewards.fromJson(Map<String, dynamic> json) {
    return UserRewards(
      id: json['id'] as String? ?? '',
      points: json['points'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'points': points,
      };
}
