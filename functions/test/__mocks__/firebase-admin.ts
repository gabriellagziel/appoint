export const apps: any[] = [];
export const initializeApp = jest.fn(() => ({}));
export const app = jest.fn(() => ({
  firestore: () => ({ collection: jest.fn() }),
  auth: () => ({})
}));
export const firestore = jest.fn();
export const auth = jest.fn();


