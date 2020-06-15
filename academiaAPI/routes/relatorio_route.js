const mysql = require('mysql')
const dbConection = require('../db_config')


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


function RelatorioRoute(app) {
    app.route('/relatorio')
        .get((req, res) => {
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
        })
}

module.exports = RelatorioRoute;