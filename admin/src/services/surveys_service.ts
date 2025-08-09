import { db } from "@/lib/firebase";
import { collection, doc, getDoc, getDocs, addDoc, updateDoc, deleteDoc, query, orderBy, serverTimestamp } from "firebase/firestore";

const DEV_MODE = !process.env.NEXT_PUBLIC_FIREBASE_API_KEY;

export interface SurveyQuestion {
    id: string;
    type: 'short_text' | 'long_text' | 'single_choice' | 'multi_choice' | 'scale' | 'date' | 'yes_no';
    title: string;
    description?: string;
    required: boolean;
    options?: string[];
    scale?: { min: number; max: number };
    order: number;
}

export interface Survey {
    id: string;
    title: string;
    description?: string;
    status: 'draft' | 'active' | 'closed';
    createdBy: string;
    createdAt: Date;
    updatedAt: Date;
    questions: SurveyQuestion[];
    slug: string;
    tags: string[];
}

export interface SurveyResponse {
    id: string;
    surveyId: string;
    userId?: string;
    submittedAt: Date;
    answers: { questionId: string; value: string | string[] | number }[];
    source: 'email' | 'link' | 'in-app';
}

// Mock data
const MOCK_SURVEYS: Survey[] = [
    {
        id: '1',
        title: 'NPS August 2024',
        description: 'Net Promoter Score survey',
        status: 'active',
        createdBy: 'admin-1',
        createdAt: new Date(),
        updatedAt: new Date(),
        questions: [
            {
                id: 'q1',
                type: 'scale',
                title: 'How likely are you to recommend App-Oint?',
                required: true,
                scale: { min: 0, max: 10 },
                order: 1
            }
        ],
        slug: 'nps-august-2024',
        tags: ['nps', 'feedback']
    }
];

export async function listSurveys(): Promise<Survey[]> {
    if (DEV_MODE) return MOCK_SURVEYS;
    
    const snapshot = await getDocs(query(collection(db, "surveys"), orderBy("createdAt", "desc")));
    return snapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data(),
        createdAt: doc.data().createdAt?.toDate() || new Date(),
        updatedAt: doc.data().updatedAt?.toDate() || new Date()
    })) as Survey[];
}

export async function getSurvey(id: string): Promise<Survey | null> {
    if (DEV_MODE) return MOCK_SURVEYS.find(s => s.id === id) || null;
    
    const docRef = doc(db, "surveys", id);
    const docSnap = await getDoc(docRef);
    
    if (docSnap.exists()) {
        const data = docSnap.data();
        return {
            id: docSnap.id,
            ...data,
            createdAt: data.createdAt?.toDate() || new Date(),
            updatedAt: data.updatedAt?.toDate() || new Date()
        } as Survey;
    }
    return null;
}

export async function createSurvey(data: Omit<Survey, 'id' | 'createdAt' | 'updatedAt'>): Promise<string> {
    if (DEV_MODE) {
        const newSurvey: Survey = {
            ...data,
            id: Date.now().toString(),
            createdAt: new Date(),
            updatedAt: new Date()
        };
        MOCK_SURVEYS.unshift(newSurvey);
        return newSurvey.id;
    }
    
    const docRef = await addDoc(collection(db, "surveys"), {
        ...data,
        createdAt: serverTimestamp(),
        updatedAt: serverTimestamp()
    });
    return docRef.id;
}

export async function updateSurvey(id: string, data: Partial<Survey>): Promise<void> {
    if (DEV_MODE) {
        const index = MOCK_SURVEYS.findIndex(s => s.id === id);
        if (index > -1) {
            MOCK_SURVEYS[index] = { ...MOCK_SURVEYS[index], ...data, updatedAt: new Date() };
        }
        return;
    }
    
    const surveyRef = doc(db, "surveys", id);
    await updateDoc(surveyRef, { ...data, updatedAt: serverTimestamp() });
}

export async function deleteSurvey(id: string): Promise<void> {
    if (DEV_MODE) {
        const index = MOCK_SURVEYS.findIndex(s => s.id === id);
        if (index > -1) MOCK_SURVEYS.splice(index, 1);
        return;
    }
    
    const surveyRef = doc(db, "surveys", id);
    await deleteDoc(surveyRef);
}

export async function publishSurvey(id: string): Promise<void> {
    await updateSurvey(id, { status: 'active' });
}

export async function closeSurvey(id: string): Promise<void> {
    await updateSurvey(id, { status: 'closed' });
}
