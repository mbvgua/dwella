import {Request, Response} from 'express'
import { User } from '../models/auth.models'
import { updateUserSchema, emailOrSchema, userNameOrSchema, roleSchema } from '../validators/auth.validators'
import { DbHelper } from '../helpers/database.helpers'


const db = new DbHelper()   // instantiate the database helpers

// update user info
export async function updateUser(request:Request<{id:string}>, response:Response){
    /*
     * This function will update the users account details 
     * You cannot update the role or password via this 
     */

    const id = request.params.id
    const {firstName,lastName,userName,email,contactNumber} = request.body
    const {error} = updateUserSchema.validate(request.body)

    try{
        if(error){
            return response.status(400).send(error.message)
        } else {
            const user = (await db.exec('getUserById', {
                id
            })).recordset as Array<User>

            await db.exec('updateUser',{
                id,
                firstName,
                lastName,
                userName,
                email,
                contactNumber
            })

            return response.status(200).send({message:`Congratulations ${user[0].userName}! You're details have been updated successfully.`})
        }
    } catch(error) {
        return response.status(500).send({message:'Oh no! It looks like you do not have an account. Create one instead?'})
    }
}



// ADMIN ROLES. WILL NEED TOKENS TO ACCESS
// get users 
export async function getUsers(request:Request, response:Response){
    /*
     * This will return all the users in the database 
     * The stored procedure has been modified appropriately to prevent seeing 
     * anyone with their roleset to `admin`
     */
    try{
        const users = (await db.get('getUsers')).recordset as Array<User>
        if(users){
            return response.status(200).send(users)
        } else {
            return response.status(400).send({message:'Oh no! It looks like there are no users in your database.'})
        }

    } catch(error){
        return response.status(500).send(error)
    }
}

// get user by id
export async function getUserById(request:Request<{id:string}>, response:Response){
    /*
     * this return data for one specific user 
     * their id needs to be passed in the request parameters
     * if no user of the id exists, approriate error messages are returned
     */

    const id = request.params.id
    try {
        const user = (await db.exec('getUserById', {
            id 
        })).recordset[0] as User

        if (user){
            return response.status(200).send(user)
        } else {
            return response.status(400).send({message:'Oh no! It looks like that user does not exist. Try again?'})
        }
    } catch(error) {
        return response.status(500).send(error)
    }
}

// get user by email/username
export async function getUserByEmailOrUserName(request:Request, response:Response){
    /*
     * will fetch user details using either their email or username 
     * email will mostly be utilized by the admin
     * the username by normal users to search for people they know
     */

    const {emailOrUserName} = request.body
    const emailRegex = /^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$/

    try {
        if (emailRegex.test(emailOrUserName)){
            const {error} = emailOrSchema.validate(request.body)
            if (error){
                return response.status(400).send(error.message)
            } else {
                const user = (await db.exec('getUserByEmail', {
                    email:emailOrUserName
                })).recordset[0] as User

                if (user){
                    return response.status(200).send(user)
                } else {
                    return response.status(400).send({message:'Oops! It looks like there is no user with that username/email. Try again?'})
                }
            }
        } else if (!emailRegex.test(emailOrUserName)){
            const {error} = userNameOrSchema.validate(request.body)
            if (error){
                return response.status(400).send(error.message)
            } else {
                const user = (await db.exec('getUserByUserName',{
                    userName:emailOrUserName
                })).recordset[0] as User

                if (user){
                    return response.status(200).send(user)
                } else {
                    return response.status(400).send({message:'Oops! It looks like there is no user with that username/email. Try again?'})
                }
            }
        } 
    } catch(error){
        return response.status(500).send(error)
    }
}

// get users by roles
export async function getUserByRole(request:Request, response:Response){
    /*
     * will return users assigned a specific role within the app  
     */

    const {role} = request.body
    const {error} = roleSchema.validate(request.body)
    try {
        if (error){
            return response.status(400).send(error.message)
        } else {
            const users = (await db.exec('getUserByRole', {
                role
            })).recordset as Array<User>

            if (users.length !== 0){
                return response.status(200).send(users)
            } else {
                return response.status(400).send({message:'Oh no! It seems that there are no users with that role. Try again?'})
            }
        }
    } catch(error){
        return response.status(500).send(error)
    }
}