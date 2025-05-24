const express = require('express');
const mysql = require('mysql2/promise');
const bodyParser = require('body-parser');
const { v4: uuidv4 } = require('uuid');
const fs = require('fs');
const path = require('path');

const app = express();
app.use(bodyParser.json());

const dbConfig = {
  host: 'localhost',
  user: 'root',
  password: 'YOUR_PASSWORD',
  port: 3306,
  database: 'skybattles'
};

app.post('/register', async (req, res) => {
  const { username, password, displayname } = req.body;
  if (!username || !password || !displayname) return res.status(400).json({ message: 'Missing fields' });

  const conn = await mysql.createConnection(dbConfig);
  const [existing] = await conn.execute('SELECT * FROM users WHERE username = ?', [username]);
  if (existing.length > 0) {
    await conn.end();
    return res.status(409).json({ message: 'Username already exists' });
  }

  const userId = uuidv4();
  await conn.execute('INSERT INTO users (id, username, password, displayname) VALUES (?, ?, ?, ?)', [userId, username, password, displayname]);
  await conn.end();

  const userDir = path.join(__dirname, 'Users', userId);
  fs.mkdirSync(userDir, { recursive: true });
  fs.writeFileSync(path.join(userDir, 'username.txt'), username);
  fs.writeFileSync(path.join(userDir, 'displayname.txt'), displayname);
  fs.writeFileSync(path.join(userDir, 'skycoins.txt'), '0');

  res.status(201).json({ message: 'Account created' });
});

app.listen(3000, () => console.log('Listening on http://localhost:3000'));
