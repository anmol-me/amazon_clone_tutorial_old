import express from 'express';
import mongoose from 'mongoose';

import { authRouter } from './routes/auth.js';
import { adminRouter } from './routes/admin.js';


// INIT
const PORT = 3000;
const DB = 'mongodb+srv://anmol:sentinel00@cluster0.ujbbl.mongodb.net/?retryWrites=true&w=majority';
const app = express();

// MIDDLEWARE
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);

// Connections
mongoose.connect(DB).then(() => {
    console.log('DB Connection Successful');
}).catch((e) => {
    console.log(e);
});


app.listen(PORT, "0.0.0.0", () => {
    console.log(`CONNECTED AT PORT: ${PORT}`);
});
