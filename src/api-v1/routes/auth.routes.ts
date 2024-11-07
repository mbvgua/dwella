import {Router} from 'express'

import { changePassword, forgotPassword, loginUser, registerUser } from '../controllers/auth.controllers'

// instantiate the Router
const authRouter=Router()

authRouter.post('/register',registerUser)
authRouter.post('/login',loginUser)
authRouter.post('/forgot-password',forgotPassword)
authRouter.post('/change-password',changePassword)


export default authRouter