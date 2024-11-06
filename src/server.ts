import express,{ json }  from "express"
import dotenv from "dotenv"
import authRouter from "./api-v1/routes/auth.routes"

// configure path to dotenv variables
dotenv.config()

const app = express()
const port = process.env.PORT

app.use(json()) // add a body to requests


// define URLs within the application
app.use('/auth', authRouter)



app.listen(port, ()=>{
    console.log(`[server]: Backend Server is running at http://localhost:${port}`)
})
