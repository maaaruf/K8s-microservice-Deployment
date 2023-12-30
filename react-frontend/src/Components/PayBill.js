import React from "react";
import axios from "axios";
import { toast } from "react-toastify";

const PayBill = () => {

  const handleFormSubmit = (e) => {
    e.preventDefault();

    let amount = e.target.elements.bill?.value;
    if(amount == ''){
     return toast.error('Please input bill amount');
    }

    /*
const response = await axios.post('https://api.example.com/post-endpoint', postData, {
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*', // Allow requests from any origin
            // Add any other CORS headers as needed
          },
        });
    */

    axios.post('http://localhost:9090/payment', { amount }, {
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*', // Allow requests from any origin
        // Add any other CORS headers as needed
      },
    })
    .then(res => {
      console.log(res);
      console.log(res.data);
      toast.success(`You Paid ${amount} TK Bill`);
    })
    .catch(error => {
      console.error('Error:', error);
      toast.error('Error occurred while making the request.');
    });
  

  };

  return (
    <section className="h-screen flex flex-col md:flex-row justify-center space-y-10 md:space-y-0 md:space-x-16 items-center my-2 mx-5 md:mx-0 md:my-0">
      <div className=" max-w-sm">
        <form onSubmit={handleFormSubmit}>
          <input
            className=" w-full px-4 py-2  outline-none	 border border-solid border-gray-300 rounded "
            type='text' id='bill'
            placeholder="Enter Bill"
          />

          <div className="text-center md:text-center">
            <button
              className="mt-4 bg-blue-700 hover:bg-blue-800 px-4 py-2 text-white uppercase rounded text-xs tracking-wider"
              type="submit" onSubmit={handleFormSubmit}
            >
              Pay Now
            </button>
          </div>
        </form>

      </div>
    </section>
  );
};

export default PayBill;