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
    type: 'text' | 'textarea' | 'select' | 'date' | 'time' | 'number';
    label: string;
    placeholder?: string;
    required?: boolean;
    options?: { label: string; value: any }[];
    validation?: (value: any) => boolean | string;
}

export interface ConvoFlow {
    id: string;
    steps: ConvoStep[];
    initialState: any;
}

export class ConvoEngine {
    private flow: ConvoFlow;
    private currentStepIndex: number = 0;
    private data: any;

    constructor(flow: ConvoFlow) {
        this.flow = flow;
        this.data = { ...flow.initialState };
    }

    getCurrentStep(): ConvoStep | null {
        if (this.currentStepIndex >= this.flow.steps.length) {
            return null;
        }
        return this.flow.steps[this.currentStepIndex];
    }

    getProgress(): number {
        return (this.currentStepIndex / this.flow.steps.length) * 100;
    }

    getData(): any {
        return { ...this.data };
    }

    updateData(updates: any): void {
        this.data = { ...this.data, ...updates };
    }

    nextStep(stepData?: any): ConvoStep | null {
        if (stepData) {
            this.updateData(stepData);
        }

        const currentStep = this.getCurrentStep();
        if (!currentStep) return null;

        // Validate current step if validation exists
        if (currentStep.validation) {
            const validationResult = currentStep.validation(this.data);
            if (validationResult !== true) {
                throw new Error(typeof validationResult === 'string' ? validationResult : 'Validation failed');
            }
        }

        // Determine next step
        let nextStepId: string;
        if (typeof currentStep.next === 'function') {
            nextStepId = currentStep.next(this.data);
        } else if (typeof currentStep.next === 'string') {
            nextStepId = currentStep.next;
        } else {
            nextStepId = this.flow.steps[this.currentStepIndex + 1]?.id || '';
        }

        // Find next step index
        const nextIndex = this.flow.steps.findIndex(step => step.id === nextStepId);
        if (nextIndex === -1) {
            this.currentStepIndex = this.flow.steps.length; // End of flow
            return null;
        }

        this.currentStepIndex = nextIndex;
        return this.getCurrentStep();
    }

    previousStep(): ConvoStep | null {
        if (this.currentStepIndex <= 0) return null;
        this.currentStepIndex--;
        return this.getCurrentStep();
    }

    reset(): void {
        this.currentStepIndex = 0;
        this.data = { ...this.flow.initialState };
    }

    isComplete(): boolean {
        return this.currentStepIndex >= this.flow.steps.length;
    }
}

export const MEETING_CREATION_FLOW: ConvoFlow = {
    id: 'meeting-creation',
    steps: [
        {
            id: 'meeting-type',
            type: 'choice',
            title: 'What type of meeting would you like to create?',
            description: 'Choose the meeting type that best fits your needs',
            options: [
                { id: 'personal', label: 'Personal 1:1', value: 'personal', icon: '👤' },
                { id: 'group', label: 'Group Meeting', value: 'group', icon: '👥' },
                { id: 'virtual', label: 'Virtual Meeting', value: 'virtual', icon: '💻' },
                { id: 'business', label: 'With a Business', value: 'business', icon: '🏢' },
                { id: 'playtime', label: 'Playtime', value: 'playtime', icon: '🎮' },
                { id: 'open-call', label: 'Open Call', value: 'open-call', icon: '📞' }
            ]
        },
        {
            id: 'participants',
            type: 'question',
            title: 'Who would you like to meet with?',
            description: 'Add participants to your meeting',
            fields: [
                {
                    id: 'participant-count',
                    type: 'number',
                    label: 'Number of participants',
                    required: true,
                    validation: (value) => value > 0 || 'Must have at least 1 participant'
                }
            ]
        },
        {
            id: 'details',
            type: 'question',
            title: 'Meeting Details',
            description: 'Fill in the meeting details',
            fields: [
                {
                    id: 'title',
                    type: 'text',
                    label: 'Meeting Title',
                    placeholder: 'Enter meeting title',
                    required: true
                },
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
                    label: 'Location',
                    placeholder: 'Enter location or platform'
                },
                {
                    id: 'notes',
                    type: 'textarea',
                    label: 'Notes',
                    placeholder: 'Any additional notes...'
                }
            ]
        },
        {
            id: 'summary',
            type: 'summary',
            title: 'Review Your Meeting',
            description: 'Please review the details before confirming'
        },
        {
            id: 'confirmation',
            type: 'confirmation',
            title: 'Meeting Created!',
            description: 'Your meeting has been successfully created'
        }
    ],
    initialState: {
        meetingType: '',
        participants: [],
        title: '',
        date: '',
        time: '',
        location: '',
        notes: ''
    }
};
