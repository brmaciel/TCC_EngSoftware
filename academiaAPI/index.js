const express = require('express');
const app = express();         
const bodyParser = require('body-parser');
const port = 3000; //porta padrão
const mysql = require('mysql');
const dbConection = require('./db_config');


// Configurando o body parser para pegar POSTS
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());


// Definindo as rotas
const router = express.Router();
app.use('/', router); // requisicoes que chegam na raiz sao mandadas para o router
router.get('/', (req, res) => res.json({ message: 'Funcionando!' }));

const InstutorRoute = require('./routes/instrutor_routes');
const AulaRoute = require('./routes/aula_routes');
const RelatorioRoute = require('./routes/relatorio_route');
// const AlunoRoute = require('./routes/aluno_routes');


// Inicia o servidor
app.listen(port);
console.log('API funcionando!');

InstutorRoute(app);
AulaRoute(app);
RelatorioRoute(app);
