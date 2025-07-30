const { validators, schemas, validate, ValidationError } = require('./validation-schemas');
const functions = require('firebase-functions');

describe('Validation Schemas', () => {
  describe('validators', () => {
    describe('isString', () => {
      it('should validate string values', () => {
        expect(validators.isString('test', 'field')).toBe('test');
        expect(validators.isString('', 'field')).toBe('');
      });

      it('should reject non-string values', () => {
        expect(() => validators.isString(123, 'field')).toThrow(ValidationError);
        expect(() => validators.isString(null, 'field')).toThrow(ValidationError);
        expect(() => validators.isString(undefined, 'field')).toThrow(ValidationError);
      });
    });

    describe('requiredString', () => {
      it('should validate non-empty strings', () => {
        expect(validators.requiredString('test', 'field')).toBe('test');
      });

      it('should reject empty or whitespace strings', () => {
        expect(() => validators.requiredString('', 'field')).toThrow(ValidationError);
        expect(() => validators.requiredString('   ', 'field')).toThrow(ValidationError);
      });
    });

    describe('email', () => {
      it('should validate valid email addresses', () => {
        expect(validators.email('test@example.com', 'field')).toBe('test@example.com');
        expect(validators.email('user.name+tag@domain.co.uk', 'field')).toBe('user.name+tag@domain.co.uk');
      });

      it('should reject invalid email addresses', () => {
        expect(() => validators.email('invalid-email', 'field')).toThrow(ValidationError);
        expect(() => validators.email('test@', 'field')).toThrow(ValidationError);
        expect(() => validators.email('@example.com', 'field')).toThrow(ValidationError);
      });
    });

    describe('isNumber', () => {
      it('should validate number values', () => {
        expect(validators.isNumber(123, 'field')).toBe(123);
        expect(validators.isNumber(0, 'field')).toBe(0);
        expect(validators.isNumber(-123, 'field')).toBe(-123);
      });

      it('should reject non-number values', () => {
        expect(() => validators.isNumber('123', 'field')).toThrow(ValidationError);
        expect(() => validators.isNumber(NaN, 'field')).toThrow(ValidationError);
        expect(() => validators.isNumber(null, 'field')).toThrow(ValidationError);
      });
    });

    describe('positiveNumber', () => {
      it('should validate positive numbers', () => {
        expect(validators.positiveNumber(123, 'field')).toBe(123);
        expect(validators.positiveNumber(0.1, 'field')).toBe(0.1);
      });

      it('should reject non-positive numbers', () => {
        expect(() => validators.positiveNumber(0, 'field')).toThrow(ValidationError);
        expect(() => validators.positiveNumber(-123, 'field')).toThrow(ValidationError);
      });
    });

    describe('isInteger', () => {
      it('should validate integer values', () => {
        expect(validators.isInteger(123, 'field')).toBe(123);
        expect(validators.isInteger(0, 'field')).toBe(0);
        expect(validators.isInteger(-123, 'field')).toBe(-123);
      });

      it('should reject non-integer values', () => {
        expect(() => validators.isInteger(123.5, 'field')).toThrow(ValidationError);
        expect(() => validators.isInteger('123', 'field')).toThrow(ValidationError);
      });
    });

    describe('isBoolean', () => {
      it('should validate boolean values', () => {
        expect(validators.isBoolean(true, 'field')).toBe(true);
        expect(validators.isBoolean(false, 'field')).toBe(false);
      });

      it('should reject non-boolean values', () => {
        expect(() => validators.isBoolean(1, 'field')).toThrow(ValidationError);
        expect(() => validators.isBoolean('true', 'field')).toThrow(ValidationError);
        expect(() => validators.isBoolean(null, 'field')).toThrow(ValidationError);
      });
    });

    describe('minLength', () => {
      it('should validate strings with minimum length', () => {
        expect(validators.minLength('test', 3, 'field')).toBe('test');
        expect(validators.minLength('test', 4, 'field')).toBe('test');
      });

      it('should reject strings below minimum length', () => {
        expect(() => validators.minLength('te', 3, 'field')).toThrow(ValidationError);
        expect(() => validators.minLength('', 1, 'field')).toThrow(ValidationError);
      });
    });

    describe('maxLength', () => {
      it('should validate strings with maximum length', () => {
        expect(validators.maxLength('test', 5, 'field')).toBe('test');
        expect(validators.maxLength('test', 4, 'field')).toBe('test');
      });

      it('should reject strings above maximum length', () => {
        expect(() => validators.maxLength('testing', 5, 'field')).toThrow(ValidationError);
      });
    });

    describe('enum', () => {
      it('should validate enum values', () => {
        expect(validators.enum('active', ['active', 'inactive'], 'field')).toBe('active');
        expect(validators.enum('inactive', ['active', 'inactive'], 'field')).toBe('inactive');
      });

      it('should reject non-enum values', () => {
        expect(() => validators.enum('pending', ['active', 'inactive'], 'field')).toThrow(ValidationError);
      });
    });

    describe('url', () => {
      it('should validate valid URLs', () => {
        expect(validators.url('https://example.com', 'field')).toBe('https://example.com');
        expect(validators.url('http://localhost:3000', 'field')).toBe('http://localhost:3000');
      });

      it('should reject invalid URLs', () => {
        expect(() => validators.url('not-a-url', 'field')).toThrow(ValidationError);
        expect(() => validators.url('ftp://invalid', 'field')).toThrow(ValidationError);
      });
    });
  });

  describe('schemas', () => {
    describe('assignAmbassador', () => {
      it('should validate correct ambassador assignment data', () => {
        const data = {
          userId: 'user123',
          countryCode: 'US',
          languageCode: 'en',
        };

        const result = schemas.assignAmbassador(data);

        expect(result).toEqual(data);
      });

      it('should reject missing required fields', () => {
        const data = {
          userId: 'user123',
          // Missing countryCode and languageCode
        };

        expect(() => schemas.assignAmbassador(data)).toThrow(ValidationError);
      });

      it('should reject empty strings', () => {
        const data = {
          userId: '',
          countryCode: 'US',
          languageCode: 'en',
        };

        expect(() => schemas.assignAmbassador(data)).toThrow(ValidationError);
      });
    });

    describe('createPaymentIntent', () => {
      it('should validate correct payment intent data', () => {
        const data = { amount: 1000 };

        const result = schemas.createPaymentIntent(data);

        expect(result).toEqual(data);
      });

      it('should reject invalid amounts', () => {
        expect(() => schemas.createPaymentIntent({ amount: 0 })).toThrow(ValidationError);
        expect(() => schemas.createPaymentIntent({ amount: -100 })).toThrow(ValidationError);
        expect(() => schemas.createPaymentIntent({ amount: '1000' })).toThrow(ValidationError);
      });
    });

    describe('createCheckoutSession', () => {
      it('should validate correct checkout session data', () => {
        const data = {
          studioId: 'studio123',
          priceId: 'price_123',
          successUrl: 'https://example.com/success',
          cancelUrl: 'https://example.com/cancel',
        };

        const result = schemas.createCheckoutSession(data);

        expect(result).toEqual(data);
      });

      it('should validate data without optional URLs', () => {
        const data = {
          studioId: 'studio123',
          priceId: 'price_123',
        };

        const result = schemas.createCheckoutSession(data);

        expect(result.studioId).toBe('studio123');
        expect(result.priceId).toBe('price_123');
        expect(result.successUrl).toBeUndefined();
        expect(result.cancelUrl).toBeUndefined();
      });

      it('should reject invalid URLs', () => {
        const data = {
          studioId: 'studio123',
          priceId: 'price_123',
          successUrl: 'not-a-url',
        };

        expect(() => schemas.createCheckoutSession(data)).toThrow(ValidationError);
      });
    });

    describe('userProfile', () => {
      it('should validate correct user profile data', () => {
        const data = {
          name: 'John Doe',
          email: 'john@example.com',
          phone: '+1234567890',
          countryCode: 'US',
          languageCode: 'en',
          isAdult: true,
        };

        const result = schemas.userProfile(data);

        expect(result).toEqual(data);
      });

      it('should validate minimal user profile data', () => {
        const data = {
          name: 'John Doe',
          email: 'john@example.com',
        };

        const result = schemas.userProfile(data);

        expect(result.name).toBe('John Doe');
        expect(result.email).toBe('john@example.com');
        expect(result.phone).toBeUndefined();
      });

      it('should reject invalid email', () => {
        const data = {
          name: 'John Doe',
          email: 'invalid-email',
        };

        expect(() => schemas.userProfile(data)).toThrow(ValidationError);
      });
    });

    describe('businessAvailability', () => {
      it('should validate correct business availability data', () => {
        const data = {
          weekday: 1,
          isOpen: true,
          start: '09:00',
          end: '17:00',
        };

        const result = schemas.businessAvailability(data);

        expect(result).toEqual(data);
      });

      it('should validate closed day data', () => {
        const data = {
          weekday: 0,
          isOpen: false,
        };

        const result = schemas.businessAvailability(data);

        expect(result.weekday).toBe(0);
        expect(result.isOpen).toBe(false);
        expect(result.start).toBeUndefined();
        expect(result.end).toBeUndefined();
      });

      it('should reject invalid weekday', () => {
        const data = {
          weekday: 7, // Invalid weekday
          isOpen: true,
        };

        expect(() => schemas.businessAvailability(data)).toThrow(ValidationError);
      });
    });
  });

  describe('validate helper', () => {
    it('should return validated data for valid input', () => {
      const data = {
        userId: 'user123',
        countryCode: 'US',
        languageCode: 'en',
      };

      const result = validate(schemas.assignAmbassador, data);

      expect(result).toEqual(data);
    });

    it('should throw HttpsError for invalid input', () => {
      const data = {
        userId: '',
        countryCode: 'US',
        languageCode: 'en',
      };

      expect(() => validate(schemas.assignAmbassador, data)).toThrow(
        functions.https.HttpsError
      );
    });

    it('should include field information in error', () => {
      const data = {
        userId: '',
        countryCode: 'US',
        languageCode: 'en',
      };

      try {
        validate(schemas.assignAmbassador, data);
      } catch (error) {
        expect(error.code).toBe('invalid-argument');
        expect(error.details.field).toBe('userId');
      }
    });
  });
}); 