# 1️⃣ Base image
FROM node:24.12.0-alpine

# 2️⃣ Working directory inside container
WORKDIR /app

# 3️⃣ Copy package files (better caching)
COPY package*.json ./

# 4️⃣ Install dependencies
RUN npm install --production

# 5️⃣ Copy rest of the application
COPY . .

# 6️⃣ Expose port
EXPOSE 3000

# 7️⃣ Start application
CMD ["npm", "start"]
