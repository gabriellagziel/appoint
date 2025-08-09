import { db } from "@/lib/firebase";
import { getStorage, ref, uploadBytes, getDownloadURL, deleteObject } from "firebase/storage";
import {
    collection,
    doc,
    getDoc,
    getDocs,
    addDoc,
    updateDoc,
    deleteDoc,
    query,
    where,
    orderBy,
    limit,
    startAfter,
    QueryDocumentSnapshot,
    DocumentData,
    serverTimestamp
} from "firebase/firestore";

// Development mode flag
const DEV_MODE = !process.env.NEXT_PUBLIC_FIREBASE_API_KEY;

// Initialize Firebase Storage
const storage = getStorage();

export interface ContentItem {
    id: string;
    title: string;
    slug: string;
    body: string;
    excerpt?: string;
    type: 'article' | 'page' | 'help' | 'policy' | 'announcement';
    status: 'draft' | 'published' | 'archived';
    authorId: string;
    authorEmail?: string;
    authorName?: string;
    featuredImage?: string;
    tags?: string[];
    metaTitle?: string;
    metaDescription?: string;
    publishedAt?: Date;
    createdAt: Date;
    updatedAt: Date;
    viewCount?: number;
    seoUrl?: string;
}

export interface MediaAsset {
    id: string;
    fileName: string;
    originalName: string;
    url: string;
    size: number;
    mimeType: string;
    uploadedBy: string;
    uploadedByEmail?: string;
    createdAt: Date;
    altText?: string;
    caption?: string;
    tags?: string[];
}

export interface ContentFilters {
    type?: string;
    status?: string;
    authorId?: string;
    search?: string;
    dateFrom?: Date;
    dateTo?: Date;
    tags?: string[];
}

export interface ContentResponse {
    content: ContentItem[];
    total: number;
    hasMore: boolean;
    lastDoc?: QueryDocumentSnapshot<DocumentData>;
}

// Mock data for development
const MOCK_CONTENT: ContentItem[] = [
    {
        id: '1',
        title: 'Welcome to App-Oint',
        slug: 'welcome-to-app-oint',
        body: '<p>Welcome to App-Oint, the ultimate appointment scheduling platform...</p>',
        excerpt: 'Learn about the features and benefits of App-Oint',
        type: 'page',
        status: 'published',
        authorId: 'admin-1',
        authorEmail: 'admin@app-oint.com',
        authorName: 'Admin User',
        featuredImage: 'https://via.placeholder.com/800x400',
        tags: ['welcome', 'introduction'],
        metaTitle: 'Welcome to App-Oint - Appointment Scheduling Platform',
        metaDescription: 'Discover the features and benefits of App-Oint',
        publishedAt: new Date('2024-01-15T10:00:00Z'),
        createdAt: new Date('2024-01-15T09:00:00Z'),
        updatedAt: new Date('2024-01-15T10:00:00Z'),
        viewCount: 1250
    },
    {
        id: '2',
        title: 'How to Schedule Your First Appointment',
        slug: 'REDACTED_TOKEN',
        body: '<p>Follow these simple steps to schedule your first appointment...</p>',
        excerpt: 'Step-by-step guide for new users',
        type: 'help',
        status: 'published',
        authorId: 'admin-1',
        authorEmail: 'admin@app-oint.com',
        authorName: 'Admin User',
        featuredImage: 'https://via.placeholder.com/800x400',
        tags: ['help', 'tutorial', 'first-time'],
        metaTitle: 'How to Schedule Your First Appointment - App-Oint Help',
        metaDescription: 'Learn how to schedule your first appointment with App-Oint',
        publishedAt: new Date('2024-01-14T14:30:00Z'),
        createdAt: new Date('2024-01-14T13:00:00Z'),
        updatedAt: new Date('2024-01-14T14:30:00Z'),
        viewCount: 890
    },
    {
        id: '3',
        title: 'Privacy Policy',
        slug: 'privacy-policy',
        body: '<p>This Privacy Policy describes how App-Oint collects, uses, and protects your information...</p>',
        excerpt: 'Our commitment to protecting your privacy',
        type: 'policy',
        status: 'published',
        authorId: 'admin-1',
        authorEmail: 'admin@app-oint.com',
        authorName: 'Admin User',
        tags: ['legal', 'privacy'],
        metaTitle: 'Privacy Policy - App-Oint',
        metaDescription: 'Learn about how App-Oint protects your privacy and data',
        publishedAt: new Date('2024-01-10T12:00:00Z'),
        createdAt: new Date('2024-01-10T11:00:00Z'),
        updatedAt: new Date('2024-01-10T12:00:00Z'),
        viewCount: 450
    }
];

const MOCK_MEDIA: MediaAsset[] = [
    {
        id: '1',
        fileName: 'welcome-banner.jpg',
        originalName: 'welcome-banner.jpg',
        url: 'https://via.placeholder.com/800x400',
        size: 245760,
        mimeType: 'image/jpeg',
        uploadedBy: 'admin-1',
        uploadedByEmail: 'admin@app-oint.com',
        createdAt: new Date('2024-01-15T09:00:00Z'),
        altText: 'Welcome banner for App-Oint',
        caption: 'Welcome to App-Oint',
        tags: ['banner', 'welcome']
    },
    {
        id: '2',
        fileName: 'tutorial-video.mp4',
        originalName: 'tutorial-video.mp4',
        url: 'https://example.com/videos/tutorial.mp4',
        size: 5242880,
        mimeType: 'video/mp4',
        uploadedBy: 'admin-1',
        uploadedByEmail: 'admin@app-oint.com',
        createdAt: new Date('2024-01-14T13:00:00Z'),
        altText: 'Tutorial video for new users',
        caption: 'How to use App-Oint',
        tags: ['video', 'tutorial']
    }
];

// Fetch content with pagination and filters
export async function getContentList(
    filters: ContentFilters = {},
    pageSize: number = 20,
    lastDoc?: QueryDocumentSnapshot<DocumentData>
): Promise<ContentResponse> {
    try {
        if (DEV_MODE) {
            let filteredContent = MOCK_CONTENT;

            // Apply filters
            if (filters.type && filters.type !== 'all') {
                filteredContent = filteredContent.filter(c => c.type === filters.type);
            }
            if (filters.status && filters.status !== 'all') {
                filteredContent = filteredContent.filter(c => c.status === filters.status);
            }
            if (filters.authorId) {
                filteredContent = filteredContent.filter(c => c.authorId === filters.authorId);
            }
            if (filters.search) {
                const searchLower = filters.search.toLowerCase();
                filteredContent = filteredContent.filter(c =>
                    c.title.toLowerCase().includes(searchLower) ||
                    c.body.toLowerCase().includes(searchLower) ||
                    c.excerpt?.toLowerCase().includes(searchLower)
                );
            }
            if (filters.dateFrom) {
                filteredContent = filteredContent.filter(c => c.createdAt >= filters.dateFrom!);
            }
            if (filters.dateTo) {
                filteredContent = filteredContent.filter(c => c.createdAt <= filters.dateTo!);
            }
            if (filters.tags && filters.tags.length > 0) {
                filteredContent = filteredContent.filter(c =>
                    c.tags?.some(tag => filters.tags!.includes(tag))
                );
            }

            return {
                content: filteredContent,
                total: filteredContent.length,
                hasMore: false
            };
        }

        let q = collection(db, "content");
        const constraints: any[] = [];

        // Apply filters
        if (filters.type && filters.type !== 'all') {
            constraints.push(where("type", "==", filters.type));
        }
        if (filters.status && filters.status !== 'all') {
            constraints.push(where("status", "==", filters.status));
        }
        if (filters.authorId) {
            constraints.push(where("authorId", "==", filters.authorId));
        }
        if (filters.dateFrom) {
            constraints.push(where("createdAt", ">=", filters.dateFrom));
        }
        if (filters.dateTo) {
            constraints.push(where("createdAt", "<=", filters.dateTo));
        }

        // Add ordering and pagination
        constraints.push(orderBy("createdAt", "desc"));
        constraints.push(limit(pageSize));

        if (lastDoc) {
            constraints.push(startAfter(lastDoc));
        }

        const querySnapshot = await getDocs(query(q, ...constraints));
        const content = querySnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            createdAt: doc.data().createdAt?.toDate() || new Date(),
            updatedAt: doc.data().updatedAt?.toDate() || new Date(),
            publishedAt: doc.data().publishedAt?.toDate()
        })) as ContentItem[];

        // If search filter is applied, filter client-side
        let filteredContent = content;
        if (filters.search) {
            const searchLower = filters.search.toLowerCase();
            filteredContent = content.filter(item =>
                item.title.toLowerCase().includes(searchLower) ||
                item.body.toLowerCase().includes(searchLower) ||
                item.excerpt?.toLowerCase().includes(searchLower)
            );
        }

        return {
            content: filteredContent,
            total: filteredContent.length,
            hasMore: querySnapshot.docs.length === pageSize,
            lastDoc: querySnapshot.docs[querySnapshot.docs.length - 1]
        };
    } catch (error) {
        console.error('Error fetching content:', error);
        throw error;
    }
}

// Get content by ID
export async function getContentById(id: string): Promise<ContentItem | null> {
    try {
        if (DEV_MODE) {
            return MOCK_CONTENT.find(c => c.id === id) || null;
        }

        const docRef = doc(db, "content", id);
        const docSnap = await getDoc(docRef);

        if (docSnap.exists()) {
            const data = docSnap.data();
            return {
                id: docSnap.id,
                ...data,
                createdAt: data.createdAt?.toDate() || new Date(),
                updatedAt: data.updatedAt?.toDate() || new Date(),
                publishedAt: data.publishedAt?.toDate()
            } as ContentItem;
        }

        return null;
    } catch (error) {
        console.error('Error fetching content by ID:', error);
        throw error;
    }
}

// Create new content
export async function createContent(data: Omit<ContentItem, 'id' | 'createdAt' | 'updatedAt'>): Promise<string> {
    try {
        if (DEV_MODE) {
            const newContent: ContentItem = {
                ...data,
                id: Date.now().toString(),
                createdAt: new Date(),
                updatedAt: new Date()
            };
            MOCK_CONTENT.unshift(newContent);
            return newContent.id;
        }

        const docRef = await addDoc(collection(db, "content"), {
            ...data,
            createdAt: serverTimestamp(),
            updatedAt: serverTimestamp()
        });

        // Log the action
        await logAction('content_created', {
            contentId: docRef.id,
            title: data.title,
            type: data.type,
            authorId: data.authorId
        });

        return docRef.id;
    } catch (error) {
        console.error('Error creating content:', error);
        throw error;
    }
}

// Update content
export async function updateContent(id: string, data: Partial<ContentItem>): Promise<void> {
    try {
        if (DEV_MODE) {
            const contentIndex = MOCK_CONTENT.findIndex(c => c.id === id);
            if (contentIndex > -1) {
                MOCK_CONTENT[contentIndex] = {
                    ...MOCK_CONTENT[contentIndex],
                    ...data,
                    updatedAt: new Date()
                };
            }
            return;
        }

        const contentRef = doc(db, "content", id);
        await updateDoc(contentRef, {
            ...data,
            updatedAt: serverTimestamp()
        });

        // Log the action
        await logAction('content_updated', {
            contentId: id,
            title: data.title,
            type: data.type
        });
    } catch (error) {
        console.error('Error updating content:', error);
        throw error;
    }
}

// Delete content
export async function deleteContent(id: string): Promise<void> {
    try {
        if (DEV_MODE) {
            const contentIndex = MOCK_CONTENT.findIndex(c => c.id === id);
            if (contentIndex > -1) {
                MOCK_CONTENT.splice(contentIndex, 1);
            }
            return;
        }

        const contentRef = doc(db, "content", id);
        await deleteDoc(contentRef);

        // Log the action
        await logAction('content_deleted', {
            contentId: id
        });
    } catch (error) {
        console.error('Error deleting content:', error);
        throw error;
    }
}

// Upload media file
export async function uploadMedia(
    file: File,
    metadata: {
        uploadedBy: string;
        uploadedByEmail?: string;
        altText?: string;
        caption?: string;
        tags?: string[];
    }
): Promise<MediaAsset> {
    try {
        if (DEV_MODE) {
            // Simulate upload delay
            await new Promise(resolve => setTimeout(resolve, 1000));
            
            const newMedia: MediaAsset = {
                id: Date.now().toString(),
                fileName: file.name,
                originalName: file.name,
                url: URL.createObjectURL(file), // Mock URL
                size: file.size,
                mimeType: file.type,
                uploadedBy: metadata.uploadedBy,
                uploadedByEmail: metadata.uploadedByEmail,
                createdAt: new Date(),
                altText: metadata.altText,
                caption: metadata.caption,
                tags: metadata.tags
            };
            
            MOCK_MEDIA.unshift(newMedia);
            return newMedia;
        }

        // Create a unique filename
        const timestamp = Date.now();
        const fileName = `${timestamp}-${file.name}`;
        const storageRef = ref(storage, `media/${fileName}`);

        // Upload file
        const snapshot = await uploadBytes(storageRef, file);
        const downloadURL = await getDownloadURL(snapshot.ref);

        // Save metadata to Firestore
        const mediaData = {
            fileName,
            originalName: file.name,
            url: downloadURL,
            size: file.size,
            mimeType: file.type,
            uploadedBy: metadata.uploadedBy,
            uploadedByEmail: metadata.uploadedByEmail,
            createdAt: serverTimestamp(),
            altText: metadata.altText,
            caption: metadata.caption,
            tags: metadata.tags || []
        };

        const docRef = await addDoc(collection(db, "media_assets"), mediaData);

        return {
            id: docRef.id,
            ...mediaData,
            createdAt: new Date()
        } as MediaAsset;
    } catch (error) {
        console.error('Error uploading media:', error);
        throw error;
    }
}

// Get media assets
export async function getMediaAssets(limitCount: number = 50): Promise<MediaAsset[]> {
    try {
        if (DEV_MODE) {
            return MOCK_MEDIA.slice(0, limitCount);
        }

        const mediaQuery = query(
            collection(db, "media_assets"),
            orderBy("createdAt", "desc"),
            limit(limitCount)
        );
        
        const mediaSnapshot = await getDocs(mediaQuery);
        const media = mediaSnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            createdAt: doc.data().createdAt?.toDate() || new Date()
        })) as MediaAsset[];

        return media;
    } catch (error) {
        console.error('Error fetching media assets:', error);
        throw error;
    }
}

// Delete media asset
export async function deleteMediaAsset(id: string): Promise<void> {
    try {
        if (DEV_MODE) {
            const mediaIndex = MOCK_MEDIA.findIndex(m => m.id === id);
            if (mediaIndex > -1) {
                MOCK_MEDIA.splice(mediaIndex, 1);
            }
            return;
        }

        // Get media info first
        const mediaRef = doc(db, "media_assets", id);
        const mediaSnap = await getDoc(mediaRef);
        
        if (mediaSnap.exists()) {
            const mediaData = mediaSnap.data();
            
            // Delete from Storage
            const storageRef = ref(storage, `media/${mediaData.fileName}`);
            await deleteObject(storageRef);
            
            // Delete from Firestore
            await deleteDoc(mediaRef);
        }
    } catch (error) {
        console.error('Error deleting media asset:', error);
        throw error;
    }
}

// Get content statistics
export async function getContentStats(): Promise<{
    total: number;
    published: number;
    draft: number;
    archived: number;
    byType: { [key: string]: number };
    byStatus: { [key: string]: number };
    today: number;
    thisWeek: number;
    thisMonth: number;
}> {
    try {
        if (DEV_MODE) {
            const now = new Date();
            const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
            const thisWeek = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
            const thisMonth = new Date(now.getFullYear(), now.getMonth(), 1);

            const todayContent = MOCK_CONTENT.filter(c => c.createdAt >= today);
            const thisWeekContent = MOCK_CONTENT.filter(c => c.createdAt >= thisWeek);
            const thisMonthContent = MOCK_CONTENT.filter(c => c.createdAt >= thisMonth);

            const byType = MOCK_CONTENT.reduce((acc, c) => {
                acc[c.type] = (acc[c.type] || 0) + 1;
                return acc;
            }, {} as { [key: string]: number });

            const byStatus = MOCK_CONTENT.reduce((acc, c) => {
                acc[c.status] = (acc[c.status] || 0) + 1;
                return acc;
            }, {} as { [key: string]: number });

            return {
                total: MOCK_CONTENT.length,
                published: MOCK_CONTENT.filter(c => c.status === 'published').length,
                draft: MOCK_CONTENT.filter(c => c.status === 'draft').length,
                archived: MOCK_CONTENT.filter(c => c.status === 'archived').length,
                byType,
                byStatus,
                today: todayContent.length,
                thisWeek: thisWeekContent.length,
                thisMonth: thisMonthContent.length
            };
        }

        // Real implementation would query Firestore for statistics
        const contentSnapshot = await getDocs(collection(db, "content"));
        const content = contentSnapshot.docs.map(doc => ({
            ...doc.data(),
            createdAt: doc.data().createdAt?.toDate() || new Date(),
        })) as ContentItem[];

        const now = new Date();
        const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        const thisWeek = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
        const thisMonth = new Date(now.getFullYear(), now.getMonth(), 1);

        const todayContent = content.filter(c => c.createdAt >= today);
        const thisWeekContent = content.filter(c => c.createdAt >= thisWeek);
        const thisMonthContent = content.filter(c => c.createdAt >= thisMonth);

        const byType = content.reduce((acc, c) => {
            acc[c.type] = (acc[c.type] || 0) + 1;
            return acc;
        }, {} as { [key: string]: number });

        const byStatus = content.reduce((acc, c) => {
            acc[c.status] = (acc[c.status] || 0) + 1;
            return acc;
        }, {} as { [key: string]: number });

        return {
            total: content.length,
            published: content.filter(c => c.status === 'published').length,
            draft: content.filter(c => c.status === 'draft').length,
            archived: content.filter(c => c.status === 'archived').length,
            byType,
            byStatus,
            today: todayContent.length,
            thisWeek: thisWeekContent.length,
            thisMonth: thisMonthContent.length
        };
    } catch (error) {
        console.error('Error getting content stats:', error);
        throw error;
    }
}

// Log action for audit trail
async function logAction(action: string, metadata: any): Promise<void> {
    try {
        if (!DEV_MODE) {
            await addDoc(collection(db, "system_logs"), {
                action,
                metadata,
                timestamp: serverTimestamp(),
                type: 'content'
            });
        }
    } catch (error) {
        console.error('Error logging action:', error);
    }
}





