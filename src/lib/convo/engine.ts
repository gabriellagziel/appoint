export interface ConvoStep {
    id: string;
    type: 'question' | 'choice' | 'input' | 'summary' | 'confirmation';
    title: string;
    description?: string;
    options?: ConvoOption[];
    fields?: ConvoField[];
    validation?: (data: any) => boolean | string;
    next?: string | ((data: any) => string);
}

export interface ConvoOption {
    id: string;
    label: string;
    value: any;
    icon?: string;
    description?: string;
}

export interface ConvoField {
    id: string;
    type: 'text' | 'email' | 'date' | 'time' | 'select' | 'multiselect' | 'textarea';
    label: string;
    placeholder?: string;
    required?: boolean;
    options?: ConvoOption[];
    validation?: (value: any) => boolean | string;
}

export interface ConvoFlow {
    id: string;
    steps: ConvoStep[];
    initialState: any;
    onComplete?: (data: any) => void;
}

export class ConvoEngine {
    private flow: ConvoFlow;
    private currentStepIndex: number = 0;
    private data: any;
    private history: string[] = [];

    constructor(flow: ConvoFlow) {
        this.flow = flow;
        this.data = { ...flow.initialState };
    }

    getCurrentStep(): ConvoStep {
        return this.flow.steps[this.currentStepIndex];
    }

    getProgress(): { current: number; total: number; percentage: number } {
        return {
            current: this.currentStepIndex + 1,
            total: this.flow.steps.length,
            percentage: Math.round(((this.currentStepIndex + 1) / this.flow.steps.length) * 100)
        };
    }

    canGoNext(): boolean {
        const currentStep = this.getCurrentStep();
        if (currentStep.type === 'confirmation') return true;

        // Check if required fields are filled
        if (currentStep.fields) {
            return currentStep.fields.every(field => {
                if (!field.required) return true;
                const value = this.data[field.id];
                return value !== undefined && value !== null && value !== '';
            });
        }

        return true;
    }

    canGoBack(): boolean {
        return this.currentStepIndex > 0;
    }

    goNext(): boolean {
        if (!this.canGoNext()) return false;

        const currentStep = this.getCurrentStep();
        this.history.push(currentStep.id);

        if (this.currentStepIndex >= this.flow.steps.length - 1) {
            // Flow complete
            if (this.flow.onComplete) {
                this.flow.onComplete(this.data);
            }
            return false;
        }

        this.currentStepIndex++;
        return true;
    }

    goBack(): boolean {
        if (!this.canGoBack()) return false;

        this.currentStepIndex--;
        this.history.pop();
        return true;
    }

    updateData(fieldId: string, value: any): void {
        this.data[fieldId] = value;
    }

    getData(): any {
        return { ...this.data };
    }

    getHistory(): string[] {
        return [...this.history];
    }

    reset(): void {
        this.currentStepIndex = 0;
        this.data = { ...this.flow.initialState };
        this.history = [];
    }
}

// Predefined flows
export const MEETING_CREATION_FLOW: ConvoFlow = {
    id: 'meeting-creation',
    steps: [
        {
            id: 'meeting-type',
            type: 'choice',
            title: 'What kind of meeting do you want to create?',
            description: 'Choose the type that best fits your needs',
            options: [
                { id: 'personal', label: '👤 Personal 1:1', value: 'personal', description: 'One-on-one meeting with someone' },
                { id: 'group', label: '👥 Group / Event', value: 'group', description: 'Meeting with multiple people' },
                { id: 'virtual', label: '💻 Virtual', value: 'virtual', description: 'Online meeting or call' },
                { id: 'business', label: '🏢 With a Business', value: 'business', description: 'Meeting with a company or service' },
                { id: 'playtime', label: '🎮 Playtime', value: 'playtime', description: 'Fun activity or game session' },
                { id: 'opencall', label: '📢 Open Call', value: 'opencall', description: 'Public or open invitation meeting' }
            ]
        },
        {
            id: 'participants',
            type: 'input',
            title: 'Who would you like to meet with?',
            description: 'Add participants to your meeting',
            fields: [
                {
                    id: 'participants',
                    type: 'multiselect',
                    label: 'Participants',
                    placeholder: 'Search and add people...',
                    required: true,
                    options: []
                }
            ]
        },
        {
            id: 'details',
            type: 'input',
            title: 'When and where?',
            description: 'Set the time, date, and location for your meeting',
            fields: [
                {
                    id: 'date',
                    type: 'date',
                    label: 'Date',
                    required: true
                },
                {
                    id: 'time',
                    type: 'time',
                    label: 'Time',
                    required: true
                },
                {
                    id: 'location',
                    type: 'text',
                    label: 'Location or Platform',
                    placeholder: 'Physical address, Zoom, Meet, or Phone',
                    required: true
                },
                {
                    id: 'notes',
                    type: 'textarea',
                    label: 'Additional Notes',
                    placeholder: 'Any special requirements or agenda items...'
                }
            ]
        },
        {
            id: 'review',
            type: 'summary',
            title: 'Review Your Meeting',
            description: 'Please review the details before confirming'
        },
        {
            id: 'confirmation',
            type: 'confirmation',
            title: 'Meeting Created Successfully!',
            description: 'Your meeting has been saved and is ready to go'
        }
    ],
    initialState: {
        meetingType: '',
        participants: [],
        date: '',
        time: '',
        location: '',
        notes: ''
    }
};


