import express from 'express';
import { admin } from '../middlewares/admin.js';
import { Product } from '../models/product.js';

export const adminRouter = express.Router();

// Add Product
adminRouter.post('/admin/add-product', admin, async (req, res) => {
    try {
        const { name, description, images, quantity, price, category } = req.body;

        let product = new Product({
            name,
            description,
            images,
            quantity,
            price,
            category,
        });

        product = product.save();
        // mongoDB return = model save

        res.json(product);
        // returned to client

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Get all Products
adminRouter.get('/admin/get-products', admin, async (req, res) => {
    try {
        const products = await Product.find({});
        res.json(products);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});