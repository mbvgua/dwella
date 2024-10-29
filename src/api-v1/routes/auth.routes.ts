import {Router} from 'express'

import { registerUser } from '../controllers/auth.controllers'

// instantiate the Router
const authRouter=Router()

authRouter.post('/register',registerUser)

export default authRouter