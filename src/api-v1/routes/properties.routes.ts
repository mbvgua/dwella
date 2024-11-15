import { Router } from 'express'
import { addProperty, deleteProperty, getProperties, getPropertyById, getPropertyByParams, updateProperty } from '../controllers/properties.controllers'

const propertyRouter = Router()

propertyRouter.post('/add/:id', addProperty)
propertyRouter.get('',getProperties)
propertyRouter.get('/search/',getPropertyByParams)
propertyRouter.get('/:id/',getPropertyById)
propertyRouter.patch('/update/:id/',updateProperty)
propertyRouter.delete('/delete/:id/',deleteProperty)

export default propertyRouter