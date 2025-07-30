class AmbassadorRecord {
  AmbassadorRecord({
    required this.id,
    required this.status,
    required this.shareLink,
    required this.referrals,
  });

  factory AmbassadorRecord.fromJson(Map<String, dynamic> json) =>
      AmbassadorRecord(
        id: json['id'] as String,
        status: json['status'] as String? ?? 'inactive',
        shareLink: json['shareLink'] as String? ?? '',
        referrals: (json['referrals'] as num?)?.toInt() ?? 0,
      );
  final String id;
  final String status;
  final String shareLink;
  final int referrals;

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'shareLink': shareLink,
        'referrals': referrals,
      };
}
