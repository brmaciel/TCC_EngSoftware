const mysql = require('mysql');
const dbConnection  = require('../db_config');

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

function AlunoRoute(app) {
    app.route('/alunos/:comandoSQL?')
        .get((req, res) => {
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
        })
}

module.exports = AlunoRoute;