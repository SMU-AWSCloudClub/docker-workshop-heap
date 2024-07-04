import axios from 'axios';

const isBrowser = typeof window !== 'undefined';

const instance = axios.create({
  baseURL: isBrowser
    ? 'http://localhost:8080'  // Use localhost when in browser
    : 'http://backend:8080',   // Use service name when in Docker
});

export default instance;