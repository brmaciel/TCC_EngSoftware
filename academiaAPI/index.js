const express = require('express');
const app = express();         
const bodyParser = require('body-parser');
const port = 3000; //porta padrão
const mysql = require('mysql');
const dbConection = {
	host     : '192.168.64.2',
	port     : '3306',
	user     : 'root',
	password : '',
	database : 'academia2'
};

//configurando o body parser para pegar POSTS mais tarde
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

//definindo as rotas
const router = express.Router();
// Metodos GET
router.get('/', (req, res) => res.json({ message: 'Funcionando!' }));

router.get('/alunos/:comandoSQL?', (req, res) => {
	// quando não é passado um parametro, seleciona todos os alunos
	if (req.params.comandoSQL) {
		const sqlQuery = req.params.comandoSQL.toLowerCase();
		console.log(sqlQuery);
		if (sqlQuery.startsWith("select") && sqlQuery.endsWith(";")) {
			selectAluno(sqlQuery, res);
		} else {
			console.log("SQL Request not accepted!");
		}
	} else {
		selectAluno("SELECT * FROM Aluno as a LEFT JOIN Endereco as e on a.endereco = e.id_endereco;".toLowerCase(), res);
	}
	
});


// Metodos GET
router.get('/instrutores/:nomeOrId?', (req, res) => {
	// quando não é passado um parametro, seleciona todos os instrutores
	if (req.query.atividade) {
		console.log(req.query);
		const atividade = req.query.atividade;

		const sqlQuery = "SELECT * FROM instrutor " +
						 `WHERE atividade = '${atividade}' ` +
						 "ORDER BY nome;";
		console.log(sqlQuery);

		selectInstrutor(sqlQuery, res);
	} else if (req.params.nomeOrId) {
		const searchValue = req.params.nomeOrId;

		const sqlQuery = "SELECT * FROM instrutor " + 
						 `WHERE nome LIKE '%${searchValue}%' OR id_instrutor LIKE '%${searchValue}%' ` +
						 "ORDER BY nome;";
		console.log(sqlQuery);

		selectInstrutor(sqlQuery, res);
	} else {
		const sqlQuery = "SELECT * FROM instrutor ORDER BY nome;";
		console.log(sqlQuery);

		selectInstrutor(sqlQuery, res);
	}
});

router.get('/aulas', (req, res) => {
	// quando não é passado um parametro, seleciona todas as aulas
	if (Object.getOwnPropertyNames(req.query).length != 0) {
		const aula = "a.nome_aula LIKE '%" + req.query.aula + "%'";
		const instrutor = "i.nome LIKE '%" + req.query.instrutor + "%'";
		const diaSemana = "a.dia_semana LIKE '%" + req.query["dias-da-semana"] + "%'";
		const horario = "a.horario_inicio = '" + req.query.horario + "'";
		const sala = "sala = '" + req.query.sala + "'";
		const queryValues = [req.query.aula, req.query.instrutor, req.query["dias-da-semana"], req.query.horario, req.query.sala];
		const values = [aula, instrutor, diaSemana, horario, sala]; 

		var multipleCondition = false;
		var whereStatement = "";
		for (var i = 0; i < values.length; i++) {
			if (queryValues[i]) {
				whereStatement += values[i];
				multipleCondition = true;
			}
			if (multipleCondition && i < values.length-1 && queryValues[i+1]) {
				whereStatement += " AND ";
			}
		}
		if (whereStatement != "") {
			whereStatement = "WHERE ".concat(whereStatement);
		}

		const sqlQuery = "SELECT * FROM aula as a LEFT JOIN instrutor as i " +
						 "on a.instrutor = i.id_instrutor " +
						 whereStatement + " ORDER BY a.nome_aula;";
		console.log(sqlQuery);

		selectAula(sqlQuery, res);
	} else {
		const sqlQuery = "SELECT * FROM aula as a LEFT JOIN instrutor as i " +
						 "on a.instrutor = i.id_instrutor " +
						 "ORDER BY a.nome_aula;";
		console.log(sqlQuery);

		selectAula(sqlQuery, res);
	}
});

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



// Métodos POST
router.post('/instrutores', (req, res) => {
	const nome = req.body.nome;
	const identidade = req.body.identidade;
	const cpf = req.body.cpf;
	const atividade = req.body.atividade;
	const sqlQuery = "INSERT INTO instrutor " +
					 "(id_instrutor, nome, identidade, cpf, atividade) VALUES " +
					 `(DEFAULT, '${nome}', '${identidade}', '${cpf}', '${atividade}');`;
	console.log(sqlQuery);

	execGenericSQLQuery(sqlQuery, res);
});

router.post('/aulas', (req, res) => {
	const nomeAula = req.body.nome;
	const horarioInicio = req.body.horarioInicio;
	const horarioFim = req.body.horarioFim;
	const diaSemana = req.body.diasDaSemana;
	const sala = req.body.sala;
	var instrutorId = ""
	if (!req.body.instrutor) {
		console.log("Não tem instrutor");
		instrutorId = "null"
	} else {
		instrutorId = "'" + req.body.instrutor._id + "'";
	}
	

	const sqlQuery = "INSERT INTO aula " +
					 "(id_aula, nome_aula, horario_inicio, horario_fim, dia_semana, sala, instrutor) VALUES " +
					 `(DEFAULT, '${nomeAula}', '${horarioInicio}', '${horarioFim}', '${diaSemana}', '${sala}', ${instrutorId});`;
	console.log(req.body);
	console.log(sqlQuery);

	execGenericSQLQuery(sqlQuery, res);
});


// Métodos PUT
router.put('/instrutores/:id', (req, res) => {
	const nome = req.body.nome;
	const identidade = req.body.identidade;
	const cpf = req.body.cpf;
	const atividade = req.body.atividade;

	const sqlQuery = "UPDATE instrutor SET " +
					 `nome = '${nome}', identidade = '${identidade}', ` +
					 `cpf = '${cpf}', atividade = '${atividade}' ` +
					 "WHERE id_instrutor = " + parseInt(req.params.id) + " ;";
	console.log(req.body);
	console.log(sqlQuery);

	execGenericSQLQuery(sqlQuery, res);
});

router.put('/aulas/:id', (req, res) => {
	const nomeAula = req.body.nome;
	const horarioInicio = req.body.horarioInicio;
	const horarioFim = req.body.horarioFim;
	const diaSemana = req.body.diasDaSemana;
	const sala = req.body.sala;
	var instrutorId = ""
	if (!req.body.instrutor) {
		console.log("Não tem instrutor");
		instrutorId = "null"
	} else {
		instrutorId = "'" + req.body.instrutor._id + "'";
	}

	const sqlQuery = "UPDATE aula SET " +
					 `nome_aula = '${nomeAula}', horario_inicio = '${horarioInicio}', ` +
					 `horario_fim = '${horarioFim}', dia_semana = '${diaSemana}', ` +
					 `sala = '${sala}', instrutor = ${instrutorId} ` +
					 "WHERE id_aula = " + parseInt(req.params.id) + " ;";
	console.log(req.body);
	console.log(sqlQuery);

	execGenericSQLQuery(sqlQuery, res);
});

// Métodos DELETE
router.delete('/instrutores/:id', (req, res) => {
	const sqlQuery = "DELETE FROM instrutor WHERE id_instrutor = " + parseInt(req.params.id) + " ;";
	console.log(sqlQuery);

	execGenericSQLQuery(sqlQuery, res);
});

router.delete('/aulas/:id', (req, res) => {
	const sqlQuery = "DELETE FROM aula WHERE id_aula = " + parseInt(req.params.id) + " ;";
	console.log(sqlQuery);

	execGenericSQLQuery(sqlQuery, res);
});

app.use('/', router); // requisicoes que chegam na raiz sao mandadas para o router

//inicia o servidor
app.listen(port);
console.log('API funcionando!');




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


function selectAluno(sqlQuery, res) {
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
						plano: row.plano_atual
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
			});
			res.json(result);
		connection.end();
		console.log('Busca por aluno executada');
	});
}


function selectAula(sqlQuery, res) {
	const connection = mysql.createConnection(dbConection);
	
	connection.query(sqlQuery, function(error, results, fields) {
		var result = [], index = {};

		if (error)
			res.json(error);
		else
			results.forEach(function(row) {
				if (!(row.id_aula in index)) {
					index[row.id_aula] = {
						id_aula: row.id_aula,
						nome_aula: row.nome_aula,
						horario_inicio: row.horario_inicio,
						horario_fim: row.horario_fim,
						dia_semana: row.dia_semana,
						sala: row.sala,
						instrutor: []
					};
					result.push(index[row.id_aula]);
				}
				index[row.id_aula].instrutor.push({
					id_instrutor: row.id_instrutor,
					nome: row.nome,
					identidade: row.identidade,
					cpf: row.cpf,
					atividade: row.atividade
				});
			});
			res.json(result);
		connection.end();
		console.log('Busca por aula executada');
	});
}


function selectInstrutor(sqlQuery, res) {
	const connection = mysql.createConnection(dbConection);

	connection.query(sqlQuery, function(error, results, fields) {
		if (error)
			res.json(error);
		else
			res.json(results);
		connection.end();
		console.log('Busca por instrutor executada');
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
