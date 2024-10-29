import Joi from 'joi'

export const registerSchema = Joi.object({
    firstName: Joi.string().required().min(3).max(50).messages({
        'string.base':'First Name should be of type text',
        'string.empty':'First Name is required',
        'string.min':'First Name should have a minimum length of {#length} characters',
        'string.max':'First Name should have a minimum length of {#length} characters',
        'any.required':'First Name is required'
    }),
    lastName: Joi.string().required().min(3).max(50).messages({
        'string.base':'Last Name should be of type text',
        'string.empty':'Last Name is required',
        'string.min':'Last Name should have a minimum length of {#length} characters',
        'string.max':'Last Name should have a minimum length of {#length} characters',
        'any.required':'Last Name is required'
    }),
    userName: Joi.string().required().min(1).max(20).messages({
        'string.base':'Username should be of type text',
        'string.empty':'Username is required',
        'string.min':'Username should have a minimum length of {#length} characters',
        'string.max':'Username should have a minimum length of {#length} characters',
        'any.required':'Username is required'
    }),
    email: Joi.string().required().email().messages({
        'string.base':'Email should be of type text',
        'string.empty':'Email is required',
        'any.required':'Email is required'
    }),
    contactNumber: Joi.string().required().min(10).messages({
        'string.base':'Contact Number should be of type number',
        'string.empty':'Contact Number is required',
        'string.min':'Contact Number should have a minimum length of {#length} characters',
        'string.max':'Contact Number should have a maximum length of {#length} characters',
        'any.required':'Contact number is required'
    }),
    password: Joi.string().required().pattern(
        new RegExp('^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{6,10}$')
    ).messages({
        'string.base':'Password should be of type text',
        'string.empty':'Password is required',
        'string.min':'Password should have a minimum length of {#length} characters',
        'string.max':'Password should have a maximum length of {#length} characters',
        'any.required':'Password is required',
        'string.pattern.base':'Password must contain at least one lowercase letter, one uppercase letter, one digit, and one special character'
    }),
    role: Joi.string().required().valid('maintenance','manager','tenant','owner').messages({
        'string.base': 'Role should be of type text',
        'any.required': 'Role is required',
        'any.only': 'Role can either be maintenance, manager,tenant or owner' 
    })
})