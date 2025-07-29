import 'package:appoint/models/dashboard_stats.dart';
import 'package:appoint/models/invite.dart';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DashboardStats> fetchDashboardStats() async {
    final appointmentsSnap = await _firestore.collection('appointments').get();
    final totalAppointments = appointmentsSnap.size;
    final completedAppointments = appointmentsSnap.docs.where((final doc) {
      final status = doc.data()['status'] as String?;
      return status == 'accepted' || status == 'completed';
    }).length;

    final invitesSnap = await _firestore
        .collection('invites')
        .where('status', isEqualTo: InviteStatus.pending.name)
        .get();
    final pendingInvites = invitesSnap.size;

    final paymentsDoc =
        await _firestore.collection('payments').doc('summary').get();
    final revenue =
        (paymentsDoc.data()?['totalRevenue'] as num?)?.toDouble() ?? 0.0;

    return DashboardStats(
      totalAppointments: totalAppointments,
      completedAppointments: completedAppointments,
      pendingInvites: pendingInvites,
      revenue: revenue,
    );
  }

  Stream<DashboardStats> watchDashboardStats() {
    final appointmentsStream =
        _firestore.collection('appointments').snapshots();
    final invitesStream = _firestore.collection('invites').snapshots();
    final paymentsStream =
        _firestore.collection('payments').doc('summary').snapshots();

    return StreamZip([
      appointmentsStream,
      invitesStream,
      paymentsStream,
    ]).map((values) {
      final appointmentsSnapshot =
          values[0] as QuerySnapshot<Map<String, dynamic>>;
      final invitesSnapshot = values[1] as QuerySnapshot<Map<String, dynamic>>;
      final paymentsSnapshot =
          values[2] as DocumentSnapshot<Map<String, dynamic>>;

      final totalAppointments = appointmentsSnapshot.size;
      final completedAppointments = appointmentsSnapshot.docs.where((doc) {
        final status = doc.data()['status'] as String?;
        return status == 'accepted' || status == 'completed';
      }).length;

      final pendingInvites = invitesSnapshot.docs.where((final doc) {
        final status = doc.data()['status'] as String?;
        return status == InviteStatus.pending.name;
      }).length;

      final revenue =
          (paymentsSnapshot.data()?['totalRevenue'] as num?)?.toDouble() ?? 0.0;

      return DashboardStats(
        totalAppointments: totalAppointments,
        completedAppointments: completedAppointments,
        pendingInvites: pendingInvites,
        revenue: revenue,
      );
    });
  }
}
