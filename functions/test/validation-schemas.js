/**
 * Validation schemas for Cloud Functions
 * Simple validation without external dependencies
 */

const Joi = require('joi');

class ValidationError extends Error {
  constructor(message, field) {
    super(message);
    this.name = 'ValidationError';
    this.field = field;
  }
}

const validators = {
  // String validation
  isString: (value, fieldName) => {
    if (typeof value !== 'string') {
      throw new ValidationError(`${fieldName} must be a string`, fieldName);
    }
    return value;
  },

  // Required string validation
  requiredString: (value, fieldName) => {
    const str = validators.isString(value, fieldName);
    if (!str.trim()) {
      throw new ValidationError(`${fieldName} is required`, fieldName);
    }
    return str;
  },

  // Email validation
  email: (value, fieldName) => {
    const str = validators.requiredString(value, fieldName);
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(str)) {
      throw new ValidationError(`${fieldName} must be a valid email`, fieldName);
    }
    return str;
  },

  // Number validation
  isNumber: (value, fieldName) => {
    if (typeof value !== 'number' || isNaN(value)) {
      throw new ValidationError(`${fieldName} must be a number`, fieldName);
    }
    return value;
  },

  // Positive number validation
  positiveNumber: (value, fieldName) => {
    const num = validators.isNumber(value, fieldName);
    if (num <= 0) {
      throw new ValidationError(`${fieldName} must be positive`, fieldName);
    }
    return num;
  },

  // Integer validation
  isInteger: (value, fieldName) => {
    const num = validators.isNumber(value, fieldName);
    if (!Number.isInteger(num)) {
      throw new ValidationError(`${fieldName} must be an integer`, fieldName);
    }
    return num;
  },

  // Boolean validation
  isBoolean: (value, fieldName) => {
    if (typeof value !== 'boolean') {
      throw new ValidationError(`${fieldName} must be a boolean`, fieldName);
    }
    return value;
  },

  // Array validation
  isArray: (value, fieldName) => {
    if (!Array.isArray(value)) {
      throw new ValidationError(`${fieldName} must be an array`, fieldName);
    }
    return value;
  },

  // Object validation
  isObject: (value, fieldName) => {
    if (typeof value !== 'object' || value === null || Array.isArray(value)) {
      throw new ValidationError(`${fieldName} must be an object`, fieldName);
    }
    return value;
  },

  // Length validation
  minLength: (value, minLength, fieldName) => {
    if (value.length < minLength) {
      throw new ValidationError(
        `${fieldName} must be at least ${minLength} characters`,
        fieldName
      );
    }
    return value;
  },

  maxLength: (value, maxLength, fieldName) => {
    if (value.length > maxLength) {
      throw new ValidationError(
        `${fieldName} must be at most ${maxLength} characters`,
        fieldName
      );
    }
    return value;
  },

  // Range validation
  minValue: (value, minValue, fieldName) => {
    if (value < minValue) {
      throw new ValidationError(
        `${fieldName} must be at least ${minValue}`,
        fieldName
      );
    }
    return value;
  },

  maxValue: (value, maxValue, fieldName) => {
    if (value > maxValue) {
      throw new ValidationError(
        `${fieldName} must be at most ${maxValue}`,
        fieldName
      );
    }
    return value;
  },

  // Enum validation
  enum: (value, allowedValues, fieldName) => {
    if (!allowedValues.includes(value)) {
      throw new ValidationError(
        `${fieldName} must be one of: ${allowedValues.join(', ')}`,
        fieldName
      );
    }
    return value;
  },

  // URL validation
  url: (value, fieldName) => {
    const str = validators.requiredString(value, fieldName);
    try {
      new URL(str);
      return str;
    } catch {
      throw new ValidationError(`${fieldName} must be a valid URL`, fieldName);
    }
  },

  // Date validation
  isDate: (value, fieldName) => {
    const date = new Date(value);
    if (isNaN(date.getTime())) {
      throw new ValidationError(`${fieldName} must be a valid date`, fieldName);
    }
    return date;
  },

  // Future date validation
  futureDate: (value, fieldName) => {
    const date = validators.isDate(value, fieldName);
    if (date <= new Date()) {
      throw new ValidationError(`${fieldName} must be in the future`, fieldName);
    }
    return date;
  },
};

// Validation schemas for Cloud Functions
const schemas = {
  assignAmbassador: Joi.object({
    userId: Joi.string().required().min(1),
    countryCode: Joi.string().required().length(2),
    languageCode: Joi.string().required().length(2),
  }),

  createCheckoutSession: Joi.object({
    studioId: Joi.string().required(),
    priceId: Joi.string().required(),
    successUrl: Joi.string().uri().optional(),
    cancelUrl: Joi.string().uri().optional(),
    customerEmail: Joi.string().email().optional(),
  }),

  cancelSubscription: Joi.object({
    subscriptionId: Joi.string().required(),
  }),

  sendNotificationToStudio: Joi.object({
    studioId: Joi.string().required(),
    title: Joi.string().required().max(100),
    body: Joi.string().required().max(500),
    data: Joi.object().optional(),
  }),

  // Payment intent schema
  createPaymentIntent: (data) => {
    const validated = {};
    
    validated.amount = validators.positiveNumber(data.amount, 'amount');
    
    return validated;
  },

  // User profile schema
  userProfile: (data) => {
    const validated = {};
    
    validated.name = validators.requiredString(data.name, 'name');
    validated.email = validators.email(data.email, 'email');
    
    if (data.phone) {
      validated.phone = validators.requiredString(data.phone, 'phone');
    }
    
    if (data.countryCode) {
      validated.countryCode = validators.requiredString(data.countryCode, 'countryCode');
    }
    
    if (data.languageCode) {
      validated.languageCode = validators.requiredString(data.languageCode, 'languageCode');
    }
    
    if (data.isAdult !== undefined) {
      validated.isAdult = validators.isBoolean(data.isAdult, 'isAdult');
    }
    
    return validated;
  },

  // Business availability schema
  businessAvailability: (data) => {
    const validated = {};
    
    validated.weekday = validators.isInteger(data.weekday, 'weekday');
    validated.weekday = validators.minValue(validated.weekday, 0, 'weekday');
    validated.weekday = validators.maxValue(validated.weekday, 6, 'weekday');
    
    validated.isOpen = validators.isBoolean(data.isOpen, 'isOpen');
    
    if (data.start) {
      validated.start = validators.requiredString(data.start, 'start');
    }
    
    if (data.end) {
      validated.end = validators.requiredString(data.end, 'end');
    }
    
    return validated;
  },

  // Notification schema
  sendNotification: (data) => {
    const validated = {};
    
    validated.studioId = validators.requiredString(data.studioId, 'studioId');
    validated.title = validators.requiredString(data.title, 'title');
    validated.body = validators.requiredString(data.body, 'body');
    
    if (data.data) {
      validated.data = validators.isObject(data.data, 'data');
    }
    
    return validated;
  },
};

// Validation function
function validate(schema, data) {
  const { error, value } = schema.validate(data);
  if (error) {
    const validationError = new Error(error.details[0].message);
    validationError.code = 'invalid-argument';
    validationError.details = {
      field: error.details[0].path[0],
    };
    throw validationError;
  }
  return value;
}

module.exports = {
  validators,
  schemas,
  validate,
  ValidationError,
}; 