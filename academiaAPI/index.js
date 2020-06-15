const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const port = 3000; //porta padrão


// Configurando o body parser para pegar POSTS
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());


// Definindo as rotas
const InstutorRoute = require('./routes/instrutor_routes');
const AulaRoute = require('./routes/aula_routes');
const RelatorioRoute = require('./routes/relatorio_route');
// const AlunoRoute = require('./routes/aluno_routes');


// Inicia o servidor
app.listen(port, () => console.log('API funcionando!'));

InstutorRoute(app);
AulaRoute(app);
RelatorioRoute(app);
