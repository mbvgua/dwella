import { Request, Response } from 'express'
import { v4 as uid } from 'uuid'
import { DbHelper } from '../helpers/database.helpers'
import { addPropertySchema } from '../validators/properties.validators'
import { User } from '../models/auth.models'

import mssql from 'mssql'
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

	try {
		const {error} = addPropertySchema.validate(request.body)
		if(error){
			return response.status(400).send(error.message)		
		} else {
			const user = (await db.exec('getUserById', { id:userId })).recordset[0] as User
			if(user.role === 'owner' || user.role === 'admin'){
				// stored procedure didnt work
				// await db.exec('addProperty', {
				// 	id,
				// 	ownerId:userId,
				// 	name:name.toLowerCase(),
				// 	propertyType,
				// 	details,
				// 	location,
				// 	status
				// })

				// , let me try with a normal query
				const pool = await mssql.connect(sqlConfig)
				await pool.request()
				.input('id',id)
				.input('ownerId',userId)
				.input('name',name)
				.input('propertyType',propertyType)
				.input('details',{
					"description":details.description,
					"floors":details.floors,
					"rooms":details.rooms,
					"accessories":{
						"wifi":details.accessories.wifi,
						"pool":details.accessories.pool,
						"parking":details.accessories.parking
					}			
				})
				.input('location',{
					"addressLine":location.addressLine,
					"postalAddress":location.postalAddress,
					"cityOrTown":location.cityOrTown,
					"country":location.country					
				})
				.input('status',status)
				.execute('addProperty')
				// .query(`INSERT INTO properties VALUES 
				// 	(id,userId,name,propertyType,details,location,status,2022-03-11,0)`)

				return response.status(200).send({message:`Congratulations ${user.userName}! You have succesfully added ${name} to the application`})
			} else {
				return response.status(400).send({message:`Oh no! Your currently assigned role of ${user.role} does not allow you to add new properties into the application. Try contacting the administrator for further assistance.`})
			}
		}
	} catch(error) {
		return response.status(500).send(error)
	}
}	

// update existing property
// get property by value {id,county,accessories,propertyType e.t.c}
// get properties
// delete property
