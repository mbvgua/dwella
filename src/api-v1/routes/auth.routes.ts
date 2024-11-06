import {Router} from 'express'

import { loginUser, registerUser } from '../controllers/auth.controllers'

// instantiate the Router
const authRouter=Router()

authRouter.post('/register',registerUser)
authRouter.post('/login',loginUser)


export default authRouter