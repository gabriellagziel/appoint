class RewardTier {
  final String name;
  final int pointsRequired;

  const RewardTier({required this.name, required this.pointsRequired});

  factory RewardTier.fromJson(Map<String, dynamic> json) {
    return RewardTier(
      name: json['name'] as String? ?? '',
      pointsRequired: json['pointsRequired'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'pointsRequired': pointsRequired,
      };
}
