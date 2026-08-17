import { Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { db, UserEntity } from '../db';
import { AuthRequest } from '../middleware/auth.middleware';

const JWT_SECRET = process.env.JWT_SECRET || 'achieve_jwt_secret_dev_key_2026';

export class AuthController {
  static async register(req: Request, res: Response) {
    const { name, email, password } = req.body;
    if (!name || !email || !password) {
      return res.status(400).json({ error: 'Name, email, and password are required.' });
    }

    const existing = db.users.find((u) => u.email.toLowerCase() === email.toLowerCase());
    if (existing) {
      return res.status(409).json({ error: 'Email already registered.' });
    }

    const newUser: UserEntity = {
      id: `usr-${Date.now()}`,
      name,
      email: email.toLowerCase(),
      passwordHash: bcrypt.hashSync(password, 8),
      createdAt: new Date().toISOString(),
    };
    db.users.push(newUser);

    const token = jwt.sign({ userId: newUser.id, email: newUser.email }, JWT_SECRET, {
      expiresIn: '30d',
    });

    return res.status(201).json({
      user: { id: newUser.id, name: newUser.name, email: newUser.email },
      token,
    });
  }

  static async login(req: Request, res: Response) {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password are required.' });
    }

    const user = db.users.find((u) => u.email.toLowerCase() === email.toLowerCase());
    if (!user) {
      return res.status(401).json({ error: 'Invalid email or password.' });
    }

    const valid = bcrypt.compareSync(password, user.passwordHash);
    if (!valid) {
      return res.status(401).json({ error: 'Invalid email or password.' });
    }

    const token = jwt.sign({ userId: user.id, email: user.email }, JWT_SECRET, {
      expiresIn: '30d',
    });

    return res.json({
      user: { id: user.id, name: user.name, email: user.email },
      token,
    });
  }

  static async me(req: AuthRequest, res: Response) {
    const user = db.users.find((u) => u.id === req.userId);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    return res.json({ id: user.id, name: user.name, email: user.email });
  }
}
