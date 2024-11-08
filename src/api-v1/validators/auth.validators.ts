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
    email: Joi.string().required().email({minDomainSegments:2,tlds:{allow:['com','net']}}).messages({
        'string.base':'Email should be of type text',
        'string.empty':'Email is required',
        'string.email':'email can only have two domains, e.g example.com whose tlds can either be ".com" or ".net"',
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

export const emailLoginSchema = Joi.object({
    emailOrUserName: Joi.string().required().email({minDomainSegments:2,tlds:{allow:['com','net']}}).messages({
        'string.base':'Email should be of type text',
        'string.empty':'Email is required',
        'string.email':'email can only have two domains, e.g example.com whose tlds can either be ".com" or ".net"',
        'any.required':'Email is required'
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
    })
})

export const usernameLoginSchema = Joi.object({
    emailOrUserName: Joi.string().required().min(1).max(20).messages({
        'string.base':'Username should be of type text',
        'string.empty':'Username is required',
        'string.min':'Username should have a minimum length of {#length} characters',
        'string.max':'Username should have a maximum length of {#length} characters',
        'any.required':'Username is required'
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
    })
})

export const emailOrSchema = Joi.object({
    emailOrUserName: Joi.string().required().email({minDomainSegments:2,tlds:{allow:['com','net']}}).messages({
        'string.base':'Email should be of type text',
        'string.empty':'Email is required',
        'string.email':'email can only have two domains, e.g example.com whose tlds can either be ".com" or ".net"',
        'any.required':'Email is required'
    })
})

export const userNameOrSchema = Joi.object({
    emailOrUserName: Joi.string().required().min(1).max(20).messages({
        'string.base':'Username should be of type text',
        'string.empty': 'Username is required',
        'string.min': 'Username should have a minimum length of {#length} characters',
        'string.max': 'USername should have a maximum length of {#length} characters',
        'any.required': 'Username is required'
    })
})

export const changePasswordSchema = Joi.object({
    newPassword: Joi.string().required().pattern(
        new RegExp('^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{6,10}$')
    ).messages({
        'string.base':'The new password should be of type text',
        'string.empty':'The new password is required',
        'string.min':'The new password should have a minimum length of {#length} characters',
        'string.max':'The new password should have a maximum length of {#length} characters',
        'any.required':'The new password is required',
        'string.pattern.base':'The new password must contain at least one lowercase letter, one uppercase letter, one digit, and one special character'
    }),
    confirmNewPassword: Joi.ref('newPassword'),
})

export const updateUserSchema = Joi.object({
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
    email: Joi.string().required().email({minDomainSegments:2,tlds:{allow:['com','net']}}).messages({
        'string.base':'Email should be of type text',
        'string.empty':'Email is required',
        'string.email':'email can only have two domains, e.g example.com whose tlds can either be ".com" or ".net"',
        'any.required':'Email is required'
    }),
    contactNumber: Joi.string().required().min(10).messages({
        'string.base':'Contact Number should be of type number',
        'string.empty':'Contact Number is required',
        'string.min':'Contact Number should have a minimum length of {#length} characters',
        'string.max':'Contact Number should have a maximum length of {#length} characters',
        'any.required':'Contact number is required'
    }),
})

export const roleSchema = Joi.object({
    role: Joi.string().required().valid('maintenance','manager','tenant','owner').messages({
        'string.base': 'Role should be of type text',
        'any.required': 'Role is required',
        'any.only': 'Role can either be maintenance, manager,tenant or owner' 
    })
})