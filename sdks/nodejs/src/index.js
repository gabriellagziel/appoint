"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppOintRegistry = exports.AppOintAPI = exports.AppOintAPIError = void 0;
const axios_1 = __importDefault(require("axios"));
class AppOintAPIError extends Error {
    constructor(message, status, code) {
        super(message);
        this.name = 'AppOintAPIError';
        this.status = status;
        this.code = code;
    }
}
exports.AppOintAPIError = AppOintAPIError;
class AppOintAPI {
    constructor(config) {
        /**
         * Appointments API
         */
        this.appointments = {
            /**
             * Create a new appointment
             */
            create: async (request) => {
                const response = await this.client.post('/businessApi/appointments/create', request);
                return response.data;
            },
            /**
             * Cancel an existing appointment
             */
            cancel: async (request) => {
                const response = await this.client.post('/businessApi/appointments/cancel', request);
                return response.data;
            },
            /**
             * List appointments with optional filtering
             */
            list: async (options = {}) => {
                const params = new URLSearchParams();
                if (options.start)
                    params.append('start', options.start);
                if (options.end)
                    params.append('end', options.end);
                if (options.status)
                    params.append('status', options.status);
                if (options.limit)
                    params.append('limit', options.limit.toString());
                const response = await this.client.get(`/businessApi/appointments?${params.toString()}`);
                return response.data;
            },
            /**
             * Get a specific appointment by ID
             */
            get: async (appointmentId) => {
                const response = await this.client.get(`/businessApi/appointments/${appointmentId}`);
                return response.data;
            },
        };
        /**
         * Analytics API
         */
        this.analytics = {
            /**
             * Get usage statistics
             */
            getUsageStats: async (month, year) => {
                const params = new URLSearchParams();
                if (month)
                    params.append('month', month.toString());
                if (year)
                    params.append('year', year.toString());
                const response = await this.client.get(`/getUsageStats?${params.toString()}`);
                return response.data;
            },
            /**
             * Download usage data as CSV
             */
            downloadUsageCSV: async (month, year) => {
                const params = new URLSearchParams();
                if (month)
                    params.append('month', month.toString());
                if (year)
                    params.append('year', year.toString());
                const response = await this.client.get(`/downloadUsageCSV?${params.toString()}`, {
                    responseType: 'text'
                });
                return response.data;
            },
        };
        /**
         * Calendar API
         */
        this.calendar = {
            /**
             * Get ICS calendar feed URL
             */
            getIcsFeedUrl: (token) => {
                return `${this.client.defaults.baseURL}/icsFeed?token=${token}`;
            },
            /**
             * Rotate ICS access token
             */
            rotateIcsToken: async () => {
                const response = await this.client.post('/rotateIcsToken');
                return response.data;
            },
        };
        /**
         * Utility methods
         */
        this.utils = {
            /**
             * Validate appointment time format
             */
            validateAppointmentTime: (start, duration) => {
                try {
                    const startDate = new Date(start);
                    return !isNaN(startDate.getTime()) && duration > 0 && duration <= 1440; // Max 24 hours
                }
                catch {
                    return false;
                }
            },
            /**
             * Calculate appointment end time
             */
            calculateEndTime: (start, duration) => {
                const startDate = new Date(start);
                const endDate = new Date(startDate.getTime() + (duration * 60000));
                return endDate.toISOString();
            },
            /**
             * Format appointment for display
             */
            formatAppointment: (appointment) => {
                const start = new Date(appointment.start);
                const end = new Date(appointment.end);
                return `${appointment.customerName} - ${start.toLocaleString()} to ${end.toLocaleString()} (${appointment.duration}min)`;
            },
        };
        this.client = axios_1.default.create({
            baseURL: config.baseURL || 'https://us-central1-app-oint-core.cloudfunctions.net',
            timeout: config.timeout || 30000,
            headers: {
                'X-API-Key': config.apiKey,
                'Content-Type': 'application/json',
                'User-Agent': `app-oint-nodejs-sdk/1.0.0`,
            },
        });
        // Response interceptor for error handling
        this.client.interceptors.response.use((response) => response, (error) => {
            if (error.response) {
                const { status, data } = error.response;
                const message = data?.error || error.message;
                const code = data?.code;
                throw new AppOintAPIError(message, status, code);
            }
            throw new AppOintAPIError(error.message, 0);
        });
    }
}
exports.AppOintAPI = AppOintAPI;
/**
 * Static methods for business registration
 */
class AppOintRegistry {
    /**
     * Register a new business account
     */
    static async registerBusiness(request) {
        try {
            const response = await axios_1.default.post(`${this.baseURL}/registerBusiness`, request, {
                headers: {
                    'Content-Type': 'application/json',
                    'User-Agent': 'app-oint-nodejs-sdk/1.0.0',
                },
                timeout: 30000,
            });
            return response.data;
        }
        catch (error) {
            if (axios_1.default.isAxiosError(error) && error.response) {
                const { status, data } = error.response;
                const message = data?.error || error.message;
                throw new AppOintAPIError(message, status);
            }
            throw new AppOintAPIError(error.message, 0);
        }
    }
}
exports.AppOintRegistry = AppOintRegistry;
AppOintRegistry.baseURL = 'https://us-central1-app-oint-core.cloudfunctions.net';
// Export everything
exports.default = AppOintAPI;
