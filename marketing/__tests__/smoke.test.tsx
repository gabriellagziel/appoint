import { render, screen } from '@testing-library/react';

function App() { 
  return <div>ok</div>; 
}

test('renders', () => { 
  render(<App/>); 
  expect(screen.getByText('ok')).toBeInTheDocument(); 
});
