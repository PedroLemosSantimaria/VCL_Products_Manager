// server.js

const express = require('express');
const bodyParser = require('body-parser');
const { Pool } = require('pg');  // Biblioteca PostgreSQL
const app = express();
const PORT = 3000;

// Middleware para interpretar JSON no corpo das requisições
app.use(bodyParser.json());

// Configura o pool de conexões com o PostgreSQL
const pool = new Pool({
  user: 'seu_usuario',     // Substitua pelo nome do usuário do PostgreSQL
  host: 'localhost',
  database: 'productdb',
  password: 'sua_senha',   // Substitua pela senha do PostgreSQL
  port: 5432,
});

// Rota GET /products - Retorna todos os produtos
app.get('/products', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM products');
    res.json(result.rows);
  } catch (error) {
    console.error('Erro ao buscar produtos', error);
    res.status(500).json({ error: 'Erro ao buscar produtos' });
  }
});

// Rota GET /products/:id - Retorna um produto pelo ID
app.get('/products/:id', async (req, res) => {
  const productId = parseInt(req.params.id);
  try {
    const result = await pool.query('SELECT * FROM products WHERE id = $1', [productId]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Produto não encontrado' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao buscar produto', error);
    res.status(500).json({ error: 'Erro ao buscar produto' });
  }
});

// Rota POST /products - Cria um novo produto
app.post('/products', async (req, res) => {
  const { name, price } = req.body;

  try {
    const result = await pool.query(
      'INSERT INTO products (name, price) VALUES ($1, $2) RETURNING *',
      [name, price]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao criar produto', error);
    res.status(500).json({ error: 'Erro ao criar produto' });
  }
});

// Rota PUT /products/:id - Atualiza um produto pelo ID
app.put('/products/:id', async (req, res) => {
  const productId = parseInt(req.params.id);
  const { name, price } = req.body;

  try {
    const result = await pool.query(
      'UPDATE products SET name = $1, price = $2 WHERE id = $3 RETURNING *',
      [name, price, productId]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Produto não encontrado' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao atualizar produto', error);
    res.status(500).json({ error: 'Erro ao atualizar produto' });
  }
});

// Rota DELETE /products/:id - Remove um produto pelo ID
app.delete('/products/:id', async (req, res) => {
  const productId = parseInt(req.params.id);

  try {
    const result = await pool.query('DELETE FROM products WHERE id = $1 RETURNING *', [productId]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Produto não encontrado' });
    }
    res.status(204).send(); // Produto excluído com sucesso
  } catch (error) {
    console.error('Erro ao excluir produto', error);
    res.status(500).json({ error: 'Erro ao excluir produto' });
  }
});

// Inicia o servidor
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
