'use client';
import ConversationalFlow from '@/components/convo/ConversationalFlow';
import { Meeting } from '@/types/meeting';
import { useParams } from 'next/navigation';

export default function CreateMeeting() {
    const { locale } = useParams<{ locale: string }>();

    const handleMeetingComplete = (meeting: Meeting) => {
        console.log('Meeting created:', meeting);
        // Additional logic can be added here if needed
    };

    return (
        <div className="min-h-screen bg-gray-50">
            <ConversationalFlow
                locale={locale as string}
                onComplete={handleMeetingComplete}
            />
        </div>
    );
}


