import logo from './logo.svg';
import './App.css';
import PayBill from './Components/PayBill';
import { ToastContainer } from 'react-toastify';
import "react-toastify/dist/ReactToastify.css";



function App() {
  return (
    <div className="App">
           <ToastContainer />
      <header className="App-header">
        
      <PayBill />

      </header>
    </div>
  );
}

export default App;
