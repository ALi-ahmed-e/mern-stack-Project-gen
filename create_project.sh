#!/bin/bash


# Prompt the user for the app name
read -p "Enter the app name: " app_name

# Step 1: Create project folder
cd ..
mkdir $app_name
cd $app_name
mkdir backend
cd backend

# Step 2: Initialize npm
npm init -y

# Step 3: Install required modules
npm install express cors dotenv express-rate-limit helmet hpp jsonwebtoken mongoose
npm i --dev nodemon
# Step 4: Create server.js file
cat > server.js <<EOF
const dotenv = require('dotenv').config()
const express = require('express');
const app = express();
const PORT = process.env.PORT || 8000
const cors = require('cors');
const connectToDb = require('./config/connectToDB')
const helmet = require('helmet')
const rateLimiting = require('express-rate-limit')
const hpp = require('hpp')


app.use(rateLimiting({
  windowMs: 10 * 60 * 1000,
  max: 1200,
}))
app.use(
  helmet.contentSecurityPolicy({
    directives: {
      ...helmet.contentSecurityPolicy.getDefaultDirectives(),
      "img-src": ["*", "data:"],
    },
  })
);
app.use(hpp())
app.use(express.json({ limit: '100mb' }))
app.use(cors({
  origin: 'http://localhost:3000',
  methods: "GET,POST,PUT,DELETE",
  credentials: true,
}))


app.listen(PORT, () => console.log('app started'));
connectToDb()

EOF

# Step 5: Create database connection pooling file
mkdir config
cd config
cat > connectToDB.js <<EOF
const mongoose = require('mongoose');

const connectToDB = () => {

	mongoose.connect(process.env.DB_URI)
	mongoose.connection.on("connected", () => {
		return console.log("Connected to database sucessfully");
	});

	mongoose.connection.on("error", (err) => {
		return console.log("Error while connecting to database :" + err);
	});

	mongoose.connection.on("disconnected", () => {
		return console.log("Mongodb connection disconnected");
	});
}

module.exports = connectToDB
EOF
cd ..

# Step 6: Create .env file
cat > .env <<EOF
PORT=8000
DB_URI=
EOF


mkdir routes models controllers utils middlewares

cd .. 
# mkdir .gitignore

npm init --yes

cat <<EOF > .gitignore
.env
backend/.env
frontend/dist
node_modules
EOF


# cd frontend

# Create the app using npm create vite
npm create vite@latest frontend -- --template react
# mkdir frontend

# Navigate into the app directory
cd frontend

# Install dependencies
npm install

npm i axios react-router-dom react-icons @reduxjs/toolkit react-redux

# Install Tailwind CSS and its dependencies
npm install -D tailwindcss@latest postcss@latest autoprefixer@latest

# Generate a Tailwind CSS configuration file
npx tailwindcss init -p

# Replace the contents of tailwind.config.js
cat <<EOF > tailwind.config.js
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF
# Update the PostCSS configuration file to use Tailwind CSS
# cat <<EOT >> postcss.config.js
# module.exports = {
#   plugins: [
#     require('tailwindcss'),
#     require('autoprefixer'),
#   ],
# };
# EOT

# Update the main CSS file to include Tailwind CSS
cat <<EOT > src/index.css
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';
EOT
cd .. 
code . 

