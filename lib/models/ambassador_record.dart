class AmbassadorRecord {
  final String id;
  final String status;
  final String shareLink;
  final int referrals;

  AmbassadorRecord({
    required this.id,
    required this.status,
    required this.shareLink,
    required this.referrals,
  });

  factory AmbassadorRecord.fromJson(final Map<String, dynamic> json) {
    return AmbassadorRecord(
      id: json['id'] as String,
      status: json['status'] as String? ?? 'inactive',
      shareLink: json['shareLink'] as String? ?? '',
      referrals: (json['referrals'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'shareLink': shareLink,
        'referrals': referrals,
      };
}
