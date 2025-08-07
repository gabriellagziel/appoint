// Simple in-memory feature flags service
class FeatureFlags {
    constructor() {
        this.flags = new Map();
        console.log('Feature flags service initialized (in-memory only)');
    }

    async load() {
        // In-memory only - no Redis needed
        console.log('Feature flags loaded from memory');
    }

    async setFlag(name, config) {
        this.flags.set(name, config);
        console.log(`Flag ${name} set to:`, config);
        return true;
    }

    async getFlag(name) {
        return this.flags.get(name) || { enabled: false };
    }

    middleware() {
        return async (req, res, next) => {
            req.flags = {};

            // Check for feature flags in headers
            for (let h in req.headers) {
                if (h.startsWith('x-feature-')) {
                    const flagName = h.slice(10);
                    req.flags[flagName] = req.headers[h] === 'true';
                }
            }

            // Load flags from memory
            for (let [k, v] of this.flags) {
                if (!(k in req.flags)) {
                    req.flags[k] = v.enabled;
                }
            }

            next();
        };
    }
}

module.exports = FeatureFlags; 