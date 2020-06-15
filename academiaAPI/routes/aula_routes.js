const mysql = require('mysql');
const dbConection = require('../db_config');

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

function AulaRoute(app) {
    app.route('/aulas')
        .get((req, res) => {
            if (Object.getOwnPropertyNames(req.query).length != 0) {
                const aula = "a.nome_aula LIKE '%" + req.query.aula + "%'";
                const instrutor = "i.nome LIKE '%" + req.query.instrutor + "%'";
                const diaSemana = "a.dia_semana LIKE '%" + req.query["dias-da-semana"] + "%'";
                const horario = "a.horario_inicio = '" + req.query.horario + "'";
                const sala = "sala = '" + req.query.sala + "'";
                const queryValues = [req.query.aula, req.query.instrutor, req.query["dias-da-semana"], req.query.horario, req.query.sala];
                const values = [aula, instrutor, diaSemana, horario, sala]; 

                // Constroi a query com a clausula WHERE conforme os parametros selecionados
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
                // quando não é passado um parametro, seleciona todas as aulas
                const sqlQuery = "SELECT * FROM aula as a LEFT JOIN instrutor as i " +
                                "on a.instrutor = i.id_instrutor " +
                                "ORDER BY a.nome_aula;";
                console.log(sqlQuery);

                selectAula(sqlQuery, res);
            }
        })
        .post((req, res) => {
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
        })
    app.route('/aulas/:id')
        .put((req, res) => {
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
        })
        .delete((req, res) => {
            const sqlQuery = "DELETE FROM aula WHERE id_aula = " + parseInt(req.params.id) + " ;";
            console.log(sqlQuery);
        
            execGenericSQLQuery(sqlQuery, res);
        })

}

module.exports = AulaRoute;