import fsTest from 'firebase-functions-test';

export const testEnv = fsTest({
  projectId: 'demo-project',
}); // Use empty object for test environment 