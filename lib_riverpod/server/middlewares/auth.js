import Jwt from "jsonwebtoken";

// A middleware to perform all the verification and store user id
export const auth = async (req, res, next) => {
    try {
        const token = req.header('x-auth-token');
        if (!token) {
            return res.status(401).json({ msg: 'CUSTOM: No Auth token, Access Denied.' });
        }

        const isVerified = Jwt.verify(token, 'passwordKey');
        if (!isVerified) return res.status(401).json({ msg: 'CUSTOM: Token verification failed, access denied.' });

        req.user = isVerified.id;
        req.token = token;
        next();
        // call next api function
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
}