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


function InstrutorRoute(app) {
    app.route('/instrutores/:nomeOrId?')
        .get((req, res) => {
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
                // quando não é passado um parametro, seleciona todos os instrutores
                const sqlQuery = "SELECT * FROM instrutor ORDER BY nome;";
                console.log(sqlQuery);
        
                selectInstrutor(sqlQuery, res);
            }
        })
    app.route('/instrutores/')
        .post((req, res) => {
            const nome = req.body.nome;
            const identidade = req.body.identidade;
            const cpf = req.body.cpf;
            const atividade = req.body.atividade;
            const sqlQuery = "INSERT INTO instrutor " +
                            "(id_instrutor, nome, identidade, cpf, atividade) VALUES " +
                            `(DEFAULT, '${nome}', '${identidade}', '${cpf}', '${atividade}');`;
            console.log(sqlQuery);
        
            execGenericSQLQuery(sqlQuery, res);
        })
    app.route('/instrutores/:id')
        .put((req, res) => {
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
        })
        .delete((req, res) => {
            const sqlQuery = "DELETE FROM instrutor WHERE id_instrutor = " + parseInt(req.params.id) + " ;";
            console.log(sqlQuery);
        
            execGenericSQLQuery(sqlQuery, res);
        })
}

module.exports = InstrutorRoute;