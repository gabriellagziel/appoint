import { z } from 'zod';
// Base schemas for common fields
export const userIdSchema = z.string().min(1, 'User ID is required');
export const studioIdSchema = z.string().min(1, 'Studio ID is required');
export const emailSchema = z.string().email('Invalid email format');
export const phoneSchema = z.string().regex(/^\+?[1-9]\d{1,14}$/, 'Invalid phone number format');
// Booking schemas
export const createBookingSchema = z.object({
    studioId: studioIdSchema,
    serviceId: z.string().min(1, 'Service ID is required'),
    scheduledAt: z.string().datetime('Invalid date format'),
    customerId: userIdSchema,
    notes: z.string().optional(),
    customerInfo: z.object({
        name: z.string().min(1, 'Customer name is required'),
        email: emailSchema,
        phone: phoneSchema,
    }),
});
export const updateBookingSchema = z.object({
    appointmentId: z.string().min(1, 'Appointment ID is required'),
    updates: z.object({
        scheduledAt: z.string().datetime('Invalid date format').optional(),
        status: z.enum(['confirmed', 'cancelled', 'completed', 'no_show']).optional(),
        notes: z.string().optional(),
    }),
});
export const cancelBookingSchema = z.object({
    appointmentId: z.string().min(1, 'Appointment ID is required'),
    reason: z.string().optional(),
});
export const getAvailableSlotsSchema = z.object({
    businessId: z.string().min(1, 'Business ID is required'),
    serviceId: z.string().min(1, 'Service ID is required'),
    date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Date must be in YYYY-MM-DD format'),
});
// Payment schemas
export const createPaymentIntentSchema = z.object({
    amount: z.number().positive('Amount must be positive'),
    currency: z.string().default('usd'),
    appointmentId: z.string().min(1, 'Appointment ID is required'),
    customerId: userIdSchema,
});
export const confirmPaymentSchema = z.object({
    paymentIntentId: z.string().min(1, 'Payment Intent ID is required'),
    appointmentId: z.string().min(1, 'Appointment ID is required'),
});
export const processRefundSchema = z.object({
    paymentIntentId: z.string().min(1, 'Payment Intent ID is required'),
    amount: z.number().positive('Amount must be positive'),
    reason: z.string().min(1, 'Refund reason is required'),
});
// Stripe schemas
export const createCheckoutSessionSchema = z.object({
    studioId: studioIdSchema,
    priceId: z.string().min(1, 'Price ID is required'),
    successUrl: z.string().url('Invalid success URL').optional(),
    cancelUrl: z.string().url('Invalid cancel URL').optional(),
    customerEmail: emailSchema.optional(),
});
export const cancelSubscriptionSchema = z.object({
    subscriptionId: z.string().min(1, 'Subscription ID is required'),
});
// User management schemas
export const createUserSchema = z.object({
    email: emailSchema,
    displayName: z.string().min(1, 'Display name is required').max(100, 'Display name too long'),
    phoneNumber: phoneSchema.optional(),
    businessId: z.string().optional(),
    role: z.enum(['user', 'business_owner', 'admin']).default('user'),
});
export const updateUserProfileSchema = z.object({
    userId: userIdSchema,
    updates: z.object({
        displayName: z.string().min(1, 'Display name is required').max(100, 'Display name too long').optional(),
        phoneNumber: phoneSchema.optional(),
        avatar: z.string().url('Invalid avatar URL').optional(),
        preferences: z.object({
            notifications: z.boolean().optional(),
            language: z.string().min(2, 'Language code too short').max(5, 'Language code too long').optional(),
            timezone: z.string().min(1, 'Timezone is required').optional(),
        }).optional(),
    }),
});
export const deleteUserSchema = z.object({
    userId: userIdSchema,
    reason: z.string().optional(),
});
// Business management schemas
export const createBusinessSchema = z.object({
    name: z.string().min(1, 'Business name is required').max(200, 'Business name too long'),
    description: z.string().max(1000, 'Description too long'),
    address: z.object({
        street: z.string().min(1, 'Street address is required'),
        city: z.string().min(1, 'City is required'),
        state: z.string().min(1, 'State is required'),
        zipCode: z.string().min(1, 'ZIP code is required'),
        country: z.string().min(2, 'Country code too short').max(3, 'Country code too long'),
    }),
    contactInfo: z.object({
        phone: phoneSchema,
        email: emailSchema,
        website: z.string().url('Invalid website URL').optional(),
    }),
    businessHours: z.record(z.string(), z.object({
        open: z.string().regex(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/, 'Invalid time format'),
        close: z.string().regex(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/, 'Invalid time format'),
        closed: z.boolean(),
    })),
    services: z.array(z.object({
        name: z.string().min(1, 'Service name is required'),
        duration: z.number().positive('Duration must be positive'),
        price: z.number().nonnegative('Price must be non-negative'),
        description: z.string().optional(),
    })).min(1, 'At least one service is required'),
    category: z.string().min(1, 'Category is required'),
    tags: z.array(z.string()).optional(),
});
export const updateBusinessSchema = z.object({
    businessId: z.string().min(1, 'Business ID is required'),
    updates: z.object({
        name: z.string().min(1, 'Business name is required').max(200, 'Business name too long').optional(),
        description: z.string().max(1000, 'Description too long').optional(),
        address: z.object({
            street: z.string().min(1, 'Street address is required'),
            city: z.string().min(1, 'City is required'),
            state: z.string().min(1, 'State is required'),
            zipCode: z.string().min(1, 'ZIP code is required'),
            country: z.string().min(2, 'Country code too short').max(3, 'Country code too long'),
        }).optional(),
        contactInfo: z.object({
            phone: phoneSchema,
            email: emailSchema,
            website: z.string().url('Invalid website URL').optional(),
        }).optional(),
        businessHours: z.record(z.string(), z.object({
            open: z.string().regex(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/, 'Invalid time format'),
            close: z.string().regex(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/, 'Invalid time format'),
            closed: z.boolean(),
        })).optional(),
        services: z.array(z.object({
            name: z.string().min(1, 'Service name is required'),
            duration: z.number().positive('Duration must be positive'),
            price: z.number().nonnegative('Price must be non-negative'),
            description: z.string().optional(),
        })).optional(),
        category: z.string().min(1, 'Category is required').optional(),
        tags: z.array(z.string()).optional(),
    }),
});
export const getBusinessDetailsSchema = z.object({
    businessId: z.string().min(1, 'Business ID is required'),
});
// Ambassador schemas
export const createAmbassadorSchema = z.object({
    userId: userIdSchema,
    referralCode: z.string().min(1, 'Referral code is required').max(20, 'Referral code too long'),
    quota: z.number().positive('Quota must be positive'),
    commissionRate: z.number().min(0, 'Commission rate must be non-negative').max(1, 'Commission rate cannot exceed 100%'),
});
export const trackReferralSchema = z.object({
    referralCode: z.string().min(1, 'Referral code is required'),
    customerId: userIdSchema,
    appointmentId: z.string().min(1, 'Appointment ID is required'),
});
export const getAmbassadorStatsSchema = z.object({
    ambassadorId: z.string().min(1, 'Ambassador ID is required'),
    period: z.enum(['week', 'month', 'year']).optional(),
});
// Analytics schemas
export const getBusinessAnalyticsSchema = z.object({
    businessId: z.string().min(1, 'Business ID is required'),
    period: z.enum(['week', 'month', 'year']),
    startDate: z.string().datetime('Invalid start date format').optional(),
    endDate: z.string().datetime('Invalid end date format').optional(),
});
export const getSystemAnalyticsSchema = z.object({
    period: z.enum(['week', 'month', 'year']),
    startDate: z.string().datetime('Invalid start date format').optional(),
    endDate: z.string().datetime('Invalid end date format').optional(),
});
// Admin schemas
export const setAdminRoleSchema = z.object({
    uid: z.string().min(1, 'User ID is required'),
    role: z.enum(['admin', 'super_admin', 'moderator']),
    permissions: z.array(z.string()).optional(),
});
export const suspendUserSchema = z.object({
    userId: userIdSchema,
    reason: z.string().min(1, 'Suspension reason is required'),
    duration: z.number().positive('Duration must be positive').optional(),
});
export const unsuspendUserSchema = z.object({
    userId: userIdSchema,
});
export const generateReportSchema = z.object({
    reportType: z.enum(['users', 'businesses', 'appointments', 'revenue', 'ambassadors']),
    format: z.enum(['csv', 'pdf', 'json']),
    filters: z.object({
        startDate: z.string().datetime('Invalid start date format').optional(),
        endDate: z.string().datetime('Invalid end date format').optional(),
        businessId: z.string().optional(),
        userId: z.string().optional(),
    }).optional(),
});
// Notification schemas
export const sendNotificationToStudioSchema = z.object({
    studioId: studioIdSchema,
    title: z.string().min(1, 'Title is required').max(100, 'Title too long'),
    body: z.string().min(1, 'Body is required').max(500, 'Body too long'),
    data: z.record(z.string(), z.string()).optional(),
});
// Validation helper function
export function validateInput(schema, data) {
    try {
        return schema.parse(data);
    }
    catch (error) {
        if (error instanceof z.ZodError) {
            const errorMessage = error.issues.map((err) => `${err.path.join('.')}: ${err.message}`).join(', ');
            throw new Error(`Validation failed: ${errorMessage}`);
        }
        throw error;
    }
}
