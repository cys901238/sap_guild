require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const db = require('./db');
const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.json());

app.get('/api/ping', (req,res)=>{
  res.json({ok:true, time: new Date().toISOString()});
});

app.post('/api/users', async (req,res)=>{
  const {name} = req.body;
  if(!name) return res.status(400).json({error:'name is required'});
  try{
    const [result]= await db.query('INSERT INTO users (userid) VALUES (?)', [name]);
    return res.json({ok:true, id: result.insertId});
  }catch(err){
    console.error('db insert error', err);
    return res.status(500).json({error:err.message});
  }
});

app.listen(port, ()=>{
  console.log('backend listening on', port);
});
