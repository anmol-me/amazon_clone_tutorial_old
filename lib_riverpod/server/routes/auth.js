import express from 'express';
import { User } from '../models/user.js';
import bcryptjs from 'bcryptjs';
import Jwt from 'jsonwebtoken';
import { auth } from '../middlewares/auth.js';

export const authRouter = express.Router();

// Client --> Server
authRouter.post("/api/signup", async (req, res) => {
    try {
        const { name, email, password } = req.body;

        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ msg: "Email already exists!" });
        }

        const hashedPassword = await bcryptjs.hash(password, 8);

        let user = new User({
            email,
            password: hashedPassword,
            name,
        });

        user = await user.save();
        res.json(user);
        // res.json({user: user});
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});


authRouter.post('/api/signin', async (req, res) => {
    try {
        const { email, password } = req.body;

        const user = await User.findOne({ email });
        if (!user) {
            return res.status(400).json({ msg: 'User email does not exist' });
        }

        const isMatch = await bcryptjs.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ msg: "Incorrect password" });
        }

        const token = Jwt.sign({ id: user._id }, "passwordKey");
        res.json({ token, ...user._doc });
        // Creates a map with user data plus token key:value
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Checking User
authRouter.post('/tokenIsValid', async (req, res) => {
    try {
        const token = req.header('x-auth-token');
        if (!token) return res.json(false);

        const isVerified = Jwt.verify(token, 'passwordKey');

        if (!isVerified) return res.json(false);

        const user = await User.findById(isVerified.id);
        if (!user) return res.json(false);

        res.json(true);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

/// Sending user Data
// auth = middleware
authRouter.get('/', auth, async (req, res) => {
    const user = await User.findById(req.user);
    res.json({ ...user._doc, token: req.token });
});

authRouter.get('/', (req, res) => {
    res.json({ hey: "man" });
});

// module.exports = authRouter;