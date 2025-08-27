'use client';

import { useState } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { upsertMeeting } from '@/lib/localStore';
import { Meeting, MeetingType } from '@/types/meeting';
import ConversationalFlow from '@/components/convo/ConversationalFlow';
import QuestionCard from '@/components/convo/QuestionCard';
import ChoiceCard from '@/components/convo/ChoiceCard';
import ParticipantSelector from '@/components/convo/ParticipantSelector';
import LocationSelector from '@/components/convo/LocationSelector';
import DateTimeSelector from '@/components/convo/DateTimeSelector';
import NotesChecklist from '@/components/convo/NotesChecklist';
import SummaryCard, { SummaryRow } from '@/components/convo/SummaryCard';

interface MeetingData {
  type: MeetingType;
  participants: Array<{ id: string; name: string; email?: string }>;
  dateTime: { date: string; time: string } | null;
  location: { type: 'physical' | 'virtual' | 'business'; value: string; details?: any } | null;
  notes: string;
  checklist: Array<{ id: string; text: string; completed: boolean }>;
}

export default function CreateMeeting() {
  const { locale } = useParams<{ locale: string }>();
  const router = useRouter();
  const [meetingData, setMeetingData] = useState<MeetingData>({
    type: 'personal',
    participants: [],
    dateTime: null,
    location: null,
    notes: '',
    checklist: []
  });

  const [isPremium] = useState(false); // Mock premium status - in real app this would come from user profile

  const updateMeetingData = (updates: Partial<MeetingData>) => {
    setMeetingData(prev => ({ ...prev, ...updates }));
  };

  const handleComplete = () => {
    if (!meetingData.dateTime || !meetingData.location) return;

    const meeting: Meeting = {
      id: 'meeting-' + Math.random().toString(36).slice(2, 9),
      title: `${meetingData.type} meeting`,
      type: meetingData.type,
      details: {
        date: meetingData.dateTime.date,
        time: meetingData.dateTime.time,
        location: meetingData.location.value,
        platform: meetingData.location.type === 'virtual' ? meetingData.location.details?.platform || '' : ''
      },
      participants: meetingData.participants.map((p, i) => ({ 
        id: p.id || `p${i}`, 
        name: p.name, 
        status: 'pending' as const 
      })),
      externalLink: meetingData.location.type === 'virtual' ? meetingData.location.details?.link || '' : '',
      messages: []
    };

    upsertMeeting(meeting);
    
    // Redirect to the new meeting
    router.push(`/${locale}/meetings/${meeting.id}`);
  };

  const steps = [
    {
      id: 'type',
      title: 'What kind of meeting do you want to create?',
      subtitle: 'Choose the type that best fits your needs',
      content: (
        <QuestionCard title="Meeting Type" subtitle="Select the category that matches your meeting">
          <div className="grid grid-cols-2 gap-3">
            {[
              { type: 'personal' as MeetingType, emoji: '👤', title: 'Personal Meeting', subtitle: '1:1 conversation' },
              { type: 'group' as MeetingType, emoji: '👥', title: 'Group Meeting', subtitle: 'Team or event' },
              { type: 'virtual' as MeetingType, emoji: '💻', title: 'Virtual Meeting', subtitle: 'Online or call' },
              { type: 'business' as MeetingType, emoji: '🏢', title: 'With a Business', subtitle: 'Company meeting' },
              { type: 'playtime' as MeetingType, emoji: '🎮', title: 'Playtime', subtitle: 'Games & activities' },
              { type: 'opencall' as MeetingType, emoji: '📢', title: 'Open Call', subtitle: 'Public invitation' }
            ].map(({ type, emoji, title, subtitle }) => (
              <ChoiceCard
                key={type}
                emoji={emoji}
                title={title}
                subtitle={subtitle}
                onClick={() => updateMeetingData({ type })}
                className={meetingData.type === type ? 'border-blue-500 bg-blue-50' : ''}
              />
            ))}
          </div>
        </QuestionCard>
      ),
      canGoNext: !!meetingData.type
    },
    {
      id: 'participants',
      title: 'Who would you like to meet with?',
      subtitle: 'Add participants to your meeting',
      content: (
        <QuestionCard title="Participants" subtitle="Search contacts or add new people">
          <ParticipantSelector
            participants={meetingData.participants}
            onParticipantsChange={(participants) => updateMeetingData({ participants })}
          />
        </QuestionCard>
      ),
      canGoNext: meetingData.participants.length > 0
    },
    {
      id: 'datetime',
      title: 'When would you like to meet?',
      subtitle: 'Choose a date and time that works for everyone',
      content: (
        <QuestionCard title="Date & Time" subtitle="Smart suggestions based on your availability">
          <DateTimeSelector
            dateTime={meetingData.dateTime}
            onDateTimeChange={(dateTime) => updateMeetingData({ dateTime })}
          />
        </QuestionCard>
      ),
      canGoNext: !!meetingData.dateTime
    },
    {
      id: 'location',
      title: 'Where will the meeting take place?',
      subtitle: 'Physical location, virtual platform, or business venue',
      content: (
        <QuestionCard title="Location" subtitle="Choose the meeting venue or platform">
          <LocationSelector
            location={meetingData.location}
            onLocationChange={(location) => updateMeetingData({ location })}
          />
        </QuestionCard>
      ),
      canGoNext: !!meetingData.location
    },
    {
      id: 'notes',
      title: 'Any notes or checklist items?',
      subtitle: 'Add agenda items, reminders, or important details',
      content: (
        <QuestionCard title="Notes & Checklist" subtitle="Keep track of what needs to be discussed">
          <NotesChecklist
            notes={meetingData.notes}
            checklist={meetingData.checklist}
            onNotesChange={(notes) => updateMeetingData({ notes })}
            onChecklistChange={(checklist) => updateMeetingData({ checklist })}
          />
        </QuestionCard>
      ),
      canGoNext: true
    },
    {
      id: 'review',
      title: 'Review your meeting',
      subtitle: 'Everything looks good? Let\'s confirm the details',
      content: (
        <QuestionCard title="Meeting Summary" subtitle="Review all the details before confirming">
          <SummaryCard title="Meeting Details">
            <SummaryRow label="Type" value={meetingData.type} />
            <SummaryRow 
              label="Participants" 
              value={`${meetingData.participants.length} people: ${meetingData.participants.map(p => p.name).join(', ')}`} 
            />
            <SummaryRow 
              label="Date & Time" 
              value={meetingData.dateTime ? `${meetingData.dateTime.date} at ${meetingData.dateTime.time}` : 'Not set'} 
            />
            <SummaryRow 
              label="Location" 
              value={meetingData.location ? `${meetingData.location.value} (${meetingData.location.type})` : 'Not set'} 
            />
            {meetingData.notes && (
              <SummaryRow label="Notes" value={meetingData.notes} />
            )}
            {meetingData.checklist.length > 0 && (
              <SummaryRow 
                label="Checklist" 
                value={`${meetingData.checklist.length} items`} 
              />
            )}
          </SummaryCard>

          {/* Premium vs Free Flow */}
          {isPremium ? (
            <div className="p-4 bg-green-50 border border-green-200 rounded-xl">
              <div className="text-green-800 font-medium">Premium User</div>
              <div className="text-green-600 text-sm">Your meeting will be saved instantly!</div>
            </div>
          ) : (
            <div className="p-4 bg-orange-50 border border-orange-200 rounded-xl">
              <div className="text-orange-800 font-medium">Free User</div>
              <div className="text-orange-600 text-sm">A short ad will be shown before saving your meeting.</div>
            </div>
          )}
        </QuestionCard>
      ),
      canGoNext: true
    }
  ];

  return (
    <main className="mx-auto max-w-screen-sm px-4 pb-24 pt-8">
      <ConversationalFlow
        steps={steps}
        onComplete={handleComplete}
      />
    </main>
  );
}

