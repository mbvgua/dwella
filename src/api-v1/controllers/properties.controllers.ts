import { Request, Response } from 'express'
import { v4 as uid } from 'uuid'
import mssql from 'mssql'
import { DbHelper } from '../helpers/database.helpers'
import { addPropertySchema, deletePropertySchema, getPropertySchema, updatePropertySchema } from '../validators/properties.validators'
import { User } from '../models/auth.models'
import { Property } from '../models/properties.models'
import { propertyFilterQuery } from '../helpers/search.helpers'
import { sqlConfig } from '../../config'


const db = new DbHelper()	// instantiate the database

// add a property
export async function addProperty(request:Request<{id:string}>, response:Response){
	/* 
	 * this function will add new properties to the database
	 * properties can only be added by users of either role admin/owner
	 * else appropriate error messages will be returned
	 */	

	const id = uid()
	const userId = request.params.id
	const { name,propertyType,details,location,status } = request.body

	// convert the nested elements to JSON
	const detailsJson = JSON.stringify(details)
	const locationJson = JSON.stringify(location)

	try {
		const {error} = addPropertySchema.validate(request.body)
		if(error){
			return response.status(400).send(error.message)		
		} else {
			const user = (await db.exec('getUserById', { id:userId })).recordset[0] as User

			if(user.role === 'admin' || user.role === 'owner'){
				await db.exec('addProperty', {
					id,
					ownerId:userId,
					name,
					propertyType,
					detailsJson:detailsJson,
					locationJson:locationJson,
					status
				})

				return response.status(200).send({message:`Congratulations ${user.userName}! You have succesfully added ${name} to the application`})
			} else {
				return response.status(400).send({message:`Oh no! Your currently assigned role of ${user.role} does not allow you to add new properties into the application. Try contacting the administrator for further assistance.`})
			}
		}
	} catch(error) {
		return response.status(500).send({error:`Internal server error: ${error}`})
	}
}	

// get properties
export async function getProperties(request:Request, response:Response){
	/*
	 * this function will return all properties in the database
	 */

	try{
		const properties = (await db.get('getProperties')).recordset as Array<Property>
		if (properties.length == 0) {
			return response.status(400).json({error:'There are currently no properties in the system. Try adding some?'})
		} else {
			return response.status(200).json({properties:properties})
		}
	} catch(error){
		return response.status(500).json({error:`Internal server error: ${error}`})
	}
}

// get property by id
export async function getPropertyById(request:Request, response:Response){
	/*
	 * get a property from th egiven id 
	 */

	const id = request.params.id
	try{
		const property = (await db.exec('getPropertyById',{
			id
		})).recordset as Array<Property>
		if(property.length !== 0){
			return response.status(200).json({property})
		} else {
			return response.status(400).json({error:'Oops! There is not property with that id. Try again?'})
		}
	} catch(error){
		return response.status(500).json({error:`Internal server error: ${error}`})
	}
}


// get property by value//
export async function getPropertyByParams(request:Request, response:Response){
	/*
	 * this function will return a property based on a certain filter 
	 * this might be {getById,getByLocation,getBystatus,getByPropertyType,getByDetails} 
	 */

	const {name,propertyType,details,location,status} = request.body
	try{
		const {error} = getPropertySchema.validate(request.body)
		if(error){
			return response.status(400).json({error:error.message})
		} else {
			const {filters,values} = propertyFilterQuery(request.body)
			console.log(`filters => ${filters}`)
			console.log(values)
			let query = " SELECT * FROM properties" 
			if(filters){
				// the spacing before WHERE is everything!! :(
				query += ` WHERE ${filters} AND isDeleted=0;`
			}
			console.log(`query => ${query}`)
			// connect to database
			const pool = await mssql.connect(sqlConfig)
			const sqlRequest = pool.request()

			// inject parameters into request
			Object.keys(values).forEach(key =>{
				sqlRequest.input(key,values[key])
			})

			// execute query
			const properties = (await sqlRequest.query(query)).recordset as Array<Property>
			console.log(query)
			if(properties.length !== 0){
				return response.status(200).json(properties)
			} else {
				return response.status(400).json({error:`Oh no! It looks like no property exists with the above specification. Try again? `})
			}
		}
	} catch(error){
		// return response.status(500).json({error:`Internal server error: ${error}`})
	}
}


// update existing property
export async function updateProperty(request:Request<{id:string}>, response:Response){
	/**
	 * this is aimed at updating the properties appropriately
	 * the stored procedure demands that all values be inputted
	 * as such add the logic in the frontend
	 * if the values are not altered, it inputs the previous values as placeholders
	 * if user inputs values, they are usd instead
	 */

	const propertyId = request.params.id
	const {name,propertyType,status,details,location} = request.body

	// format nested JSON to string. allow insert in mssql db
	const detailsJSON = JSON.stringify(details)
	const locationJSON = JSON.stringify(location)
	try {
		const {error} = updatePropertySchema.validate(request.body)
		if (error){
			return response.status(400).send(error.message)
		} else {
			const property = (await db.exec('getPropertyById', {id:propertyId})).recordset[0] as Property
			if (property){
				await db.exec('updateProperty',{
					id:propertyId,
					name,
					propertyType,
					detailsJson:detailsJSON,
					locationJson:locationJSON,
					status
				})
				return response.status(200).json({message:`Congratulations! ${property.name} has successfully been updated.`})
			} else {
				return response.status(400).json({error:`Oops! Looks like that property does not exist. Try again?`})
			}
		}
	} catch(error){
		return response.status(500).json({error:`Internal server error: ${error}`})
	}
}


// delete property
export async function deleteProperty(request:Request<{id:string}>, response:Response){
	/**
	 * this function deletes a property from the application
	 * Soft delete will be used
	 * You must have a role of either owner or admin to delete properties
	 * if not, appropriate error messages will be returnes
	 */

	const propertyId = request.params.id
	const {userId} = request.body
	try {
		const {error} = deletePropertySchema.validate(request.body)
		if (error){
			return response.status(400).send(error.message)
		} else {
			const user = (await db.exec('getUserById',{id:userId})).recordset[0] as User

			if (user.role === 'admin' || user.role === 'owner'){
				const property = (await db.exec('getPropertyById',{
					id:propertyId
				})).recordset as Array<Property>
				
				if (property.length !== 0){
					await db.exec('deleteProperty',{id:propertyId})
					return response.status(200).json({message:`${property[0].name} has successfully been deleted`})
				} else {
					return response.status(200).json({error:`That property does not exist. Try again?`})
				}
			} else {
				return response.status(400).json({error:`Oh no! You're currently assigned role of ${user.role} does not allow you delete existing properties. Contact the administrator for further information.`})
			}
		}
	} catch(error){
		return response.status(500).send({error:`Internal server error: ${error}`})
	}
}
