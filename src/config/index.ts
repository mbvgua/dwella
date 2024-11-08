import dotenv from 'dotenv'
import path from 'path'


// configure the path to the environmental variables
dotenv.config()
// why were we doing this yet the above also works?
// dotenv.config({ path:path.resolve(__dirname, '../../.env') })

// connecting the the sql-server
export const sqlConfig = {
    user: process.env.DB_USER,
    database: process.env.DB_NAME,
    password: process.env.DB_PWD,
    server: 'localhost',
    poll: {
        max: 10,
        min: 0,
        idleTimeoutMillis: 30000
    },
    options: {
        encrypt: false,
        trustServerCertificate: true
    }

}