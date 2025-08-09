import * as admin from 'firebase-admin';

export type GroupType = 'community' | 'professional' | 'business';

export interface Group {
  id: string;
  name: string;
  type: GroupType;
  members: string[];
  events: string[];
  filesUploadedMB: number;
  createdAt: FirebaseFirestore.Timestamp;
  expiresAt?: FirebaseFirestore.Timestamp;
  expiredAt?: FirebaseFirestore.Timestamp;
  usageScore: number;
  ownerId: string;
  totalRevenue?: number;
}

export const getGroupsCollection = () => {
  if (!admin.apps.length) {
    admin.initializeApp();
  }
  return admin.firestore().collection('groups');
};



