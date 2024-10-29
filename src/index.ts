import express,{ json }  from "express"
import authRouter from "./api-v1/routes/auth.routes"

const app = express()

app.use(json()) // add a body to requests


// define URLs within the application
app.use('/auth', authRouter)

app.listen(4000, ()=>{
    console.log('Backend server is running....')
})
