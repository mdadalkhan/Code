require('dotenv').config()


module.exports = {
	development:{
		client: 'mysql2',
    connection: {
    	database: process.env.DB_NAME,
    		host: process.env.DB_HOST,
    		user: process.env.DB_USER,
    	password: process.env.DB_PASSWORD
	    },
	     pool: {
	     	min: 2,
	     	max: 10
	     }
	}
}