import axios from 'axios';

const backendUrl = process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:8080';
console.log('Backend URL:', backendUrl);  

const instance = axios.create({
  baseURL: backendUrl,
});

export default instance;