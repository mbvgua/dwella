import { Router } from 'express'
import { addProperty, getProperties, deleteProperty, updateProperty } from '../controllers/properties.controllers'

const propertyRouter = Router()

propertyRouter.post('/add/:id', addProperty)
propertyRouter.get('',getProperties)
propertyRouter.patch('/update/:id/',updateProperty)
propertyRouter.delete('/delete/:id/',deleteProperty)

export default propertyRouter