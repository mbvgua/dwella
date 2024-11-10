import {Router} from 'express'
import { changePassword, deleteUser, forgotPassword, loginUser, registerUser } from '../controllers/auth.controllers'

// instantiate the Router
const authRouter=Router()

authRouter.post('/register/',registerUser)
authRouter.post('/login/',loginUser)
authRouter.post('/forgot-password/',forgotPassword)
authRouter.post('/change-password/:id/',changePassword)
authRouter.delete('/delete/:id/',deleteUser)


export default authRouter