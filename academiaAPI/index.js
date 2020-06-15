const express = require('express');
const app = express();         
const bodyParser = require('body-parser');
const port = 3000; //porta padrão
const mysql = require('mysql');
const dbConection = require('./db_config');


// Configurando o body parser para pegar POSTS mais tarde
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());



// Definindo as rotas
const router = express.Router();
app.use('/', router); // requisicoes que chegam na raiz sao mandadas para o router
router.get('/', (req, res) => res.json({ message: 'Funcionando!' }));

const InstutorRoute = require('./routes/instrutor_routes');
const AulaRoute = require('./routes/aula_routes');
// const AlunoRoute = require('./routes/aluno_routes');



router.get('/relatorio', (req, res) => {
	// quando não é passado um parametro, seleciona todos os instrutores
	if (req.query.orderBy) {
		const orderBy = req.query.orderBy.toLowerCase();

		if (orderBy == "proximo-pagamento") {
			const orderByParam = "p.proximo_pagamento";

			selectRelatorio(orderByParam, res);
		} else {
			const orderByParam = "a.nome";

			selectRelatorio(orderByParam, res);
		}
	} else {
		const orderByParam = "a.nome";

		selectRelatorio(orderByParam, res);
	}
});


//inicia o servidor
app.listen(port);
console.log('API funcionando!');

InstutorRoute(app);
AulaRoute(app);




// Funcao para executar uma sqlQuery que sera passada
function execGenericSQLQuery(sqlQuery, res) {
	const connection = mysql.createConnection(dbConection);

	connection.query(sqlQuery, function(error, results, fields) {
		if (error)
			res.json(error);
		else
			res.json(results);
		connection.end();
		console.log('Query generica executada');
	});
}


function selectRelatorio(sortParam, res) {
	const sqlQuery = "SELECT * FROM aluno as a " +
					"JOIN endereco as e on a.endereco = e.id_endereco " +
					"JOIN pagamento as p on a.matricula = p.aluno " +
					"WHERE p.proximo_pagamento = (SELECT max(pp.proximo_pagamento) " +
												 "FROM pagamento as pp " +
												 "WHERE p.aluno = pp.aluno GROUP BY aluno) " +
					"ORDER BY " + sortParam + " ;"
	console.log(sqlQuery)

	const connection = mysql.createConnection(dbConection);
	
	connection.query(sqlQuery, function(error, results, fields) {
		var result = [], index = {};

		if (error)
			res.json(error);
		else
			results.forEach(function(row) {
				if (!(row.matricula in index)) {
					index[row.matricula] = {
						matricula: row.matricula,
						nome: row.nome,
						identidade: row.identidade,
						cpf: row.cpf,
						endereco: [],
						plano_atual: row.plano_atual,
						pagamento: []
					};
					result.push(index[row.matricula]);
				}

				index[row.matricula].endereco.push({
					id_endereco: row.id_endereco,
					rua: row.rua,
					numero: row.numero,
					complemento: row.complemento,
					cidade: row.cidade,
					estado: row.estado,
					cep: row.cep
				});

				index[row.matricula].pagamento.push({
					id_pagamento: row.id_pagamento,
					valor: row.valor,
					plano: row.plano,
					data_pagamento: row.data_pagamento,
					proximo_pagamento: row.proximo_pagamento
				});
			});
			res.json(result);
		connection.end();
		console.log('Busca por relatórios executada');
	});
}
