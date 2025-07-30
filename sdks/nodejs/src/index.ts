import axios, { AxiosInstance, AxiosResponse, AxiosError } from 'axios';

export interface AppOintConfig {
  apiKey: string;
  baseURL?: string;
  timeout?: number;
}

export interface CreateAppointmentRequest {
  customerName: string;
  customerEmail?: string;
  start: string; // ISO 8601 date string
  duration: number; // minutes
  description?: string;
  location?: string;
}

export interface AppointmentResponse {
  appointmentId: string;
  status: 'confirmed' | 'cancelled' | 'completed';
  start: string;
  end: string;
  customerName: string;
  duration: number;
}

export interface CancelAppointmentRequest {
  appointmentId: string;
}

export interface CancelAppointmentResponse {
  cancelled: boolean;
  appointmentId: string;
  status: string;
  cancelledAt: string;
}

export interface ListAppointmentsOptions {
  start?: string;
  end?: string;
  status?: 'confirmed' | 'cancelled' | 'completed';
  limit?: number;
}

export interface AppointmentListResponse {
  appointments: AppointmentResponse[];
  count: number;
  hasMore: boolean;
}

export interface UsageStatsResponse {
  month: number;
  year: number;
  totalCalls: number;
  quota: number;
  remaining: number;
  endpoints: Record<string, number>;
}

export interface BusinessRegistrationRequest {
  name: string;
  email: string;
  industry?: string;
}

export interface BusinessRegistrationResponse {
  id: string;
  apiKey: string;
  quota: number;
  scopes: string[];
}

export class AppOintAPIError extends Error {
  public status: number;
  public code?: string;

  constructor(message: string, status: number, code?: string) {
    super(message);
    this.name = 'AppOintAPIError';
    this.status = status;
    this.code = code;
  }
}

export class AppOintAPI {
  private client: AxiosInstance;
  
  constructor(config: AppOintConfig) {
    this.client = axios.create({
      baseURL: config.baseURL || 'https://us-central1-app-oint-core.cloudfunctions.net',
      timeout: config.timeout || 30000,
      headers: {
        'X-API-Key': config.apiKey,
        'Content-Type': 'application/json',
        'User-Agent': `app-oint-nodejs-sdk/1.0.0`,
      },
    });

    // Response interceptor for error handling
    this.client.interceptors.response.use(
      (response: AxiosResponse) => response,
      (error: AxiosError) => {
        if (error.response) {
          const { status, data } = error.response;
          const message = (data as any)?.error || error.message;
          const code = (data as any)?.code;
          throw new AppOintAPIError(message, status, code);
        }
        throw new AppOintAPIError(error.message, 0);
      }
    );
  }

  /**
   * Appointments API
   */
  public appointments = {
    /**
     * Create a new appointment
     */
    create: async (request: CreateAppointmentRequest): Promise<AppointmentResponse> => {
      const response = await this.client.post('/businessApi/appointments/create', request);
      return response.data;
    },

    /**
     * Cancel an existing appointment
     */
    cancel: async (request: CancelAppointmentRequest): Promise<CancelAppointmentResponse> => {
      const response = await this.client.post('/businessApi/appointments/cancel', request);
      return response.data;
    },

    /**
     * List appointments with optional filtering
     */
    list: async (options: ListAppointmentsOptions = {}): Promise<AppointmentListResponse> => {
      const params = new URLSearchParams();
      if (options.start) params.append('start', options.start);
      if (options.end) params.append('end', options.end);
      if (options.status) params.append('status', options.status);
      if (options.limit) params.append('limit', options.limit.toString());

      const response = await this.client.get(`/businessApi/appointments?${params.toString()}`);
      return response.data;
    },

    /**
     * Get a specific appointment by ID
     */
    get: async (appointmentId: string): Promise<AppointmentResponse> => {
      const response = await this.client.get(`/businessApi/appointments/${appointmentId}`);
      return response.data;
    },
  };

  /**
   * Analytics API
   */
  public analytics = {
    /**
     * Get usage statistics
     */
    getUsageStats: async (month?: number, year?: number): Promise<UsageStatsResponse> => {
      const params = new URLSearchParams();
      if (month) params.append('month', month.toString());
      if (year) params.append('year', year.toString());

      const response = await this.client.get(`/getUsageStats?${params.toString()}`);
      return response.data;
    },

    /**
     * Download usage data as CSV
     */
    downloadUsageCSV: async (month?: number, year?: number): Promise<string> => {
      const params = new URLSearchParams();
      if (month) params.append('month', month.toString());
      if (year) params.append('year', year.toString());

      const response = await this.client.get(`/downloadUsageCSV?${params.toString()}`, {
        responseType: 'text'
      });
      return response.data;
    },
  };

  /**
   * Calendar API
   */
  public calendar = {
    /**
     * Get ICS calendar feed URL
     */
    getIcsFeedUrl: (token: string): string => {
      return `${this.client.defaults.baseURL}/icsFeed?token=${token}`;
    },

    /**
     * Rotate ICS access token
     */
    rotateIcsToken: async (): Promise<{ token: string }> => {
      const response = await this.client.post('/rotateIcsToken');
      return response.data;
    },
  };

  /**
   * Utility methods
   */
  public utils = {
    /**
     * Validate appointment time format
     */
    validateAppointmentTime: (start: string, duration: number): boolean => {
      try {
        const startDate = new Date(start);
        return !isNaN(startDate.getTime()) && duration > 0 && duration <= 1440; // Max 24 hours
      } catch {
        return false;
      }
    },

    /**
     * Calculate appointment end time
     */
    calculateEndTime: (start: string, duration: number): string => {
      const startDate = new Date(start);
      const endDate = new Date(startDate.getTime() + (duration * 60000));
      return endDate.toISOString();
    },

    /**
     * Format appointment for display
     */
    formatAppointment: (appointment: AppointmentResponse): string => {
      const start = new Date(appointment.start);
      const end = new Date(appointment.end);
      return `${appointment.customerName} - ${start.toLocaleString()} to ${end.toLocaleString()} (${appointment.duration}min)`;
    },
  };
}

/**
 * Static methods for business registration
 */
export class AppOintRegistry {
  private static baseURL = 'https://us-central1-app-oint-core.cloudfunctions.net';

  /**
   * Register a new business account
   */
  static async registerBusiness(request: BusinessRegistrationRequest): Promise<BusinessRegistrationResponse> {
    try {
      const response = await axios.post(`${this.baseURL}/registerBusiness`, request, {
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'app-oint-nodejs-sdk/1.0.0',
        },
        timeout: 30000,
      });
      return response.data;
    } catch (error) {
      if (axios.isAxiosError(error) && error.response) {
        const { status, data } = error.response;
        const message = (data as any)?.error || error.message;
        throw new AppOintAPIError(message, status);
      }
      throw new AppOintAPIError((error as Error).message, 0);
    }
  }
}

// Export everything
export default AppOintAPI;