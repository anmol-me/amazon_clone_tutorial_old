import Jwt from "jsonwebtoken";
import { User } from "../models/user.js";

export const admin = async (req, res, next) => {
    try {
        const token = req.header('x-auth-token');
        if (!token) {
            return res.status(401).json({ msg: 'CUSTOM: No Auth token, Access Denied.' });
        }

        const isVerified = Jwt.verify(token, 'passwordKey');
        if (!isVerified) return res.status(401).json({ msg: 'CUSTOM: Token verification failed, access denied.' });

        const user = await User.findById(isVerified.id);
        if (user.type == 'user' || user.type == 'seller') {
            return res.status(401).json({ msg: 'You are not an Admin' });
        }

        req.user = isVerified.id;
        req.token = token;
        next();
        // call next api function
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
}