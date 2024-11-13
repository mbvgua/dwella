import { Router } from 'express'
import { addProperty, deleteProperty, getProperties, getPropertyBy, updateProperty } from '../controllers/properties.controllers'

const propertyRouter = Router()

propertyRouter.post('/add/:id', addProperty)
propertyRouter.get('',getProperties)
propertyRouter.get('/filter-by/',getPropertyBy)
propertyRouter.patch('/update/:id/',updateProperty)
propertyRouter.delete('/delete/:id/',deleteProperty)

export default propertyRouter