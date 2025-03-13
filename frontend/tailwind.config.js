/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: "#A8DF8E",
        secondary: "#F0F0F0",
        dark: "#1A1A1A",
        light: "#FFFFFF",
      },
    },
  },
  plugins: [],
  darkMode: 'class',
} 