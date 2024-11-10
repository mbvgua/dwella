import Joi from 'joi'


export const addPropertySchema = Joi.object({
	name: Joi.string().required().min(3).max(100).messages({
		'string.base':'Name should be of type text',
		'string.empty':'Name is required',
		'string.min':'Name should have a minimum of {#length} characters',
		'string.max':'Name should have a maximum of {#length} characters',
		// 'string.pattern.base':'Only lower case letters can be used for the name',
		'any.required':'Name is required'
	}),
	propertyType: Joi.string().required().valid('apartment','commercial','hostel').pattern(
		new RegExp('^[a-z]+$')
	).messages({
		'string.base':'The property should be of type text',
		'string.empty':'The property type is required',
		'any.only':'The Propery can only be an apartment, commercial residence or hostels',
		'string.pattern.base':'Only lower case letters can be used for the property type'
	}),
	details: Joi.object({
		description: Joi.string().required(),
		floors: Joi.number().required(),
		rooms: Joi.number().required(),
		accessories: Joi.object({
			wifi:Joi.string().required().valid('yes','no'),
			pool:Joi.string().required().valid('yes','no'),
			parking:Joi.string().required().valid('yes','no')
		}),
	}),
	location: Joi.object({
		addressLine: Joi.string().required().messages({
			'string.base':'Address should be of type text',
			'string.required':'Address is required',
			'any.required':'Address is required'
		}),
		postalAddress: Joi.string().required().messages({
			'string.base':'Address should be of type text',
			'string.required':'Address is required',
			'any.required':'Address is required'
		}),
		cityOrTown: Joi.string().required().messages({
			'string.base':'City/Town should be of type text',
			'string.required':'City/Town is required',
			'any.required':'City/Town is required'
		}),
		country: Joi.string().required().messages({
			'string.base':'Country should be of type text',
			'string.required':'Country is required',
			'any.required':'Country is required'
		})
	}),
	status: Joi.string().required().valid('available', 'not vailable').messages({
		'string.base':'Status should be of type text',
		'string.empty':'Status is required',
		'any.only':'The status can either be available or not available'
	})
})
