"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendNotificationToStudioSchema = exports.generateReportSchema = exports.unsuspendUserSchema = exports.suspendUserSchema = exports.setAdminRoleSchema = exports.getSystemAnalyticsSchema = exports.getBusinessAnalyticsSchema = exports.getAmbassadorStatsSchema = exports.trackReferralSchema = exports.createAmbassadorSchema = exports.getBusinessDetailsSchema = exports.updateBusinessSchema = exports.createBusinessSchema = exports.deleteUserSchema = exports.updateUserProfileSchema = exports.createUserSchema = exports.cancelSubscriptionSchema = exports.createCheckoutSessionSchema = exports.processRefundSchema = exports.confirmPaymentSchema = exports.createPaymentIntentSchema = exports.getAvailableSlotsSchema = exports.cancelBookingSchema = exports.updateBookingSchema = exports.createBookingSchema = exports.phoneSchema = exports.emailSchema = exports.studioIdSchema = exports.userIdSchema = void 0;
exports.validateInput = validateInput;
const zod_1 = require("zod");
// Base schemas for common fields
exports.userIdSchema = zod_1.z.string().min(1, 'User ID is required');
exports.studioIdSchema = zod_1.z.string().min(1, 'Studio ID is required');
exports.emailSchema = zod_1.z.string().email('Invalid email format');
exports.phoneSchema = zod_1.z.string().regex(/^\+?[1-9]\d{1,14}$/, 'Invalid phone number format');
// Booking schemas
exports.createBookingSchema = zod_1.z.object({
    studioId: exports.studioIdSchema,
    serviceId: zod_1.z.string().min(1, 'Service ID is required'),
    scheduledAt: zod_1.z.string().datetime('Invalid date format'),
    customerId: exports.userIdSchema,
    notes: zod_1.z.string().optional(),
    customerInfo: zod_1.z.object({
        name: zod_1.z.string().min(1, 'Customer name is required'),
        email: exports.emailSchema,
        phone: exports.phoneSchema,
    }),
});
exports.updateBookingSchema = zod_1.z.object({
    appointmentId: zod_1.z.string().min(1, 'Appointment ID is required'),
    updates: zod_1.z.object({
        scheduledAt: zod_1.z.string().datetime('Invalid date format').optional(),
        status: zod_1.z.enum(['confirmed', 'cancelled', 'completed', 'no_show']).optional(),
        notes: zod_1.z.string().optional(),
    }),
});
exports.cancelBookingSchema = zod_1.z.object({
    appointmentId: zod_1.z.string().min(1, 'Appointment ID is required'),
    reason: zod_1.z.string().optional(),
});
exports.getAvailableSlotsSchema = zod_1.z.object({
    businessId: zod_1.z.string().min(1, 'Business ID is required'),
    serviceId: zod_1.z.string().min(1, 'Service ID is required'),
    date: zod_1.z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Date must be in YYYY-MM-DD format'),
});
// Payment schemas
exports.createPaymentIntentSchema = zod_1.z.object({
    amount: zod_1.z.number().positive('Amount must be positive'),
    currency: zod_1.z.string().default('usd'),
    appointmentId: zod_1.z.string().min(1, 'Appointment ID is required'),
    customerId: exports.userIdSchema,
});
exports.confirmPaymentSchema = zod_1.z.object({
    paymentIntentId: zod_1.z.string().min(1, 'Payment Intent ID is required'),
    appointmentId: zod_1.z.string().min(1, 'Appointment ID is required'),
});
exports.processRefundSchema = zod_1.z.object({
    paymentIntentId: zod_1.z.string().min(1, 'Payment Intent ID is required'),
    amount: zod_1.z.number().positive('Amount must be positive'),
    reason: zod_1.z.string().min(1, 'Refund reason is required'),
});
// Stripe schemas
exports.createCheckoutSessionSchema = zod_1.z.object({
    studioId: exports.studioIdSchema,
    priceId: zod_1.z.string().min(1, 'Price ID is required'),
    successUrl: zod_1.z.string().url('Invalid success URL').optional(),
    cancelUrl: zod_1.z.string().url('Invalid cancel URL').optional(),
    customerEmail: exports.emailSchema.optional(),
});
exports.cancelSubscriptionSchema = zod_1.z.object({
    subscriptionId: zod_1.z.string().min(1, 'Subscription ID is required'),
});
// User management schemas
exports.createUserSchema = zod_1.z.object({
    email: exports.emailSchema,
    displayName: zod_1.z.string().min(1, 'Display name is required').max(100, 'Display name too long'),
    phoneNumber: exports.phoneSchema.optional(),
    businessId: zod_1.z.string().optional(),
    role: zod_1.z.enum(['user', 'business_owner', 'admin']).default('user'),
});
exports.updateUserProfileSchema = zod_1.z.object({
    userId: exports.userIdSchema,
    updates: zod_1.z.object({
        displayName: zod_1.z.string().min(1, 'Display name is required').max(100, 'Display name too long').optional(),
        phoneNumber: exports.phoneSchema.optional(),
        avatar: zod_1.z.string().url('Invalid avatar URL').optional(),
        preferences: zod_1.z.object({
            notifications: zod_1.z.boolean().optional(),
            language: zod_1.z.string().min(2, 'Language code too short').max(5, 'Language code too long').optional(),
            timezone: zod_1.z.string().min(1, 'Timezone is required').optional(),
        }).optional(),
    }),
});
exports.deleteUserSchema = zod_1.z.object({
    userId: exports.userIdSchema,
    reason: zod_1.z.string().optional(),
});
// Business management schemas
exports.createBusinessSchema = zod_1.z.object({
    name: zod_1.z.string().min(1, 'Business name is required').max(200, 'Business name too long'),
    description: zod_1.z.string().max(1000, 'Description too long'),
    address: zod_1.z.object({
        street: zod_1.z.string().min(1, 'Street address is required'),
        city: zod_1.z.string().min(1, 'City is required'),
        state: zod_1.z.string().min(1, 'State is required'),
        zipCode: zod_1.z.string().min(1, 'ZIP code is required'),
        country: zod_1.z.string().min(2, 'Country code too short').max(3, 'Country code too long'),
    }),
    contactInfo: zod_1.z.object({
        phone: exports.phoneSchema,
        email: exports.emailSchema,
        website: zod_1.z.string().url('Invalid website URL').optional(),
    }),
    businessHours: zod_1.z.record(zod_1.z.string(), zod_1.z.object({
        open: zod_1.z.string().regex(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/, 'Invalid time format'),
        close: zod_1.z.string().regex(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/, 'Invalid time format'),
        closed: zod_1.z.boolean(),
    })),
    services: zod_1.z.array(zod_1.z.object({
        name: zod_1.z.string().min(1, 'Service name is required'),
        duration: zod_1.z.number().positive('Duration must be positive'),
        price: zod_1.z.number().nonnegative('Price must be non-negative'),
        description: zod_1.z.string().optional(),
    })).min(1, 'At least one service is required'),
    category: zod_1.z.string().min(1, 'Category is required'),
    tags: zod_1.z.array(zod_1.z.string()).optional(),
});
exports.updateBusinessSchema = zod_1.z.object({
    businessId: zod_1.z.string().min(1, 'Business ID is required'),
    updates: zod_1.z.object({
        name: zod_1.z.string().min(1, 'Business name is required').max(200, 'Business name too long').optional(),
        description: zod_1.z.string().max(1000, 'Description too long').optional(),
        address: zod_1.z.object({
            street: zod_1.z.string().min(1, 'Street address is required'),
            city: zod_1.z.string().min(1, 'City is required'),
            state: zod_1.z.string().min(1, 'State is required'),
            zipCode: zod_1.z.string().min(1, 'ZIP code is required'),
            country: zod_1.z.string().min(2, 'Country code too short').max(3, 'Country code too long'),
        }).optional(),
        contactInfo: zod_1.z.object({
            phone: exports.phoneSchema,
            email: exports.emailSchema,
            website: zod_1.z.string().url('Invalid website URL').optional(),
        }).optional(),
        businessHours: zod_1.z.record(zod_1.z.string(), zod_1.z.object({
            open: zod_1.z.string().regex(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/, 'Invalid time format'),
            close: zod_1.z.string().regex(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/, 'Invalid time format'),
            closed: zod_1.z.boolean(),
        })).optional(),
        services: zod_1.z.array(zod_1.z.object({
            name: zod_1.z.string().min(1, 'Service name is required'),
            duration: zod_1.z.number().positive('Duration must be positive'),
            price: zod_1.z.number().nonnegative('Price must be non-negative'),
            description: zod_1.z.string().optional(),
        })).optional(),
        category: zod_1.z.string().min(1, 'Category is required').optional(),
        tags: zod_1.z.array(zod_1.z.string()).optional(),
    }),
});
exports.getBusinessDetailsSchema = zod_1.z.object({
    businessId: zod_1.z.string().min(1, 'Business ID is required'),
});
// Ambassador schemas
exports.createAmbassadorSchema = zod_1.z.object({
    userId: exports.userIdSchema,
    referralCode: zod_1.z.string().min(1, 'Referral code is required').max(20, 'Referral code too long'),
    quota: zod_1.z.number().positive('Quota must be positive'),
    commissionRate: zod_1.z.number().min(0, 'Commission rate must be non-negative').max(1, 'Commission rate cannot exceed 100%'),
});
exports.trackReferralSchema = zod_1.z.object({
    referralCode: zod_1.z.string().min(1, 'Referral code is required'),
    customerId: exports.userIdSchema,
    appointmentId: zod_1.z.string().min(1, 'Appointment ID is required'),
});
exports.getAmbassadorStatsSchema = zod_1.z.object({
    ambassadorId: zod_1.z.string().min(1, 'Ambassador ID is required'),
    period: zod_1.z.enum(['week', 'month', 'year']).optional(),
});
// Analytics schemas
exports.getBusinessAnalyticsSchema = zod_1.z.object({
    businessId: zod_1.z.string().min(1, 'Business ID is required'),
    period: zod_1.z.enum(['week', 'month', 'year']),
    startDate: zod_1.z.string().datetime('Invalid start date format').optional(),
    endDate: zod_1.z.string().datetime('Invalid end date format').optional(),
});
exports.getSystemAnalyticsSchema = zod_1.z.object({
    period: zod_1.z.enum(['week', 'month', 'year']),
    startDate: zod_1.z.string().datetime('Invalid start date format').optional(),
    endDate: zod_1.z.string().datetime('Invalid end date format').optional(),
});
// Admin schemas
exports.setAdminRoleSchema = zod_1.z.object({
    uid: zod_1.z.string().min(1, 'User ID is required'),
    role: zod_1.z.enum(['admin', 'super_admin', 'moderator']),
    permissions: zod_1.z.array(zod_1.z.string()).optional(),
});
exports.suspendUserSchema = zod_1.z.object({
    userId: exports.userIdSchema,
    reason: zod_1.z.string().min(1, 'Suspension reason is required'),
    duration: zod_1.z.number().positive('Duration must be positive').optional(),
});
exports.unsuspendUserSchema = zod_1.z.object({
    userId: exports.userIdSchema,
});
exports.generateReportSchema = zod_1.z.object({
    reportType: zod_1.z.enum(['users', 'businesses', 'appointments', 'revenue', 'ambassadors']),
    format: zod_1.z.enum(['csv', 'pdf', 'json']),
    filters: zod_1.z.object({
        startDate: zod_1.z.string().datetime('Invalid start date format').optional(),
        endDate: zod_1.z.string().datetime('Invalid end date format').optional(),
        businessId: zod_1.z.string().optional(),
        userId: zod_1.z.string().optional(),
    }).optional(),
});
// Notification schemas
exports.sendNotificationToStudioSchema = zod_1.z.object({
    studioId: exports.studioIdSchema,
    title: zod_1.z.string().min(1, 'Title is required').max(100, 'Title too long'),
    body: zod_1.z.string().min(1, 'Body is required').max(500, 'Body too long'),
    data: zod_1.z.record(zod_1.z.string(), zod_1.z.string()).optional(),
});
// Validation helper function
function validateInput(schema, data) {
    try {
        return schema.parse(data);
    }
    catch (error) {
        if (error instanceof zod_1.z.ZodError) {
            const errorMessage = error.issues.map((err) => `${err.path.join('.')}: ${err.message}`).join(', ');
            throw new Error(`Validation failed: ${errorMessage}`);
        }
        throw error;
    }
}
