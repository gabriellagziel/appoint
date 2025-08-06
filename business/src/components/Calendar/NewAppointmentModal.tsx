'use client'

import { useEffect, useState } from 'react'

interface NewAppointmentForm {
    title: string
    clientName: string
    clientEmail: string
    date: string
    time: string
    duration: number
    notes: string
    location: string
    serviceType: string
    staffMember: string
}

interface Client {
    id: string
    name: string
    email: string
    phone?: string
}

interface Service {
    id: string
    name: string
    duration: number
    price: number
}

interface Staff {
    id: string
    name: string
    role: string
    avatar?: string
}

interface NewAppointmentModalProps {
    isOpen: boolean
    onClose: () => void
    onAppointmentCreated: (appointment: any) => void
    prefillTime?: { date: string; time: string }
}

export default function NewAppointmentModal({
    isOpen,
    onClose,
    onAppointmentCreated,
    prefillTime
}: NewAppointmentModalProps) {
    const [formData, setFormData] = useState<NewAppointmentForm>({
        title: '',
        clientName: '',
        clientEmail: '',
        date: prefillTime?.date || new Date().toISOString().split('T')[0],
        time: prefillTime?.time || '09:00',
        duration: 60,
        notes: '',
        location: '',
        serviceType: '',
        staffMember: ''
    })
    const [isSubmitting, setIsSubmitting] = useState(false)
    const [showClientSearch, setShowClientSearch] = useState(false)
    const [clientSearchTerm, setClientSearchTerm] = useState('')
    const [filteredClients, setFilteredClients] = useState<Client[]>([])

    // Mock data
    const mockClients: Client[] = [
        { id: '1', name: 'John Smith', email: 'john@example.com', phone: '+1-555-0123' },
        { id: '2', name: 'Sarah Johnson', email: 'sarah@example.com', phone: '+1-555-0124' },
        { id: '3', name: 'Mike Davis', email: 'mike@example.com', phone: '+1-555-0125' },
        { id: '4', name: 'Emily Wilson', email: 'emily@example.com', phone: '+1-555-0126' },
        { id: '5', name: 'David Brown', email: 'david@example.com', phone: '+1-555-0127' }
    ]

    const mockServices: Service[] = [
        { id: '1', name: 'Consultation', duration: 60, price: 150 },
        { id: '2', name: 'Product Demo', duration: 90, price: 200 },
        { id: '3', name: 'Support Call', duration: 30, price: 75 },
        { id: '4', name: 'Training Session', duration: 120, price: 300 },
        { id: '5', name: 'Strategy Meeting', duration: 60, price: 180 }
    ]

    const mockStaff: Staff[] = [
        { id: '1', name: 'Alex Chen', role: 'Senior Consultant' },
        { id: '2', name: 'Maria Garcia', role: 'Product Specialist' },
        { id: '3', name: 'Tom Wilson', role: 'Support Engineer' },
        { id: '4', name: 'Lisa Park', role: 'Training Coordinator' }
    ]

    // Reset form when modal opens/closes
    useEffect(() => {
        if (isOpen) {
            setFormData({
                title: '',
                clientName: '',
                clientEmail: '',
                date: prefillTime?.date || new Date().toISOString().split('T')[0],
                time: prefillTime?.time || '09:00',
                duration: 60,
                notes: '',
                location: '',
                serviceType: '',
                staffMember: ''
            })
            setShowClientSearch(false)
            setClientSearchTerm('')
        }
    }, [isOpen, prefillTime])

    // Filter clients based on search term
    useEffect(() => {
        if (clientSearchTerm.trim()) {
            const filtered = mockClients.filter(client =>
                client.name.toLowerCase().includes(clientSearchTerm.toLowerCase()) ||
                client.email.toLowerCase().includes(clientSearchTerm.toLowerCase())
            )
            setFilteredClients(filtered)
        } else {
            setFilteredClients([])
        }
    }, [clientSearchTerm])

    const handleInputChange = (field: keyof NewAppointmentForm, value: string | number) => {
        setFormData(prev => ({ ...prev, [field]: value }))
    }

    const handleClientSelect = (client: Client) => {
        setFormData(prev => ({
            ...prev,
            clientName: client.name,
            clientEmail: client.email
        }))
        setShowClientSearch(false)
        setClientSearchTerm('')
    }

    const handleServiceSelect = (service: Service) => {
        setFormData(prev => ({
            ...prev,
            serviceType: service.name,
            duration: service.duration,
            title: service.name
        }))
    }

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault()
        setIsSubmitting(true)

        try {
            // Simulate API call
            await new Promise(resolve => setTimeout(resolve, 1000))

            // Create appointment object
            const newAppointment = {
                id: Date.now().toString(),
                title: formData.title,
                startTime: formData.time,
                endTime: calculateEndTime(formData.time, formData.duration),
                participants: [formData.clientName],
                status: 'confirmed' as const,
                location: formData.location,
                notes: formData.notes,
                date: formData.date,
                clientEmail: formData.clientEmail,
                duration: formData.duration,
                serviceType: formData.serviceType,
                staffMember: formData.staffMember
            }

            // Call the callback to update parent state
            onAppointmentCreated(newAppointment)

            // Close modal
            onClose()

            // Show success message (you can implement toast here)
            console.log('Appointment created successfully:', newAppointment)

        } catch (error) {
            console.error('Failed to create appointment:', error)
        } finally {
            setIsSubmitting(false)
        }
    }

    const calculateEndTime = (startTime: string, durationMinutes: number) => {
        const [hours, minutes] = startTime.split(':').map(Number)
        const startDate = new Date()
        startDate.setHours(hours, minutes, 0, 0)

        const endDate = new Date(startDate.getTime() + durationMinutes * 60000)
        return endDate.toTimeString().slice(0, 5)
    }

    if (!isOpen) return null

    return (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div className="bg-white rounded-xl shadow-xl max-w-4xl w-full mx-4 max-h-[90vh] overflow-y-auto">
                {/* Header */}
                <div className="p-6 border-b border-gray-200">
                    <div className="flex items-center justify-between">
                        <div>
                            <h2 className="text-xl font-semibold text-gray-900">Create New Appointment</h2>
                            <p className="text-sm text-gray-600 mt-1">Schedule a new appointment with your client</p>
                        </div>
                        <button
                            onClick={onClose}
                            className="text-gray-400 hover:text-gray-600 transition-colors"
                            aria-label="Close modal"
                        >
                            <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                            </svg>
                        </button>
                    </div>
                </div>

                {/* Form */}
                <form onSubmit={handleSubmit} className="p-6 space-y-6">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Appointment Title *
                            </label>
                            <input
                                type="text"
                                required
                                value={formData.title}
                                onChange={(e) => handleInputChange('title', e.target.value)}
                                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                                placeholder="e.g., Client Consultation"
                            />
                        </div>

                        <div className="relative">
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Client *
                            </label>
                            <div className="relative">
                                <input
                                    type="text"
                                    required
                                    value={formData.clientName}
                                    onChange={(e) => {
                                        handleInputChange('clientName', e.target.value)
                                        setClientSearchTerm(e.target.value)
                                        setShowClientSearch(true)
                                    }}
                                    onFocus={() => setShowClientSearch(true)}
                                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                                    placeholder="Search clients..."
                                />
                                {showClientSearch && filteredClients.length > 0 && (
                                    <div className="absolute z-10 w-full mt-1 bg-white border border-gray-300 rounded-lg shadow-lg max-h-60 overflow-y-auto">
                                        {filteredClients.map((client) => (
                                            <button
                                                key={client.id}
                                                type="button"
                                                onClick={() => handleClientSelect(client)}
                                                className="w-full px-4 py-2 text-left hover:bg-gray-100 border-b border-gray-100 last:border-b-0"
                                            >
                                                <div className="font-medium text-gray-900">{client.name}</div>
                                                <div className="text-sm text-gray-600">{client.email}</div>
                                            </button>
                                        ))}
                                    </div>
                                )}
                            </div>
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Client Email *
                            </label>
                            <input
                                type="email"
                                required
                                value={formData.clientEmail}
                                onChange={(e) => handleInputChange('clientEmail', e.target.value)}
                                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                                placeholder="john@example.com"
                            />
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Service Type
                            </label>
                            <select
                                value={formData.serviceType}
                                onChange={(e) => {
                                    const service = mockServices.find(s => s.name === e.target.value)
                                    if (service) {
                                        handleServiceSelect(service)
                                    } else {
                                        handleInputChange('serviceType', e.target.value)
                                    }
                                }}
                                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                            >
                                <option value="">Select a service</option>
                                {mockServices.map((service) => (
                                    <option key={service.id} value={service.name}>
                                        {service.name} ({service.duration}min - ${service.price})
                                    </option>
                                ))}
                            </select>
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Staff Member
                            </label>
                            <select
                                value={formData.staffMember}
                                onChange={(e) => handleInputChange('staffMember', e.target.value)}
                                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                            >
                                <option value="">Select staff member</option>
                                {mockStaff.map((staff) => (
                                    <option key={staff.id} value={staff.name}>
                                        {staff.name} - {staff.role}
                                    </option>
                                ))}
                            </select>
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Date *
                            </label>
                            <input
                                type="date"
                                required
                                value={formData.date}
                                onChange={(e) => handleInputChange('date', e.target.value)}
                                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                                aria-label="Appointment date"
                            />
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Time *
                            </label>
                            <input
                                type="time"
                                required
                                value={formData.time}
                                onChange={(e) => handleInputChange('time', e.target.value)}
                                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                                aria-label="Appointment time"
                            />
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Duration (minutes) *
                            </label>
                            <select
                                value={formData.duration}
                                onChange={(e) => handleInputChange('duration', parseInt(e.target.value))}
                                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                                aria-label="Appointment duration"
                            >
                                <option value={15}>15 minutes</option>
                                <option value={30}>30 minutes</option>
                                <option value={45}>45 minutes</option>
                                <option value={60}>1 hour</option>
                                <option value={90}>1.5 hours</option>
                                <option value={120}>2 hours</option>
                            </select>
                        </div>
                    </div>

                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-2">
                            Location
                        </label>
                        <input
                            type="text"
                            value={formData.location}
                            onChange={(e) => handleInputChange('location', e.target.value)}
                            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                            placeholder="e.g., Conference Room A, Zoom Meeting"
                        />
                    </div>

                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-2">
                            Notes
                        </label>
                        <textarea
                            rows={4}
                            value={formData.notes}
                            onChange={(e) => handleInputChange('notes', e.target.value)}
                            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                            placeholder="Additional notes about the appointment..."
                        />
                    </div>

                    <div className="flex items-center justify-between pt-6 border-t border-gray-200">
                        <button
                            type="button"
                            onClick={onClose}
                            className="px-6 py-2 text-sm font-medium text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors"
                        >
                            Cancel
                        </button>
                        <button
                            type="submit"
                            disabled={isSubmitting}
                            className="px-6 py-2 text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed rounded-lg transition-colors"
                        >
                            {isSubmitting ? (
                                <div className="flex items-center space-x-2">
                                    <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
                                    <span>Creating...</span>
                                </div>
                            ) : (
                                'Create Appointment'
                            )}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    )
} 