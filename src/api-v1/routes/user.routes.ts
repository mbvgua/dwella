import { Router } from 'express'
import { getUserByEmailOrUserName, getUserById, getUserByRole, getUsers, updateUser } from '../controllers/users.controllers'

const userRouter = Router()     //instantiate the router

userRouter.get('',getUsers)
userRouter.get('/mail-or-name/',getUserByEmailOrUserName)
userRouter.get('/role/',getUserByRole)
userRouter.get('/:id/',getUserById)
userRouter.patch('/update/:id/',updateUser)


export default userRouter